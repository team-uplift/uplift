package org.upLift.services;

import jakarta.transaction.Transactional;
import jakarta.validation.Valid;

import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.upLift.exceptions.ModelException;
import org.upLift.exceptions.TimingException;
import org.upLift.model.FormQuestion;
import org.upLift.model.Recipient;
import org.upLift.model.RecipientTag;
import org.upLift.model.Tag;
import org.upLift.repositories.RecipientRepository;
import org.upLift.repositories.RecipientTagsRepository;
import org.upLift.repositories.TagRepository;

import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.concurrent.atomic.AtomicReference;

@Service
@Transactional
public class RecipientServiceImpl implements RecipientService {

	private final RecipientRepository recipientRepository;

	private final BedrockService bedrockService;

	private final TagRepository tagRepository;

	private final RecipientTagsRepository recipientTagsRepository;

	public RecipientServiceImpl(RecipientRepository recipientRepository, BedrockService bedrockService,
			TagRepository tagRepository, RecipientTagsRepository recipientTagsRepository) {
		this.recipientRepository = recipientRepository;
		this.bedrockService = bedrockService;
		this.tagRepository = tagRepository;
		this.recipientTagsRepository = recipientTagsRepository;
	}

	@Override
	public Recipient saveRecipient(Recipient recipient) {
		return recipientRepository.save(recipient);
	}

	/**
	 * This method takes in a recipient ID and assumes the FormQuestions have been set for the
	 *
	 * @param id
	 * @param formQuestions
	 * @return
	 */
	@Override
	public List<RecipientTag> generateRecipientTags(Integer id, List<FormQuestion> formQuestions) {
		Recipient recipient = recipientRepository.findById(id).orElse(null);

		if (recipient != null) {
			if(canGenerateTags(recipient)) {
				AtomicReference<String> recipient_prompt = new AtomicReference<>("");

				if (formQuestions != null && !formQuestions.isEmpty()) {
					// Set the latest form questions if provided.
					recipient.setFormQuestions(formQuestions);
				}

				// Consolidate all form questions into a single string to invoke the tag generation service.
				recipient.getFormQuestions().forEach(formQuestion -> {
					recipient_prompt.set(STR."\{recipient_prompt} \{formQuestion.getAnswer()}");
				});

				// Only generate tags if there is a valid prompt
				if(!recipient_prompt.get().isEmpty()) {
					Map<String, Double> newTags = bedrockService.getTagsFromPrompt(recipient_prompt.get());

					for (Map.Entry<String, Double> entry : newTags.entrySet()) {
						String tag = entry.getKey();
						Double weight = entry.getValue();
						//if tag does not exist, make a new tag
						List<Tag> knownTags = tagRepository.findByTagName(tag);
						if (knownTags.isEmpty()) {
							Tag newTag = new Tag();
							newTag.setTagName(tag);
							// TODO: newTag.setCategory(??);
							Instant now = Instant.now();
							newTag.setCreatedAt(now);
							tagRepository.save(newTag);

							RecipientTag newRecipientTag = new RecipientTag();
							newRecipientTag.setRecipient(recipient);
							RecipientTag.RecipientTagId recipientTagId = new RecipientTag.RecipientTagId();
							recipientTagId.setRecipientId(recipient.getId());
							recipientTagId.setTagName(newTag.getTagName());
							newRecipientTag.setId(recipientTagId);
							newRecipientTag.setTag(newTag);
							newRecipientTag.setWeight(weight);
							newRecipientTag.setAddedAt(now);
							recipientTagsRepository.save(newRecipientTag);

							recipient.setTagsLastGenerated(Instant.now());
						}
						// If a known tag does exist, check to see if it's unassigned to the recipient, if so, assign it.
						else {
							for (Tag knownTag : knownTags) {
								List<RecipientTag> knownRecipientTags = recipientTagsRepository.getRecipientTagByRecipientIdAndTagName(recipient.getId(), tag);
								if (knownRecipientTags.isEmpty()) {
									RecipientTag newRecipientTag = new RecipientTag();
									RecipientTag.RecipientTagId recipientTagId = new RecipientTag.RecipientTagId();
									recipientTagId.setRecipientId(recipient.getId());
									recipientTagId.setTagName(knownTag.getTagName());
									newRecipientTag.setId(recipientTagId);
									newRecipientTag.setRecipient(recipient);
									newRecipientTag.setTag(knownTag);
									newRecipientTag.setWeight(weight);
									newRecipientTag.setAddedAt(Instant.now());
									recipientTagsRepository.save(newRecipientTag);

									recipient.setTagsLastGenerated(Instant.now());
								}
							}
						}
					}
				}

				recipientRepository.save(recipient);
			}
			else {
				throw new TimingException("Recipient generated tags too recently.");
			}
		} else {
			throw new ModelException("Recipient not found.");
		}

		return recipientTagsRepository.getRecipientTagByRecipientId(id);
	}

	@Override
	public Recipient getRecipientById(Integer id) {
		Optional<Recipient> recipient = recipientRepository.findById(id);
		return recipient.orElse(null);
	}

	@Override
	public List<Recipient> getMatchingRecipientsByTags(List<String> tags) {
		// TODO: implement this system using RecipientRepository method(s)
		if (tags == null || tags.isEmpty()) {
			throw new IllegalArgumentException("Tags list cannot be null or empty.");
		}

		// Use Pageable to limit the results to the top 5 recipients
    	Pageable pageable = PageRequest.of(0, 5);

		return recipientRepository.findByTags_Tag_TagName(tags, pageable);
	}

	@Override
	public Recipient updateSelectedTags(Integer recipientId, @Valid Set<String> selectedTags) {
		Optional<Recipient> recipientResult = recipientRepository.findById(recipientId);
		if (recipientResult.isPresent()) {
			var recipient = recipientResult.get();
			for (var recipientTag : recipient.getTags()) {
				recipientTag.setSelected(selectedTags.contains(recipientTag.getTagName()));
			}
			return recipientRepository.save(recipient);
		}
		else {
			throw new ModelException("Recipient not found.");
		}
	}

	/**
	 * Private method to check if recipient can regenerate tags. As of now the default is
	 * once every 24 hours.
	 * @param recipient
	 * @return
	 */
	private Boolean canGenerateTags(Recipient recipient) {
		// Default to false. Do NOT default to true and change the logic (albeit simpler).
		// This prevents issues in the
		// intermediary logic from defaulting to true and causing a cascade of requests to
		// Bedrock which can be expensive.
		boolean canGenerateTags = false;

		if (recipient.getTagsLastGenerated() == null) {
			canGenerateTags = true;
		}
		else {
			Instant generationCoolDownInstant = Instant.now().minus(Duration.ofDays(1));

			// If the date the tag was added was NOT before the generation cooldown
			if (recipient.getTagsLastGenerated().isBefore(generationCoolDownInstant)) {
				canGenerateTags = true;
			}
		}

		return canGenerateTags;
	}

}

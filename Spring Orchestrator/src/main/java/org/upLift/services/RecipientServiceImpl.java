package org.upLift.services;

import jakarta.transaction.Transactional;
import jakarta.validation.Valid;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.upLift.exceptions.ModelException;
import org.upLift.exceptions.TimingException;
import org.upLift.model.FormQuestion;
import org.upLift.model.Recipient;
import org.upLift.model.RecipientTag;
import org.upLift.model.Tag;
import org.upLift.repositories.RecipientRepository;
import org.upLift.repositories.TagRepository;

import java.time.Duration;
import java.time.Instant;
import java.util.*;
import java.util.concurrent.atomic.AtomicReference;

@Service
@Transactional
public class RecipientServiceImpl implements RecipientService {

	private final RecipientRepository recipientRepository;

	private final BedrockService bedrockService;

	private final TagRepository tagRepository;

	private final FairnessService fairnessService;

	public RecipientServiceImpl(RecipientRepository recipientRepository, BedrockService bedrockService,
			TagRepository tagRepository, FairnessService fairnessService) {
		this.recipientRepository = recipientRepository;
		this.bedrockService = bedrockService;
		this.tagRepository = tagRepository;
		this.fairnessService = fairnessService;
	}

	@Override
	public List<Tag> getRandomSelectedTags(int quantity) {
		List<Tag> allSelectedTags = tagRepository.getSelectedTags();
		Collections.shuffle(allSelectedTags);
		if (quantity > allSelectedTags.size()) {
			return allSelectedTags;
		}
		else {
			return allSelectedTags.subList(0, quantity);
		}
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
			if (canGenerateTags(recipient)) {
				AtomicReference<String> recipient_prompt = new AtomicReference<>("");

				if (formQuestions != null && !formQuestions.isEmpty()) {
					// Set the latest form questions if provided.
					recipient.setFormQuestions(formQuestions);
				}

				// Consolidate all form questions into a single string to invoke the tag generation service.
				recipient.getFormQuestions().forEach(formQuestion -> {
					recipient_prompt.set(STR."\{recipient_prompt} \{formQuestion.getAnswer()}");
				});

				Instant tagsUpdated = Instant.now();

				// Only generate tags if there is a valid prompt
				if(!recipient_prompt.get().isEmpty()) {
					Map<String, Double> newTags = bedrockService.getTagsFromPrompt(recipient_prompt.get());

					for (Map.Entry<String, Double> entry : newTags.entrySet()) {
						String tag = entry.getKey();
						Double weight = entry.getValue();
						//if tag does not exist, make a new tag
						// Note that since the tag name is itself the primary key, it just search
						Optional<Tag> knownTagResult = tagRepository.findById(tag);
						if (knownTagResult.isEmpty()) {
							Tag newTag = new Tag().tagName(tag);
							// TODO: newTag.setCategory(??);
							tagRepository.save(newTag);

							addTagToRecipient(recipient, newTag, weight, tagsUpdated);
						}
						// If a known tag does exist, check to see if it's linked to the recipient.
						else {
							var knownTag = knownTagResult.get();
							Optional<RecipientTag> assignedTag = findMatchingTag(recipient, knownTag.getTagName());
							// If not already linked, link it.
							if (assignedTag.isEmpty()) {
								addTagToRecipient(recipient, knownTag, weight, tagsUpdated);
							}
							// If it is already linked, update the weight in case it's changed,
							// as well as the "added at" to indicate that it's been relinked
							else {
								assignedTag.get().setWeight(weight);
								assignedTag.get().setAddedAt(tagsUpdated);
							}
						}
					}
					recipient.setTagsLastGenerated(tagsUpdated);
				}

				var savedRecipient = recipientRepository.save(recipient);
				return new ArrayList<>(savedRecipient.getTags());
			}
			else {
				throw new TimingException("Recipient generated tags too recently.");
			}
		} else {
			throw new ModelException("Recipient not found.");
		}
	}

	/**
	 * Finds the matching recipient link entry for the specified tag, if any.
	 * @param recipient Recipient loaded with linked tags
	 * @param tagName name of the tag to search for
	 * @return Optional containing the RecipientTag entry linking the specified tag with
	 * the specified recipient or an empty Optional if the recipient isn't currently
	 * linked to that tag
	 */
	Optional<RecipientTag> findMatchingTag(Recipient recipient, String tagName) {
		return recipient.getTags().stream().filter(tag -> tag.getTagName().equals(tagName)).findFirst();
	}

	/**
	 * Links the specified tag to the specified recipient with the specified relevance
	 * weight.
	 *
	 * @param recipient recipient to whom the tag should be linked
	 * @param tag       tag to link to the recipient
	 * @param weight    relevance weight of the tag to the recipient
	 * @param addedAt
	 */
	void addTagToRecipient(Recipient recipient, Tag tag, double weight, Instant addedAt) {
		RecipientTag newRecipientTag = new RecipientTag();
		newRecipientTag.setTag(tag);
		newRecipientTag.setWeight(weight);
		newRecipientTag.setAddedAt(addedAt);
		recipient.addTagsItem(newRecipientTag);
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

	/**
	 * This method takes in a donor's question and answers and passes those as a prompt to amazon bedrock to gather a list
	 * of known tags and then match those tags to donors that meet the donor's preferences in a fair and balanced strategy.
	 * @param donorQA
	 * @return
	 */
	@Override
	public List<Recipient> getMatchingRecipientsByDonorPrompt(List<FormQuestion> donorQA) {

		AtomicReference<String> donorPrompt = new AtomicReference<>("");

		// Consolidate all form questions into a single string to invoke the matching service.
		donorQA.forEach(formQuestion -> {
			donorPrompt.set(STR."\{donorPrompt} \{formQuestion.getAnswer()}");
		});

		// Submit prompt to generate appropriate tags.
		List<String> tags = bedrockService.matchTagsFromPrompt(donorPrompt.toString());

		// Gather the recipientTags with the highest weight to
		Set<RecipientTag> recipientTags = fairnessService.getWeightedRecipientTags(tags);

		// Extract the best matching recipients from the recipient tags
		Set<Recipient> recipients = fairnessService.getRecipientsFromRecipientTags(recipientTags);

		return recipients.stream().toList();
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

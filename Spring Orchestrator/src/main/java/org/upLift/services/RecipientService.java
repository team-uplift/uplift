package org.upLift.services;

import jakarta.validation.Valid;
import org.upLift.model.FormQuestion;
import org.upLift.model.Recipient;
import org.upLift.model.RecipientTag;
import org.upLift.model.Tag;

import java.util.List;
import java.util.Set;

public interface RecipientService {

	/**
	 * Retrieves a randomly-selected, randomly-ordered List of tags chosen by at least one
	 * recipient. If there are at least quantity number of tags, returns the specified
	 * quantity. If there are fewer tags than the specified quantity, returns all
	 * recipient-selected tags.
	 * @param quantity maximum number of tags to return
	 * @return randomly-selected, randomly-ordered List of at most quantity number of tags
	 * chosen by at least one recipient
	 */
	List<Tag> getRandomSelectedTags(int quantity);

	Recipient saveRecipient(@Valid Recipient recipient);

	List<RecipientTag> generateRecipientTags(Integer id, @Valid List<FormQuestion> formQuestions);

	Recipient getRecipientById(Integer id);

	List<Recipient> getMatchingRecipientsByTags(List<String> tags);

	List<Recipient> getMatchingRecipientsByDonorPrompt(List<FormQuestion> donorQA);

	/**
	 * Marks the specified tags as selected for the specified recipient, removing the
	 * selected flag from any linked tags that aren't specified. Ignores any tags that
	 * aren't already linked to the recipient.
	 * @param recipientId persistence index of the recipient
	 * @param selectedTags Set of tags selected by the recipient
	 * @return updated Recipient entry
	 */
	Recipient updateSelectedTags(Integer recipientId, @Valid Set<String> selectedTags);

}

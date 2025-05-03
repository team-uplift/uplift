package org.upLift.services;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import org.springframework.validation.annotation.Validated;
import org.upLift.model.FormQuestion;
import org.upLift.model.Recipient;
import org.upLift.model.RecipientTag;
import org.upLift.model.Tag;

import java.util.List;
import java.util.Set;

@Validated
public interface RecipientService {

	/**
	 * Checks if a recipient entry exists with the specified persistence id, deleted or
	 * not.
	 * @param id persistence id of a recipient to look for
	 * @return true if there's a recipient entry with the specified persistence id,
	 * deleted or not, or false if no such entry exists
	 */
	boolean existsById(int id);

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

	/**
	 * This method takes in a recipient ID and the specified form questions and answers,
	 * using that plus recipient data to generate a set of matching tags.
	 * @param id recipient persistence index
	 * @param formQuestions questions and answers from the recipient's profile
	 * @return tags that match the specified recipient's profile and form questions
	 */
	List<RecipientTag> generateRecipientTags(@NotNull Integer id, @Valid List<FormQuestion> formQuestions);

	Recipient getRecipientById(Integer id);

	List<Recipient> getMatchingRecipientsByTags(List<String> tags);

	/**
	 * This method takes in a donor's question and answers and passes those as a prompt to
	 * amazon bedrock to gather a list of known tags, then matches those tags to
	 * recipients that meet the donor's preferences in a fair and balanced strategy.
	 * @param donorQA
	 * @return
	 */
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

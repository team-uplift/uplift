package org.upLift.services;

import jakarta.validation.Valid;
import org.upLift.model.FormQuestion;
import org.upLift.model.Recipient;
import org.upLift.model.RecipientTag;

import java.util.List;

public interface RecipientService {

	Recipient saveRecipient(@Valid Recipient recipient);

	List<RecipientTag> generateRecipientTags(Integer id, @Valid List<FormQuestion> formQuestions);

	Recipient getRecipientById(Integer id);

	List<Recipient> getMatchingRecipientsByTags(List<String> tags);

}

package org.upLift.services;

import org.upLift.model.Recipient;
import org.upLift.model.RecipientTag;

import java.util.List;
import java.util.Set;

public interface FairnessService {

	Set<RecipientTag> getWeightedRecipientTags(List<String> tags);

	Set<Recipient> getRecipientsFromRecipientTags(Set<RecipientTag> recipientTags);

}

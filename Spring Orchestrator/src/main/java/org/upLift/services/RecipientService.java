package org.upLift.services;

import org.upLift.model.Recipient;

public interface RecipientService {

	Recipient saveRecipient(Recipient recipient);

	Recipient getRecipientById(Integer id);

}

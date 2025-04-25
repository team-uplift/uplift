package org.upLift.services;

import org.springframework.validation.annotation.Validated;
import org.upLift.model.Message;

import java.util.List;
import java.util.Optional;

@Validated
public interface MessageService {

	Optional<Message> getMessageById(int id);

	List<Message> getMessagesByDonorId(int donorId);

	/**
	 * Saves the specified new message, returning the donation to which it's attached.
	 * Method returns the parent Donation to facilitate use by the front end, since
	 * recipient-sent messages are only displayed in the context of a donation.
	 * @param message new thank-you message to be saved, must include the parent donation id
	 * @return new saved Message entry
	 */
	Message sendNewMessage(Message message);

	/**
	 * Marks the message with the specified persistence id as read by the donor, returning
	 * the updated message.
	 * @param id persistence index of the message to mark as having been read by the donor
	 * @return updated Message entry
	 */
	Message markMessageRead(int id);

}

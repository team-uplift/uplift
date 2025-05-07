/**
 * The MessageServiceImpl centralizes all business logic around donor–recipient messaging. It allows fetching individual
 * messages by ID or listing all thank-you messages sent by a particular donor. When sending a new message, it enforces
 * that the message is tied to an existing donation (throwing an EntityNotFoundException if the donation doesn’t exist)
 * and prevents duplicate thank-you notes for the same donation (throwing a ModelException if one has already been sent).
 * Finally, it supports marking a message as read by the donor—retrieving the message, flipping its donorRead flag,
 * saving the update, or raising an EntityNotFoundException if no such message exists. Throughout, it logs key steps
 * and delegates all persistence to the injected repositories.
 */
package org.upLift.services;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.upLift.exceptions.EntityNotFoundException;
import org.upLift.exceptions.ModelException;
import org.upLift.model.Message;
import org.upLift.repositories.DonationRepository;
import org.upLift.repositories.MessageRepository;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class MessageServiceImpl implements MessageService {

	private static final Logger LOG = LoggerFactory.getLogger(MessageServiceImpl.class);

	private final DonationRepository donationRepository;

	private final MessageRepository messageRepository;

	public MessageServiceImpl(DonationRepository donationRepository, MessageRepository messageRepository) {
		this.donationRepository = donationRepository;
		this.messageRepository = messageRepository;
	}

	@Override
	public Optional<Message> getMessageById(int id) {
		return messageRepository.findById(id);
	}

	@Override
	public List<Message> getMessagesByDonorId(int donorId) {
		return messageRepository.findAllByDonation_Donor_Id(donorId);
	}

	@Override
	public Message sendNewMessage(Message message) {
		if (message.getDonationId() != null) {
			var donationId = message.getDonationId();
			if (donationRepository.existsById(donationId)) {
				LOG.debug("Found donation with id {}", donationId);
				if (messageRepository.existsByDonation_Id(donationId)) {
					throw new ModelException(
							"Invalid request: thank you message already exists for donation " + donationId);
				}
				LOG.debug("Saving message: {}", message.getMessage());
				// TODO: Add notification to donor about new message?

				return messageRepository.save(message);
			}
			else {
				throw new EntityNotFoundException(donationId, "Donation", "No donation found, can't send new message");
			}
		}
		else {
			throw new ModelException(
					"Invalid request: no donation id found.  " + "Thank-you message must be linked to a donation");
		}
	}

	@Override
	public Message markMessageRead(int messageId) {
		var messageResult = messageRepository.findById(messageId);
		if (messageResult.isPresent()) {
			LOG.debug("Found message with id {}", messageId);
			var message = messageResult.get();
			message.setDonorRead(true);
			var savedMessage = messageRepository.save(message);
			LOG.debug("Saved message: {}", savedMessage);
			return savedMessage;
		}
		else {
			throw new EntityNotFoundException(messageId, "Message", "No message found, can't mark it sent");
		}
	}

}

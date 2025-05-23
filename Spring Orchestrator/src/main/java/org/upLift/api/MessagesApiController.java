package org.upLift.api;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;
import org.upLift.exceptions.EntityNotFoundException;
import org.upLift.model.Donation;
import org.upLift.model.Message;
import org.upLift.services.DonationService;
import org.upLift.services.MessageService;
import org.upLift.services.UserService;

import java.util.List;

@jakarta.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen",
		date = "2025-03-16T14:18:35.909799305Z[GMT]")
@RestController
public class MessagesApiController implements MessagesApi {

	private static final Logger LOG = LoggerFactory.getLogger(MessagesApiController.class);

	private final MessageService messageService;

	private final DonationService donationService;

	private final UserService userService;

	@Autowired
	public MessagesApiController(MessageService messageService, DonationService donationService,
			UserService userService) {
		this.messageService = messageService;
		this.donationService = donationService;
		this.userService = userService;
	}

	@Override
	public Message messagesIdGet(Integer id) {
		LOG.info("Getting message {}", id);
		var message = messageService.getMessageById(id);
		if (message.isPresent()) {
			LOG.debug("Found message with id {}", id);
			return message.get();
		}
		else {
			throw new EntityNotFoundException(id, "Message", "Message not found");
		}
	}

	@Override
	public ResponseEntity<List<Message>> messagesGetByDonor(Integer donorId) {
		LOG.info("Getting messages linked to donor {}", donorId);
		if (userService.donorExists(donorId)) {
			LOG.debug("Found donor {}", donorId);
			var messages = messageService.getMessagesByDonorId(donorId);
			LOG.debug("Found {} messages", messages.size());
			return new ResponseEntity<>(messages, HttpStatus.OK);
		}
		else {
			LOG.info("Donor {} does not exist", donorId);
			throw new EntityNotFoundException(donorId, "Donor", "Donor not found");
		}
	}

	@Override
	public Donation messagesPost(Message body) {
		LOG.info("Saving message linked to donation {}", body.getDonationId());
		var savedMessage = messageService.sendNewMessage(body);
		LOG.debug("Saved new message {}", savedMessage.getMessage());
		return donationService.getDonationById(savedMessage.getDonationId())
			// This should never happen because the new message has already been saved,
			// linked to the donation - if it didn't exist, the error would already have
			// been thrown
			.orElseThrow(
					() -> new EntityNotFoundException(savedMessage.getDonationId(), "Donation", "Donation not found"));
	}

	@Override
	public Message messagesMarkRead(Integer messageId) {
		LOG.info("Marking message {} as read", messageId);
		return messageService.markMessageRead(messageId);
	}

}

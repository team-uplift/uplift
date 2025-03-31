package org.upLift.api;

import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.upLift.model.Message;
import org.upLift.services.MessageService;
import org.upLift.services.UserService;

import java.util.List;

@jakarta.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen",
		date = "2025-03-16T14:18:35.909799305Z[GMT]")
@RestController
public class MessagesApiController implements MessagesApi {

	private static final Logger LOG = LoggerFactory.getLogger(MessagesApiController.class);

	private final MessageService messageService;

	private final UserService userService;

	@Autowired
	public MessagesApiController(MessageService messageService, UserService userService) {
		this.messageService = messageService;
		this.userService = userService;
	}

	@Override
	public ResponseEntity<Message> messagesIdGet(@PathVariable("id") Integer id) {
		LOG.info("Getting message {}", id);
		var message = messageService.getMessageById(id);
		if (message.isPresent()) {
			LOG.debug("Found message with id {}", id);
			return new ResponseEntity<>(message.get(), HttpStatus.OK);
		}
		else {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}

	@Override
	public ResponseEntity<List<Message>> messagesGetByDonor(@PathVariable("donorId") Integer donorId) {
		LOG.info("Getting messages linked to donor {}", donorId);
		if (userService.donorExists(donorId)) {
			LOG.debug("Found donor {}", donorId);
			var messages = messageService.getMessagesByDonorId(donorId);
			LOG.debug("Found {} messages", messages.size());
			return new ResponseEntity<>(messages, HttpStatus.OK);
		}
		else {
			LOG.info("Donor {} does not exist", donorId);
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}

	@Override
	public ResponseEntity<Message> messagesPost(@Valid @RequestBody Message body) {
		LOG.info("Saving message linked to donation {}", body.getDonationId());
		LOG.debug("Saving message: {}", body.getMessage());
		var savedMessage = messageService.sendMessage(body);
		LOG.debug("Saved message: {}", savedMessage);
		return new ResponseEntity<>(savedMessage, HttpStatus.CREATED);
	}

	@Override
	public ResponseEntity<Message> messagesMarkRead(@PathVariable("messageId") Integer messageId) {
		LOG.info("Marking message {} as read", messageId);
		var messageResult = messageService.getMessageById(messageId);
		if (messageResult.isPresent()) {
			LOG.debug("Found message with id {}", messageId);
			var message = messageResult.get();
			message.setDonorRead(true);
			var savedMessage = messageService.sendMessage(message);
			LOG.debug("Saved message: {}", savedMessage);
			return new ResponseEntity<>(savedMessage, HttpStatus.OK);
		}
		else {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}

}

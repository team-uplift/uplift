package org.upLift.services;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.upLift.model.Message;
import org.upLift.repositories.MessageRepository;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class MessageServiceImpl implements MessageService {

	private final MessageRepository messageRepository;

	public MessageServiceImpl(MessageRepository messageRepository) {
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
	public Message sendMessage(Message message) {
		var savedMessage = messageRepository.save(message);
		// TODO: Add notification to donor about new message?
		return savedMessage;
	}

}

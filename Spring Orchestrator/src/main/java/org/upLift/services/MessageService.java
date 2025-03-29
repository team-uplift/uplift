package org.upLift.services;

import org.springframework.validation.annotation.Validated;
import org.upLift.model.Message;

import java.util.List;
import java.util.Optional;

@Validated
public interface MessageService {

	Optional<Message> getMessageById(int id);

	List<Message> getMessagesByDonorId(int donorId);

	Message sendMessage(Message message);

}

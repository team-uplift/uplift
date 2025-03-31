package org.upLift.services;

import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.upLift.model.Recipient;
import org.upLift.repositories.RecipientRepository;

import java.util.Optional;

@Service
@Transactional
public class RecipientServiceImpl implements RecipientService {

	private final RecipientRepository recipientRepository;

	public RecipientServiceImpl(RecipientRepository recipientRepository) {
		this.recipientRepository = recipientRepository;
	}

	@Override
	public Recipient saveRecipient(Recipient recipient) {
		return recipientRepository.save(recipient);
	}

	@Override
	public Recipient getRecipientById(Integer id) {
		Optional<Recipient> recipient = recipientRepository.findById(id);
		return recipient.orElse(null);
	}

}

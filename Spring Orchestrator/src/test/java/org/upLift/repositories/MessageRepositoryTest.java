package org.upLift.repositories;

import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.upLift.model.Message;

import java.time.Instant;
import java.util.Comparator;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

class MessageRepositoryTest extends BaseRepositoryTest {

	@Autowired
	private MessageRepository messageRepository;

	@Autowired
	private EntityManager entityManager;

	@Test
	void testFindById() {
		var result = messageRepository.findById(1);
		assertThat(result.isPresent(), is(true));
		checkMessage(result.get());
	}

	@Test
	void testExistsByDonation_Id() {
		boolean exists = messageRepository.existsByDonation_Id(1);
		assertThat("Message exists", exists, is(true));

		boolean notExistsA = messageRepository.existsByDonation_Id(4);
		assertThat("Donation exists, no message", notExistsA, is(false));

		boolean notExistsB = messageRepository.existsByDonation_Id(999);
		assertThat("No such donation", notExistsB, is(false));
	}

	@Test
	void testFindAllByDonation_Donor_Id() {
		var result = messageRepository.findAllByDonation_Donor_Id(3);
		assertThat(result, hasSize(2));
		result.sort(Comparator.comparingInt(Message::getId));
		checkMessage(result.getFirst());
		assertThat(result.getLast().getId(), is(2));
		assertThat(result.getLast().getDonationId(), is(1));
	}

	@Test
	void testSave() {
		var newMessage = new Message().donationId(4);
		newMessage.setMessage("Thank you!");

		var savedMessage = messageRepository.save(newMessage);

		// Ensure changes are flushed to the database
		entityManager.flush();
		entityManager.clear();

		// Reload the donor from the database
		var loadedMessage = messageRepository.findById(savedMessage.getId())
			.orElseThrow(() -> new RuntimeException("Message not found"));
		assertThat(loadedMessage.getDonation(), is(notNullValue()));
		assertThat(loadedMessage.getDonationId(), is(4));
		assertThat(loadedMessage.getMessage(), is("Thank you!"));
		assertThat(loadedMessage.isDonorRead(), is(false));

		// Check that flag update is saved correctly
		loadedMessage.setDonorRead(true);
		messageRepository.save(loadedMessage);

		// Ensure changes are flushed to the database
		entityManager.flush();
		entityManager.clear();

		var readMessage = messageRepository.findById(savedMessage.getId())
			.orElseThrow(() -> new RuntimeException("Message not found"));
		assertThat(readMessage.isDonorRead(), is(true));
	}

	void checkMessage(Message message) {
		assertThat(message, is(notNullValue()));
		assertThat(message.getId(), is(1));
		assertThat(message.getDonation(), is(notNullValue()));
		assertThat(message.getDonation().getId(), is(2));
		assertThat(message.getMessage(), is("Hope this helps!"));
		assertThat(message.isDonorRead(), is(true));
		assertThat(message.getCreatedAt(), is(Instant.parse("2023-10-22T19:15:30.123Z")));
	}

}

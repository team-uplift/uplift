package org.upLift.repositories;

import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.upLift.model.Recipient;
import org.upLift.model.User;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

class RecipientRepositoryTest extends BaseRepositoryTest {

	@Autowired
	private RecipientRepository recipientRepository;

	@Autowired
	private EntityManager entityManager;

	@Test
	@DisplayName("Test finding a recipient by ID and validate all properties")
	void testFindById() {
		// Retrieve recipient with ID = 2
		Optional<Recipient> recipient = recipientRepository.findById(2);
		assertThat(recipient.isPresent(), is(true));
		checkRecipient2(recipient.get());
	}

	void checkRecipient2(Recipient recipient) {
		// Validate Recipient fields
		assertThat(recipient.getId(), is(2));
		assertThat(recipient.getFirstName(), is("Jane"));
		assertThat(recipient.getLastName(), is("Smith"));
		assertThat(recipient.getStreetAddress1(), is("456 Oak St"));
		assertThat(recipient.getStreetAddress2(), is(emptyOrNullString()));
		assertThat(recipient.getCity(), is("Madison"));
		assertThat(recipient.getState(), is("WI"));
		assertThat(recipient.getZipCode(), is("53703"));
		assertThat(recipient.getImageUrl(), is("http://example.com/image2.jpg"));
		assertThat(recipient.getLastAboutMe(), is("About Jane"));
		assertThat(recipient.getLastReasonForHelp(), is("Reason 2"));

		// Validate Timestamp fields
		assertThat(recipient.getIdentityLastVerified(), is(Instant.parse("2023-10-02T14:10:00.789Z")));
		assertThat(recipient.getIncomeLastVerified(), is(Instant.parse("2023-10-03T15:20:40.321Z")));
		assertThat(recipient.getTagsLastGenerated(), is(Instant.parse("2023-10-10T11:05:20.123Z")));

	}

	@Test
	@DisplayName("Test checking whether a recipient exists by ID")
	void testExistsById() {
		// Verify IDs exist or not
		assertThat(recipientRepository.existsById(1), is(true));
		assertThat(recipientRepository.existsById(5), is(true));
		assertThat(recipientRepository.existsById(99), is(false));
	}

	@Test
	@DisplayName("Test saving a new recipient")
	void testSaveRecipient() {
		// Create and save a new user
		User user = new User();
		user.setCognitoId("550e8400-e29b-41d4-a716-446655440008");
		user.setEmail("sarah.johnson@example.com");
		user.setRecipient(true);

		var newRecipient = new Recipient();
		newRecipient.setFirstName("Sarah");
		newRecipient.setLastName("Johnson");
		newRecipient.setStreetAddress1("789 Pine St");
		newRecipient.setCity("Columbus");
		newRecipient.setState("OH");
		newRecipient.setZipCode("43215");
		newRecipient.setLastAboutMe("About Sarah");
		newRecipient.setLastReasonForHelp("Reason 3");
		newRecipient.setImageUrl("http://example.com/image3.jpg");
		newRecipient.setIdentityLastVerified(Instant.parse("2024-10-27T11:31:43Z"));
		newRecipient.setIncomeLastVerified(Instant.parse("2024-12-27T11:31:43Z"));

		user.setRecipientData(newRecipient);
		// Save the new user
		Recipient savedRecipient = recipientRepository.save(newRecipient);

		// Ensure changes are flushed to the database
		entityManager.flush();
		entityManager.clear();

		// Reload the recipient from the database
		var loadedRecipient = recipientRepository.findById(savedRecipient.getId())
			.orElseThrow(() -> new RuntimeException("Recipient not found"));

		// Validate the saved recipient
		assertThat(loadedRecipient.getId(), notNullValue());
		assertThat(loadedRecipient.getFirstName(), is("Sarah"));
		assertThat(loadedRecipient.getLastName(), is("Johnson"));
		assertThat(loadedRecipient.getStreetAddress1(), is("789 Pine St"));
		assertThat(loadedRecipient.getCity(), is("Columbus"));
		assertThat(loadedRecipient.getState(), is("OH"));
		assertThat(loadedRecipient.getZipCode(), is("43215"));
		assertThat(loadedRecipient.getLastAboutMe(), is("About Sarah"));
		assertThat(loadedRecipient.getLastReasonForHelp(), is("Reason 3"));
		assertThat(loadedRecipient.getImageUrl(), is("http://example.com/image3.jpg"));
		assertThat(loadedRecipient.getIdentityLastVerified(), is(Instant.parse("2024-10-27T11:31:43Z")));
		assertThat(loadedRecipient.getIncomeLastVerified(), is(Instant.parse("2024-12-27T11:31:43Z")));
		assertThat(loadedRecipient.getCreatedAt(), is(notNullValue()));

		var loadedUser = loadedRecipient.getUser();
		// Validate the parent User properties
		assertThat(loadedUser.getId(), notNullValue());
		assertThat(loadedUser.getCognitoId(), is("550e8400-e29b-41d4-a716-446655440008"));
		assertThat(loadedUser.getEmail(), is("sarah.johnson@example.com"));
		assertThat(loadedUser.isRecipient(), is(true));
	}

	@Test
	@DisplayName("Test retrieving recipients by last donation timestamp")
	void testGetRecipientsByLastDonationTimestamp() {
		// Arrange
		Instant cutoff = Instant.parse("2023-10-23T00:00:00Z"); // before 2023-10-23

		// Act
		List<Recipient> recipients = recipientRepository.getRecipientsByLastDonationTimestamp(cutoff);

		// Assert
		assertThat(recipients, is(not(empty()))); // Ensure the list is not empty
		assertThat(recipients, hasSize(4));
		// Validate that all recipients meet the criteria
		for (Recipient recipient : recipients) {
			assertThat("Recipient's last donation timestamp should be null or before the cutoff",
					recipient.getLastDonationTimestamp(), anyOf(nullValue(), lessThan(cutoff)));
		}

		// Validate sorting: null timestamps should come first, followed by earlier
		// timestamps
		for (int i = 1; i < recipients.size(); i++) {
			Recipient previous = recipients.get(i - 1);
			Recipient current = recipients.get(i);

			if (previous.getLastDonationTimestamp() != null) {
				// If the previous recipient has a valid timestamp, the current one must
				// have a later or equal timestamp
				assertThat(current.getLastDonationTimestamp(),
						greaterThanOrEqualTo(previous.getLastDonationTimestamp()));
			}
		}
	}

	@Test
	@DisplayName("Test finding recipients by tags 'food' and 'health' and validate results")
	void testFindByTags_Tag_TagName() {
		// Arrange
		List<String> tags = List.of("food", "health");
		Pageable pageable = PageRequest.of(0, 10); // Limit to 10 results

		// Act
		List<Recipient> recipients = recipientRepository.findByTags_Tag_TagName(tags, pageable);

		// Assert
		assertThat(recipients, is(not(empty()))); // Ensure the list is not empty
		assertThat(recipients, hasSize(4)); // Ensure exactly 4 recipients are returned

		// Validate that the returned recipients have the expected IDs
		List<Integer> recipientIds = recipients.stream().map(Recipient::getId).toList();
		assertThat(recipientIds, containsInAnyOrder(1, 2, 5, 6)); // Ensure IDs match
																	// exactly

	}

}

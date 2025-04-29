package org.upLift.repositories;

import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.upLift.model.Recipient;
import org.upLift.model.RecipientTag;
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
		user.setCognitoId("550e8400-e29b-41d4-a716-446655440099");
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
		newRecipient.setNickname("Fuschia alligator");
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
		assertThat(loadedRecipient.getNickname(), is("Fuschia alligator"));
		assertThat(loadedRecipient.getImageUrl(), is("http://example.com/image3.jpg"));
		assertThat(loadedRecipient.getIdentityLastVerified(), is(Instant.parse("2024-10-27T11:31:43Z")));
		assertThat(loadedRecipient.getIncomeLastVerified(), is(Instant.parse("2024-12-27T11:31:43Z")));
		assertThat(loadedRecipient.getCreatedAt(), is(notNullValue()));

		var loadedUser = loadedRecipient.getUser();
		// Validate the parent User properties
		assertThat(loadedUser.getId(), notNullValue());
		assertThat(loadedUser.getCognitoId(), is("550e8400-e29b-41d4-a716-446655440099"));
		assertThat(loadedUser.getEmail(), is("sarah.johnson@example.com"));
		assertThat(loadedUser.isRecipient(), is(true));
	}

	@Test
	@DisplayName("Test retrieving recipients by last donation timestamp")
	void testGetRecipientsByLastDonationTimestamp() {
		// Check that deleted recipient has no last donation timestamp
		var deletedRecipient = recipientRepository.findById(9)
			.orElseThrow(() -> new RuntimeException("Deleted recipient 9 not found"));
		assertThat(deletedRecipient.getUser().isDeleted(), is(true));
		assertThat(deletedRecipient.getLastDonationTimestamp(), is(nullValue()));

		// Arrange
		// before 2023-10-23, this should exclude recipient 1
		Instant cutoff = Instant.parse("2023-10-23T00:00:00Z");

		// Act
		List<Recipient> recipients = recipientRepository.getRecipientsByLastDonationTimestamp(cutoff);

		// Assert
		assertThat(recipients, is(not(empty()))); // Ensure the list is not empty
		// Recipient 9 excluded because it's deleted, even though the last donated
		// timestamp is null
		assertThat(recipients, hasSize(4));
		// Validate that all recipients meet the criteria
		for (Recipient recipient : recipients) {
			assertThat("Recipient's last donation timestamp should be null or before the cutoff",
					recipient.getLastDonationTimestamp(), anyOf(nullValue(), lessThan(cutoff)));
			// Check that the expected recipients were returned
			assertThat(recipient.getId(), is(oneOf(2, 5, 6, 7)));
		}

		// Validate sorting: null timestamps should come first, followed by earlier
		// timestamps
		for (int i = 1; i < recipients.size(); i++) {
			Recipient previous = recipients.get(i - 1);
			Recipient current = recipients.get(i);

			if (current.getLastDonationTimestamp() == null) {
				// Nulls should be ordered before set timestamps
				assertThat(previous.getLastDonationTimestamp(), is(nullValue()));
			}
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
		var deletedRecipient = recipientRepository.findById(9)
			.orElseThrow(() -> new RuntimeException("Recipient 9 not found"));
		assertThat(deletedRecipient.getUser().isDeleted(), is(true));
		var selectedTags = deletedRecipient.getSelectedTags();
		// Check that deleted recipient is linked to "elderly parent" (the only recipient
		// that is)
		// and "food-banks", among other tags
		assertThat(selectedTags, hasSize(5));
		for (RecipientTag selectedTag : selectedTags) {
			assertThat(selectedTag.getTagName(),
					is(oneOf("elderly parent", "financial-planning", "food-banks", "health", "job-training")));
		}

		// Arrange - note that deleted recipient 9 has "food-banks" tag selected
		// Note that recipients 6 and 7 are linked to "food-banks", but didn't select it
		List<String> tags = List.of("food", "food-banks");
		Pageable pageable = PageRequest.of(0, 10); // Limit to 10 results

		// Act
		var result1 = recipientRepository.findByTags_Tag_TagName(tags, pageable);

		// Assert
		assertThat(result1, is(not(empty()))); // Ensure the list is not empty
		assertThat(result1, hasSize(4)); // Ensure exactly 4 recipients are returned

		// Validate that the returned recipients have the expected IDs
		List<Integer> recipientIds = result1.stream().map(Recipient::getId).toList();
		// Ensure IDs match exactly, excluding the deleted recipient
		assertThat(recipientIds, containsInAnyOrder(1, 5, 6, 7));

		// Now check against the "elderly parent" tag, only linked to recipient 9
		var result2 = recipientRepository.findByTags_Tag_TagName(List.of("elderly parent"), pageable);
		assertThat("Only deleted recipient linked to tag", result2, is(empty()));
	}

}

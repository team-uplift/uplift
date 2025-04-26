package org.upLift.repositories;

import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.upLift.model.Donor;
import org.upLift.model.User;

import java.time.Instant;
import java.util.Optional;
import java.util.List;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

class DonorRepositoryTest extends BaseRepositoryTest {

	@Autowired
	private DonorRepository donorRepository;

	@Autowired
	private UserRepository userRepository; // Inject UserRepository

	@Autowired
	private EntityManager entityManager;

	@Test
	@DisplayName("Test finding a donor by ID and validate all properties")
	void testFindById() {
		// Retrieve donor with ID = 3
		Optional<Donor> donor = donorRepository.findById(3);
		assertThat(donor.isPresent(), is(true));
		checkDonor3(donor.get());
	}

	void checkDonor3(Donor donor) {
		// Validate Donor fields
		assertThat(donor.getId(), is(3));
		assertThat(donor.getNickname(), is("KindDonor1"));
		assertThat(donor.getCreatedAt(), is(Instant.parse("2023-10-10T12:30:50.789Z")));
	}

	@Test
	@DisplayName("Test checking whether a donor exists by ID")
	void testExistsById() {
		// Verify IDs exist or not
		assertThat(donorRepository.existsById(3), is(true));
		assertThat(donorRepository.existsById(5), is(false));
	}

	@Test
	@DisplayName("Test saving a new donor")
	void testSaveDonor() {
		Instant now = Instant.now();

		// Create and save a new user
		User user = new User();
		user.setCognitoId("550e8400-e29b-41d4-a716-446655440009");
		user.setEmail("donor2@example.com");
		user.setRecipient(false);

		// Create a new donor
		Donor newDonor = new Donor();
		newDonor.setNickname("GenerousDonor");
		newDonor.setCreatedAt(now);

		user.setDonorData(newDonor);
		// Save the new user
		User savedUser = userRepository.save(user);

		// Ensure changes are flushed to the database
		entityManager.flush();
		entityManager.clear();

		// Reload the donor from the database
		var loadedDonor = donorRepository.findById(savedUser.getId())
			.orElseThrow(() -> new RuntimeException("Donor not found"));

		// Validate the saved donor
		assertThat(loadedDonor.getId(), notNullValue());
		assertThat(loadedDonor.getNickname(), is("GenerousDonor"));
		assertThat(loadedDonor.getCreatedAt(), is(notNullValue()));
		assertThat(loadedDonor.getCreatedAt(), is(greaterThanOrEqualTo(now)));
	}

}

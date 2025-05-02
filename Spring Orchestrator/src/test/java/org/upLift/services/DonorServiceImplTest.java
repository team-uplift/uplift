package org.upLift.services;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.upLift.model.Donor;
import org.upLift.model.User;
import org.upLift.repositories.DonorRepository;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class DonorServiceImplTest {

	@Mock
	private DonorRepository donorRepository;

	@InjectMocks
	private DonorServiceImpl donorService;

	@Test
	void saveDonor_invokesRepositoryAndReturnsSaved() {
		Donor donor = new Donor();
		donor.setId(1);
		donor.setNickname("Alice");

		when(donorRepository.save(donor)).thenReturn(donor);

		Donor result = donorService.saveDonor(donor);

		assertNotNull(result);
		assertSame(donor, result);
		verify(donorRepository).save(donor);
	}

	@Test
	void getDonorById_whenFound_returnsDonor() {
		Donor donor = new Donor();
		donor.setId(2);
		User user = new User();
		user.setEmail("bob@example.com");
		donor.setUser(user);

		when(donorRepository.findById(2)).thenReturn(Optional.of(donor));

		Donor result = donorService.getDonorById(2);

		assertNotNull(result);
		assertEquals(2, result.getId());
		assertEquals("bob@example.com", result.getUser().getEmail());
		verify(donorRepository).findById(2);
	}

	@Test
    void getDonorById_whenNotFound_returnsNull() {
        when(donorRepository.findById(3)).thenReturn(Optional.empty());

        Donor result = donorService.getDonorById(3);

        assertNull(result);
        verify(donorRepository).findById(3);
    }

}

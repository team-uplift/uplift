package org.upLift.services;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.upLift.exceptions.*;
import org.upLift.model.Donor;
import org.upLift.model.Recipient;
import org.upLift.model.User;
import org.upLift.repositories.UserRepository;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserServiceImplTest {

	@Mock
	private UserRepository userRepository;

	@InjectMocks
	private UserServiceImpl service;

	@BeforeEach
	void setUp() {
		// nothing special
	}

	@Test
    void userExists_delegatesToRepository() {
        when(userRepository.existsById(1)).thenReturn(true, false);
        assertTrue(service.userExists(1));
        assertFalse(service.userExists(1));
        verify(userRepository, times(2)).existsById(1);
    }

	@Test
    void donorExists_and_recipientExists_delegateToRepository() {
        when(userRepository.existsByIdAndRecipient(2, false)).thenReturn(true);
        when(userRepository.existsByIdAndRecipient(3, true)).thenReturn(false);

        assertTrue(service.donorExists(2));
        assertFalse(service.recipientExists(3));

        verify(userRepository).existsByIdAndRecipient(2, false);
        verify(userRepository).existsByIdAndRecipient(3, true);
    }

	@Test
	void getUserById_present_returnsWrappedUser() {
		User user = new User();
		when(userRepository.findById(10)).thenReturn(Optional.of(user));

		Optional<User> result = service.getUserById(10);
		assertTrue(result.isPresent());
		assertSame(user, result.get());
		verify(userRepository).findById(10);
	}

	@Test
    void getUserById_notPresent_returnsEmpty() {
        when(userRepository.findById(11)).thenReturn(Optional.empty());

        Optional<User> result = service.getUserById(11);
        assertFalse(result.isPresent());
        verify(userRepository).findById(11);
    }

	@Test
	void getUserByCognitoId_present_andNotPresent() {
		User user = new User();
		when(userRepository.findByCognitoId("abc")).thenReturn(Optional.of(user));
		when(userRepository.findByCognitoId("def")).thenReturn(Optional.empty());

		assertTrue(service.getUserByCognitoId("abc").isPresent());
		assertFalse(service.getUserByCognitoId("def").isPresent());
		verify(userRepository).findByCognitoId("abc");
		verify(userRepository).findByCognitoId("def");
	}

	@Test
	void addUser_forDonor_withoutDonorData_createsDonorDataAndNickname() {
		User user = new User();
		user.setRecipient(false);
		user.setDonorData(null);

		when(userRepository.save(user)).thenReturn(user);

		User saved = service.addUser(user);

		assertNotNull(saved.getDonorData());
		assertNotNull(saved.getDonorData().getNickname());
		assertFalse(saved.getDonorData().getNickname().isEmpty());
		verify(userRepository).save(user);
	}

	@Test
	void addUser_forRecipient_withoutRecipientData_throwsModelException() {
		User user = new User();
		user.setRecipient(true);
		user.setRecipientData(null);

		assertThrows(ModelException.class, () -> service.addUser(user));
		verifyNoInteractions(userRepository);
	}

	@Test
	void addUser_forRecipient_withEmptyNickname_generatesNicknameAndImageUrl() {
		User user = new User();
		user.setRecipient(true);
		Recipient r = new Recipient();
		r.setNickname(null);
		r.setImageUrl("");
		user.setRecipientData(r);

		when(userRepository.save(user)).thenReturn(user);

		User saved = service.addUser(user);

		String nick = saved.getRecipientData().getNickname();
		String url = saved.getRecipientData().getImageUrl();
		assertNotNull(nick);
		assertFalse(nick.isEmpty());
		assertNotNull(url);
		assertTrue(url.startsWith("https://api.dicebear.com/7.x/pixel-art/svg?seed="));
		assertTrue(url.endsWith(nick));
		verify(userRepository).save(user);
	}

	@Test
	void updateUserProfile_whenNotFound_throwsEntityNotFoundException() {
		User u = new User();
		u.setId(5);
		when(userRepository.findById(5)).thenReturn(Optional.empty());

		EntityNotFoundException ex = assertThrows(EntityNotFoundException.class, () -> service.updateUserProfile(u));
		assertTrue(ex.getMessage().contains("not found"));
		verify(userRepository).findById(5);
	}

	@Test
	void updateUserProfile_switchType_throwsBadRequestException() {
		User existing = new User();
		existing.setId(6);
		existing.setRecipient(false);
		existing.setDonorData(new Donor());
		when(userRepository.findById(6)).thenReturn(Optional.of(existing));

		User updated = new User();
		updated.setId(6);
		updated.setRecipient(true);

		BadRequestException ex = assertThrows(BadRequestException.class, () -> service.updateUserProfile(updated));
		assertTrue(ex.getMessage().contains("Can't switch user type"));
	}

	@Test
	void updateUserProfile_forDonor_updatesNicknameOnlyIfPresent() {
		// existing donor
		Donor existingDonor = new Donor();
		existingDonor.setNickname("oldNick");
		User existing = new User();
		existing.setId(7);
		existing.setRecipient(false);
		existing.setDonorData(existingDonor);

		when(userRepository.findById(7)).thenReturn(Optional.of(existing));
		when(userRepository.save(existing)).thenAnswer(inv -> inv.getArgument(0));

		// updated donor with new nickname
		Donor updatedDonor = new Donor();
		updatedDonor.setNickname("newNick");
		User updated = new User();
		updated.setId(7);
		updated.setRecipient(false);
		updated.setDonorData(updatedDonor);

		User result = service.updateUserProfile(updated);

		assertEquals("newNick", result.getDonorData().getNickname());
		verify(userRepository).save(existing);
	}

	@Test
	void updateUserProfile_forRecipient_updatesFieldsAndOptionalNicknameImage() {
		// existing recipient
		Recipient existingR = new Recipient();
		existingR.setFirstName("A");
		existingR.setLastName("B");
		existingR.setNickname("keep");
		existingR.setImageUrl("keepUrl");
		User existing = new User();
		existing.setId(8);
		existing.setRecipient(true);
		existing.setRecipientData(existingR);

		when(userRepository.findById(8)).thenReturn(Optional.of(existing));
		when(userRepository.save(existing)).thenAnswer(inv -> inv.getArgument(0));

		// updated recipient
		Recipient upR = new Recipient();
		upR.setFirstName("X");
		upR.setLastName("Y");
		upR.setStreetAddress1("1");
		upR.setStreetAddress2("2");
		upR.setCity("C");
		upR.setState("S");
		upR.setZipCode("Z");
		upR.setLastAboutMe("about");
		upR.setLastReasonForHelp("help");
		upR.setNickname("newNick");
		upR.setImageUrl("newUrl");
		User updated = new User();
		updated.setId(8);
		updated.setRecipient(true);
		updated.setRecipientData(upR);

		User result = service.updateUserProfile(updated);

		Recipient r2 = result.getRecipientData();
		assertEquals("X", r2.getFirstName());
		assertEquals("Y", r2.getLastName());
		assertEquals("1", r2.getStreetAddress1());
		assertEquals("2", r2.getStreetAddress2());
		assertEquals("C", r2.getCity());
		assertEquals("S", r2.getState());
		assertEquals("Z", r2.getZipCode());
		assertEquals("about", r2.getLastAboutMe());
		assertEquals("help", r2.getLastReasonForHelp());
		assertEquals("newNick", r2.getNickname());
		assertEquals("newUrl", r2.getImageUrl());

		verify(userRepository).save(existing);
	}

	@Test
    void addDonor_whenUserNotFound_throwsEntityNotFoundException() {
        when(userRepository.findById(9)).thenReturn(Optional.empty());
        assertThrows(EntityNotFoundException.class,
                () -> service.addDonor(9, new Donor()));
    }

	@Test
	void addDonor_whenAlreadyDonor_throwsBadRequestException() {
		User u = new User();
		u.setId(10);
		u.setRecipient(false);
		when(userRepository.findById(10)).thenReturn(Optional.of(u));

		assertThrows(BadRequestException.class, () -> service.addDonor(10, new Donor()));
	}

	@Test
	void addDonor_success_switchesToDonorAndSaves() {
		User u = new User();
		u.setId(11);
		u.setRecipient(true);
		u.setDonorData(null);
		when(userRepository.findById(11)).thenReturn(Optional.of(u));
		when(userRepository.save(u)).thenReturn(u);

		Donor d = new Donor();
		User saved = service.addDonor(11, d);

		assertFalse(saved.isRecipient());
		assertSame(d, saved.getDonorData());
		verify(userRepository).save(u);
	}

	@Test
    void addRecipient_whenUserNotFound_throwsEntityNotFoundException() {
        when(userRepository.findById(12)).thenReturn(Optional.empty());
        assertThrows(EntityNotFoundException.class,
                () -> service.addRecipient(12, new Recipient()));
    }

	@Test
	void addRecipient_whenAlreadyRecipient_throwsBadRequestException() {
		User u = new User();
		u.setId(13);
		u.setRecipient(true);
		when(userRepository.findById(13)).thenReturn(Optional.of(u));

		assertThrows(BadRequestException.class, () -> service.addRecipient(13, new Recipient()));
	}

	@Test
	void addRecipient_success_setsRecipientDataFromDonorNickname() {
		Donor donorData = new Donor();
		donorData.setNickname("seedNick");

		User u = new User();
		u.setId(14);
		u.setRecipient(false);
		u.setDonorData(donorData);

		when(userRepository.findById(14)).thenReturn(Optional.of(u));
		when(userRepository.save(u)).thenReturn(u);

		Recipient r = new Recipient();
		r.setNickname(null);
		r.setImageUrl(null);

		User saved = service.addRecipient(14, r);

		assertTrue(saved.isRecipient());
		assertEquals("seedNick", saved.getRecipientData().getNickname());
		assertTrue(saved.getRecipientData().getImageUrl().endsWith("seedNick"));
		verify(userRepository).save(u);
	}

	@Test
	void deleteUser_delegatesToRepository() {
		service.deleteUser(15);
		verify(userRepository).deleteById(15);
	}

}

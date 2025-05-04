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
		// no additional setup
	}

	@Test
    void userExists_delegatesToRepository() {
        when(userRepository.existsById(1)).thenReturn(true);
        assertTrue(service.userExists(1));
        verify(userRepository).existsById(1);
    }

	@Test
    void donorExists_and_recipientExists_delegateToRepository() {
        when(userRepository.existsByIdAndRecipientAndDeletedIsFalse(2, false)).thenReturn(true);
        when(userRepository.existsByIdAndRecipientAndDeletedIsFalse(3, true)).thenReturn(false);

        assertTrue(service.donorExists(2));
        assertFalse(service.recipientExists(3));

        verify(userRepository).existsByIdAndRecipientAndDeletedIsFalse(2, false);
        verify(userRepository).existsByIdAndRecipientAndDeletedIsFalse(3, true);
    }

	@Test
	void getUserById_present_returnsUser() {
		User u = new User();
		when(userRepository.findById(10)).thenReturn(Optional.of(u));
		Optional<User> result = service.getUserById(10);
		assertTrue(result.isPresent());
		assertSame(u, result.get());
		verify(userRepository).findById(10);
	}

	@Test
	void getUserByCognitoId_present_and_notPresent() {
		User u = new User();
		when(userRepository.findByCognitoId("cid")).thenReturn(Optional.of(u));
		when(userRepository.findByCognitoId("none")).thenReturn(Optional.empty());

		assertTrue(service.getUserByCognitoId("cid").isPresent());
		assertFalse(service.getUserByCognitoId("none").isPresent());
		verify(userRepository).findByCognitoId("cid");
		verify(userRepository).findByCognitoId("none");
	}

	@Test
	void addUser_forDonor_withoutDonorData_createsDonorDataAndNickname() {
		User u = new User();
		u.setRecipient(false);
		u.setDonorData(null);
		when(userRepository.save(u)).thenReturn(u);

		User saved = service.addUser(u);

		assertNotNull(saved.getDonorData());
		assertNotNull(saved.getDonorData().getNickname());
		assertFalse(saved.getDonorData().getNickname().isEmpty());
		verify(userRepository).save(u);
	}

	@Test
	void addUser_forRecipient_withoutData_throwsModelException() {
		User u = new User();
		u.setRecipient(true);
		u.setRecipientData(null);

		assertThrows(ModelException.class, () -> service.addUser(u));
		verifyNoInteractions(userRepository);
	}

	@Test
	void addUser_forRecipient_createsNicknameAndImageUrl() {
		User u = new User();
		u.setRecipient(true);
		Recipient r = new Recipient();
		r.setNickname(null);
		r.setImageUrl("");
		u.setRecipientData(r);
		when(userRepository.save(u)).thenReturn(u);

		User saved = service.addUser(u);

		String nick = saved.getRecipientData().getNickname();
		String url = saved.getRecipientData().getImageUrl();
		assertNotNull(nick);
		assertFalse(nick.isEmpty());
		assertNotNull(url);
		assertTrue(url.contains(nick));
		verify(userRepository).save(u);
	}

	@Test
	void updateUserProfile_notFound_throwsEntityNotFoundException() {
		User u = new User();
		u.setId(5);
		when(userRepository.findById(5)).thenReturn(Optional.empty());

		assertThrows(EntityNotFoundException.class, () -> service.updateUserProfile(u));
		verify(userRepository).findById(5);
	}

	@Test
	void updateUserProfile_switchingType_throwsBadRequestException() {
		User existing = new User();
		existing.setId(6);
		existing.setRecipient(false);
		existing.setDonorData(new Donor());
		when(userRepository.findById(6)).thenReturn(Optional.of(existing));

		User updated = new User();
		updated.setId(6);
		updated.setRecipient(true);

		assertThrows(BadRequestException.class, () -> service.updateUserProfile(updated));
	}

	@Test
	void updateUserProfile_forDonor_updatesNickname() {
		Donor existingDonor = new Donor();
		existingDonor.setNickname("old");
		User existing = new User();
		existing.setId(7);
		existing.setRecipient(false);
		existing.setDonorData(existingDonor);
		when(userRepository.findById(7)).thenReturn(Optional.of(existing));
		when(userRepository.save(existing)).thenAnswer(inv -> inv.getArgument(0));

		Donor updatedDonor = new Donor();
		updatedDonor.setNickname("new");
		User updated = new User();
		updated.setId(7);
		updated.setRecipient(false);
		updated.setDonorData(updatedDonor);

		User result = service.updateUserProfile(updated);
		assertEquals("new", result.getDonorData().getNickname());
		verify(userRepository).save(existing);
	}

	@Test
	void updateUserProfile_forRecipient_updatesFields() {
		Recipient existingR = new Recipient();
		existingR.setFirstName("A");
		existingR.setLastName("B");
		User existing = new User();
		existing.setId(8);
		existing.setRecipient(true);
		existing.setRecipientData(existingR);
		when(userRepository.findById(8)).thenReturn(Optional.of(existing));
		when(userRepository.save(existing)).thenAnswer(inv -> inv.getArgument(0));

		Recipient upd = new Recipient();
		upd.setFirstName("X");
		upd.setLastName("Y");
		upd.setStreetAddress1("1");
		upd.setStreetAddress2("2");
		upd.setCity("C");
		upd.setState("S");
		upd.setZipCode("Z");
		upd.setLastAboutMe("about");
		upd.setLastReasonForHelp("help");
		upd.setNickname("nick");
		upd.setImageUrl("url");
		User updated = new User();
		updated.setId(8);
		updated.setRecipient(true);
		updated.setRecipientData(upd);

		User res = service.updateUserProfile(updated);
		Recipient r2 = res.getRecipientData();
		assertEquals("X", r2.getFirstName());
		assertEquals("Y", r2.getLastName());
		assertEquals("1", r2.getStreetAddress1());
		assertEquals("2", r2.getStreetAddress2());
		assertEquals("C", r2.getCity());
		assertEquals("S", r2.getState());
		assertEquals("Z", r2.getZipCode());
		assertEquals("about", r2.getLastAboutMe());
		assertEquals("help", r2.getLastReasonForHelp());
		assertEquals("nick", r2.getNickname());
		assertEquals("url", r2.getImageUrl());
		verify(userRepository).save(existing);
	}

	@Test
    void addDonor_notFound_throwsEntityNotFoundException() {
        when(userRepository.findById(9)).thenReturn(Optional.empty());
        assertThrows(EntityNotFoundException.class, () -> service.addDonor(9, new Donor()));
    }

	@Test
	void addDonor_alreadyDonor_throwsBadRequestException() {
		User u = new User();
		u.setId(10);
		u.setRecipient(false);
		when(userRepository.findById(10)).thenReturn(Optional.of(u));
		assertThrows(BadRequestException.class, () -> service.addDonor(10, new Donor()));
	}

	@Test
	void addDonor_success_switchesToDonor() {
		User u = new User();
		u.setId(11);
		u.setRecipient(true);
		when(userRepository.findById(11)).thenReturn(Optional.of(u));
		when(userRepository.save(u)).thenReturn(u);

		Donor d = new Donor();
		User saved = service.addDonor(11, d);

		assertFalse(saved.isRecipient());
		assertSame(d, saved.getDonorData());
		verify(userRepository).save(u);
	}

	@Test
    void addRecipient_notFound_throwsEntityNotFoundException() {
        when(userRepository.findById(12)).thenReturn(Optional.empty());
        assertThrows(EntityNotFoundException.class, () -> service.addRecipient(12, new Recipient()));
    }

	@Test
	void addRecipient_alreadyRecipient_throwsBadRequestException() {
		User u = new User();
		u.setId(13);
		u.setRecipient(true);
		when(userRepository.findById(13)).thenReturn(Optional.of(u));
		assertThrows(BadRequestException.class, () -> service.addRecipient(13, new Recipient()));
	}

	@Test
	void addRecipient_success_usesDonorNickname() {
		Donor donor = new Donor();
		donor.setNickname("seed");
		User u = new User();
		u.setId(14);
		u.setRecipient(false);
		u.setDonorData(donor);
		when(userRepository.findById(14)).thenReturn(Optional.of(u));
		when(userRepository.save(u)).thenReturn(u);

		Recipient r = new Recipient();
		r.setNickname(null);
		r.setImageUrl(null);

		User saved = service.addRecipient(14, r);

		assertTrue(saved.isRecipient());
		assertEquals("seed", saved.getRecipientData().getNickname());
		assertTrue(saved.getRecipientData().getImageUrl().contains("seed"));
		verify(userRepository).save(u);
	}

	@Test
    void deleteUser_notFound_throwsEntityNotFoundException() {
        when(userRepository.findById(15)).thenReturn(Optional.empty());
        assertThrows(EntityNotFoundException.class, () -> service.deleteUser(15));
    }

	@Test
	void deleteUser_success_marksDeletedAndSaves() {
		User u = new User();
		u.setId(16);
		u.setDeleted(false);
		when(userRepository.findById(16)).thenReturn(Optional.of(u));
		when(userRepository.save(u)).thenReturn(u);

		service.deleteUser(16);

		assertTrue(u.isDeleted());
		verify(userRepository).save(u);
	}

}

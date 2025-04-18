package org.upLift.services;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.upLift.exceptions.ModelException;
import org.upLift.model.Donor;
import org.upLift.model.User;
import org.upLift.repositories.UserRepository;

import java.util.Optional;

@Service
@Transactional
public class UserServiceImpl implements UserService {

	private final UserRepository userRepository;

	public UserServiceImpl(UserRepository userRepository) {
		this.userRepository = userRepository;
	}

	@Override
	public boolean userExists(Integer id) {
		return userRepository.existsById(id);
	}

	@Override
	public boolean donorExists(Integer id) {
		return userRepository.existsByIdAndRecipient(id, false);
	}

	@Override
	public boolean recipientExists(Integer id) {
		return userRepository.existsByIdAndRecipient(id, true);
	}

	@Override
	public Optional<User> getUserById(Integer id) {
		var result = userRepository.findById(id);
		return loadChildData(result);
	}

	@Override
	public Optional<User> getUserByCognitoId(String cognitoId) {
		var result = userRepository.findByCognitoId(cognitoId);
		return loadChildData(result);
	}

	@Override
	public Optional<User> getUserByEmail(String email) {
		var result = userRepository.findByEmail(email);
		return loadChildData(result);
	}

	@Override
	public User addUser(User user) {
		// Donor entries may not come with any associated donor data, in which case it
		// must be added manually
		if (user.isDonor() && user.getDonorData() == null) {
			user.setDonorData(new Donor());
		}
		// Recipient entries must always include additional data
		if (user.isRecipient() && user.getRecipientData() == null) {
			throw new ModelException("New recipient entry must include recipient data");
		}

		return userRepository.save(user);
	}

	@Override
	public User updateUser(User user) {
		return userRepository.save(user);
	}

	@Override
	public void deleteUser(Integer id) {
		userRepository.deleteById(id);
	}

	Optional<User> loadChildData(Optional<User> result) {
		// TODO: Clear out the other child data object here? or leave that for controller?
		if (result.isPresent()) {
			var user = result.get();
			if (user.isRecipient()) {
				// If the user is created before the recipient this creates a null
				// exception.
				if (user.getRecipientData() != null) {
					user.getRecipientData().getCreatedAt();
				}
			}
			else {
				// If the user is created before the recipient this creates a null
				// exception.
				if (user.getDonorData() != null) {
					user.getDonorData().getCreatedAt();
				}
			}
			return Optional.of(user);
		}
		else {
			return result;
		}
	}

}

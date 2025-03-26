package org.upLift.services;

import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;
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
				user.getRecipientData().getCreatedAt();
			}
			else {
				user.getDonorData().getCreatedAt();
			}
			return Optional.of(user);
		}
		else {
			return result;
		}
	}

}

package org.upLift.services;

import org.springframework.validation.annotation.Validated;
import org.upLift.model.User;

import java.util.Optional;

@Validated
public interface UserService {

	Optional<User> getUserById(Integer id);

	Optional<User> getUserByCognitoId(String cognitoId);

	Optional<User> getUserByEmail(String email);

	User addUser(User user);

	User updateUser(User user);

	void deleteUser(Integer id);

}

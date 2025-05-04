package org.upLift.api;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;
import org.upLift.exceptions.EntityNotFoundException;
import org.upLift.model.Donor;
import org.upLift.model.Recipient;
import org.upLift.model.User;
import org.upLift.services.UserService;

@RestController
public class UsersApiController implements UsersApi {

	private static final Logger LOG = LoggerFactory.getLogger(UsersApiController.class);

	private final UserService userService;

	@Autowired
	public UsersApiController(UserService userService) {
		this.userService = userService;
	}

	public ResponseEntity<User> addUser(User body) {
		LOG.info("Adding new user: {}", body.isRecipient() ? "recipient" : "donor");
		LOG.debug("New user info: {}", body);
		var savedUser = userService.addUser(body);
		return new ResponseEntity<>(savedUser, HttpStatus.CREATED);
	}

	@Override
	public void deleteUser(Integer userId) {
		LOG.info("Deleting user: {}", userId);
		userService.deleteUser(userId);
	}

	@Override
	public User getUserById(Integer userId) {
		LOG.info("Retrieving user: {}", userId);
		var user = userService.getUserById(userId);
		if (user.isPresent()) {
			return user.get();
		}
		else {
			throw new EntityNotFoundException(userId, "User", "User not found");
		}
	}

	@Override
	public ResponseEntity<User> getUserByCognitoId(String cognitoId) {
		LOG.info("Retrieving user: {}", cognitoId);
		var user = userService.getUserByCognitoId(cognitoId);
		if (user.isPresent()) {
			return new ResponseEntity<>(user.get(), HttpStatus.OK);
		}
		else {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}

	@Override
	public User updateUser(User body) {
		LOG.info("Updating user: {}", body.getId());
		return userService.updateUserProfile(body);
	}

	@Override
	public User addDonor(int userId, Donor body) {
		LOG.info("Switching recipient {} to donor", userId);
		return userService.addDonor(userId, body);
	}

	@Override
	public User addRecipient(int userId, Recipient body) {
		LOG.info("Switching donor {} to recipient", userId);
		return userService.addRecipient(userId, body);
	}

}

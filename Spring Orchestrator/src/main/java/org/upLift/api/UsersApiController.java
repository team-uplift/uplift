package org.upLift.api;

import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
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

	public ResponseEntity<User> addUser(@Valid @RequestBody User body) {
		LOG.info("Adding new user: {}", body.isRecipient() ? "recipient" : "donor");
		LOG.debug("New user info: {}", body);
		var savedUser = userService.addUser(body);
		return new ResponseEntity<>(savedUser, HttpStatus.CREATED);
	}

	@Override
	public void deleteUser(@PathVariable("userId") Integer userId) {
		LOG.info("Deleting user: {}", userId);
		userService.deleteUser(userId);
	}

	@Override
	public ResponseEntity<User> getUserById(@PathVariable("userId") Integer userId) {
		LOG.info("Retrieving user: {}", userId);
		var user = userService.getUserById(userId);
		if (user.isPresent()) {
			return new ResponseEntity<>(user.get(), HttpStatus.OK);
		}
		else {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}

	@Override
	public ResponseEntity<User> getUserByCognitoId(@PathVariable("cognitoId") String cognitoId) {
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
	public ResponseEntity<User> updateUser(@Valid @RequestBody User body) {
		LOG.info("Updating user: {}", body.getId());
		LOG.debug("Updated user info: {}", body);
		if (userService.userExists(body.getId())) {
			var savedUser = userService.updateUser(body);
			return new ResponseEntity<>(savedUser, HttpStatus.OK);
		}
		else {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}

}

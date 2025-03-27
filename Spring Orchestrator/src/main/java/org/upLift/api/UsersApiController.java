package org.upLift.api;

import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.media.Schema;
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

	public ResponseEntity<User> addUser(
			// @formatter:off
//			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
//					required = true,
//					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			// @formatter:on
			@Parameter(in = ParameterIn.DEFAULT, description = "Create a new user in the app", required = true,
					schema = @Schema()) @Valid @RequestBody User body) {
		LOG.info("Adding new user: {}", body.isRecipient() ? "recipient" : "donor");
		LOG.debug("New user info: {}", body);
		var savedUser = userService.addUser(body);
		return new ResponseEntity<>(savedUser, HttpStatus.CREATED);
	}

	@Override
	public void deleteUser(
			// @formatter:off
//			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
//					required = true,
//					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
//			@Parameter(in = ParameterIn.HEADER, description = "", schema = @Schema()) @RequestHeader(value = "api_key",
//							required = false) String apiKey,
			// @formatter:on
			@Parameter(in = ParameterIn.PATH, description = "User id to delete", required = true,
					schema = @Schema()) @PathVariable("userId") Integer userId) {
		LOG.info("Deleting user: {}", userId);
		userService.deleteUser(userId);
	}

	@Override
	public ResponseEntity<User> getUserById(
			// @formatter:off
//			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
//					required = true,
//					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			// @formatter:on
			@Parameter(in = ParameterIn.PATH, description = "ID of user to return", required = true,
					schema = @Schema()) @PathVariable("userId") Integer userId) {
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
	public ResponseEntity<User> getUserByCognitoId(
			// @formatter:off
//			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
//					required = true,
//					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			// @formatter:on
			@Parameter(in = ParameterIn.PATH, description = "Cognito ID of user to return", required = true,
					schema = @Schema()) @PathVariable("cognitoId") String cognitoId) {
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
	public ResponseEntity<User> updateUser(
			// @formatter:off
//			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
//					required = true,
//					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			// @formatter:on
			@Parameter(in = ParameterIn.DEFAULT, description = "Update an existent user in the store", required = true,
					schema = @Schema()) @Valid @RequestBody User body) {
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

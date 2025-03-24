package org.upLift.api;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.upLift.model.User;
import org.upLift.services.UserService;

import java.io.IOException;

@RestController
public class UsersApiController implements UsersApi {

	private static final Logger log = LoggerFactory.getLogger(UsersApiController.class);

	private final ObjectMapper objectMapper;

	private final HttpServletRequest request;

	private final UserService userService;

	@Autowired
	public UsersApiController(ObjectMapper objectMapper, HttpServletRequest request, UserService userService) {
		this.objectMapper = objectMapper;
		this.request = request;
		this.userService = userService;
	}

	public ResponseEntity<User> addUser(
			// @Parameter(in = ParameterIn.HEADER, description = "Tracks the session for
			// the given set of requests.",
			// required = true,
			// schema = @Schema()) @RequestHeader(value = "session_id", required = true)
			// String sessionId,
			@Parameter(in = ParameterIn.DEFAULT, description = "Create a new user in the app", required = true,
					schema = @Schema()) @Valid @RequestBody User body) {
		var savedUser = userService.addUser(body);
		return new ResponseEntity<>(savedUser, HttpStatus.CREATED);
	}

	public void deleteUser(
			@Parameter(in = ParameterIn.PATH, description = "User id to delete", required = true,
					schema = @Schema()) @PathVariable("userId") Integer userId,
			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
					required = true,
					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			@Parameter(in = ParameterIn.HEADER, description = "", schema = @Schema()) @RequestHeader(value = "api_key",
					required = false) String apiKey) {
		userService.deleteUser(userId);
	}

	public ResponseEntity<User> getUserById(
			@Parameter(in = ParameterIn.PATH, description = "ID of user to return", required = true,
					schema = @Schema()) @PathVariable("userId") Integer userId,
			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
					required = true,
					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId) {
		var user = userService.getUserById(userId);
		if (user.isPresent()) {
			return new ResponseEntity<>(user.get(), HttpStatus.OK);
		}
		else {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}

	public ResponseEntity<User> getUserByCognitoId(
			@Parameter(in = ParameterIn.PATH, description = "Cognito ID of user to return", required = true,
					schema = @Schema()) @PathVariable("cognitoId") String cognitoId,
			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
					required = true,
					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId) {
		var user = userService.getUserByCognitoId(cognitoId);
		if (user.isPresent()) {
			return new ResponseEntity<>(user.get(), HttpStatus.OK);
		}
		else {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}

	public ResponseEntity<User> updateUser(
			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
					required = true,
					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			@Parameter(in = ParameterIn.DEFAULT, description = "Update an existent user in the store",
					required = true, schema = @Schema()) @Valid @RequestBody User body) {
		String accept = request.getHeader("Accept");
		if (accept != null && accept.contains("application/json")) {
			try {
				return new ResponseEntity<User>(objectMapper.readValue(
						"{\n  \"income_verified\" : true,\n  \"cognito_id\" : \"oijwedf-wrefwefr-saedf3rweg-gv\",\n  \"amount_received\" : 300.15,\n  \"nickname\" : \"PotatoKing\",\n  \"id\" : 10,\n  \"last_profile_text\" : \"I like potatoes.\",\n  \"email\" : \"testUser\",\n  \"username\" : \"testUser\",\n  \"tags\" : [ {\n    \"tag_name\" : \"Potato\"\n  }, {\n    \"tag_name\" : \"Potato\"\n  } ]\n}",
						User.class), HttpStatus.NOT_IMPLEMENTED);
			}
			catch (IOException e) {
				log.error("Couldn't serialize response for content type application/json", e);
				return new ResponseEntity<User>(HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}

		return new ResponseEntity<User>(HttpStatus.NOT_IMPLEMENTED);
	}

	public ResponseEntity<Void> updateUserWithForm(
			@Parameter(in = ParameterIn.PATH, description = "ID of user that needs to be updated", required = true,
					schema = @Schema()) @PathVariable("userId") Integer userId,
			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
					required = true,
					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			@Parameter(in = ParameterIn.QUERY, description = "Name of user that needs to be updated",
					schema = @Schema()) @Valid @RequestParam(value = "name", required = false) String name,
			@Parameter(in = ParameterIn.QUERY, description = "Status of user that needs to be updated",
					schema = @Schema()) @Valid @RequestParam(value = "status", required = false) String status) {
		String accept = request.getHeader("Accept");
		return new ResponseEntity<Void>(HttpStatus.NOT_IMPLEMENTED);
	}

}

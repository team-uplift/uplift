package org.upLift.api;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.upLift.model.Donor;
import org.upLift.model.Recipient;
import org.upLift.model.User;

@Validated
public interface UsersApi {

	@Operation(summary = "Add a new user to the app",
			description = "Add a new user to the app.  User may be either donor or user.  "
					+ "If donor, the child donor_Data should be provided.  "
					+ "If user, the child user_Data should be provided.",
			security = { @SecurityRequirement(name = "userstore_auth", scopes = { "write:users", "read:users" }) },
			tags = { "User" })
	@ApiResponses(
			value = {
					@ApiResponse(responseCode = "200", description = "Successful operation",
							content = @Content(mediaType = "application/json",
									schema = @Schema(implementation = User.class))),

					@ApiResponse(responseCode = "400", description = "Invalid input"),

					@ApiResponse(responseCode = "422", description = "Validation exception") })
	@PostMapping(value = "/users", produces = { "application/json" }, consumes = { "application/json" })
	ResponseEntity<User> addUser(
	// @formatter:off
//			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
//					required = true,
//					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			// @formatter:on
			@Parameter(in = ParameterIn.DEFAULT, description = "Create a new user in the app", required = true,
					schema = @Schema()) @Valid @RequestBody User body);

	@Operation(summary = "Deletes a user", description = "delete a user",
			security = { @SecurityRequirement(name = "userstore_auth", scopes = { "write:users", "read:users" }) },
			tags = { "User" })
	@ApiResponses(value = { @ApiResponse(responseCode = "400", description = "Invalid ID supplied") })
	@RequestMapping(value = "/users/{userId}", method = RequestMethod.DELETE)
	void deleteUser(
	// @formatter:off
//			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
//					required = true,
//					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
//			@Parameter(in = ParameterIn.HEADER, description = "", schema = @Schema()) @RequestHeader(value = "api_key",
//							required = false) String apiKey,
			// @formatter:on
			@Parameter(in = ParameterIn.PATH, description = "User id to delete", required = true,
					schema = @Schema()) @PathVariable("userId") Integer userId);

	@Operation(summary = "Find user by ID", description = "Returns a single user, identified by persistence index",
			security = { @SecurityRequirement(name = "api_key"),
					@SecurityRequirement(name = "userstore_auth", scopes = { "write:users", "read:users" }) },
			tags = { "User" })
	@ApiResponses(
			value = {
					@ApiResponse(responseCode = "200", description = "successful operation",
							content = @Content(mediaType = "application/json",
									schema = @Schema(implementation = User.class))),

					@ApiResponse(responseCode = "400", description = "Invalid ID supplied"),

					@ApiResponse(responseCode = "404", description = "User not found") })
	@GetMapping(value = "/users/{userId}", produces = { "application/json" })
	ResponseEntity<User> getUserById(
	// @formatter:off
//			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
//					required = true,
//					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			// @formatter:on
			@Parameter(in = ParameterIn.PATH, description = "ID of user to return", required = true,
					schema = @Schema()) @PathVariable("userId") Integer userId);

	@Operation(summary = "Find user by Cognito sub", description = "Returns a single user, identified by Cognito sub",
			security = { @SecurityRequirement(name = "api_key"),
					@SecurityRequirement(name = "userstore_auth", scopes = { "write:users", "read:users" }) },
			tags = { "User" })
	@ApiResponses(
			value = {
					@ApiResponse(responseCode = "200", description = "successful operation",
							content = @Content(mediaType = "application/json",
									schema = @Schema(implementation = User.class))),

					@ApiResponse(responseCode = "400", description = "Invalid ID supplied"),

					@ApiResponse(responseCode = "404", description = "User not found") })
	@GetMapping(value = "/users/cognito/{cognitoId}", produces = { "application/json" })
	ResponseEntity<User> getUserByCognitoId(
	// @formatter:off
//			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
//					required = true,
//					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			// @formatter:on
			@Parameter(in = ParameterIn.PATH, description = "Cognito ID of user to return", required = true,
					schema = @Schema()) @PathVariable("cognitoId") String cognitoId);

	@Operation(summary = "Update an existing user", description = "Update an existing user by Id",
			security = { @SecurityRequirement(name = "userstore_auth", scopes = { "write:users", "read:users" }) },
			tags = { "User" })
	@ApiResponses(
			value = {
					@ApiResponse(responseCode = "200", description = "Successful operation",
							content = @Content(mediaType = "application/json",
									schema = @Schema(implementation = User.class))),

					@ApiResponse(responseCode = "400", description = "Invalid ID supplied"),

					@ApiResponse(responseCode = "404", description = "User not found"),

					@ApiResponse(responseCode = "422", description = "Validation exception") })
	@PutMapping(value = "/users", produces = { "application/json" }, consumes = { "application/json" })
	ResponseEntity<User> updateUser(
	// @formatter:off
//			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
//					required = true,
//					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			// @formatter:on
			@Parameter(in = ParameterIn.DEFAULT, description = "Update an existent user in the store", required = true,
					schema = @Schema()) @Valid @RequestBody User body);

	@Operation(summary = "Switch user to a donor",
			description = "Switch user from a recipient to a donor with the provided info",
			security = { @SecurityRequirement(name = "userstore_auth", scopes = { "write:users", "read:users" }) },
			tags = { "Donor", "User" })
	@ApiResponses(
			value = {
					@ApiResponse(responseCode = "200", description = "Switched to donor",
							content = @Content(mediaType = "application/json",
									schema = @Schema(implementation = User.class))),

					@ApiResponse(responseCode = "400", description = "Invalid input"),

					@ApiResponse(responseCode = "422", description = "Validation exception") })
	@PutMapping(value = "/users/switch/donor", produces = { "application/json" }, consumes = { "application/json" })
	ResponseEntity<User> addDonor(
			@Parameter(in = ParameterIn.DEFAULT, description = "Provide donor info to switch user to a donor",
					required = true, schema = @Schema()) @Valid @RequestBody Donor body);

	@Operation(summary = "Switch user to a recipient",
			description = "Switch user from a donor to a recipient with the provided info",
			security = { @SecurityRequirement(name = "userstore_auth", scopes = { "write:users", "read:users" }) },
			tags = { "Recipient", "User" })
	@ApiResponses(
			value = {
					@ApiResponse(responseCode = "200", description = "Switched to recipient",
							content = @Content(mediaType = "application/json",
									schema = @Schema(implementation = User.class))),

					@ApiResponse(responseCode = "400", description = "Invalid input"),

					@ApiResponse(responseCode = "422", description = "Validation exception") })
	@PutMapping(value = "/users/switch/recipient", produces = { "application/json" },
			consumes = { "application/json" })
	ResponseEntity<User> addRecipient(
			@Parameter(in = ParameterIn.DEFAULT, description = "Provide donor info to switch user to a recipient",
					required = true, schema = @Schema()) @Valid @RequestBody Recipient body);

}

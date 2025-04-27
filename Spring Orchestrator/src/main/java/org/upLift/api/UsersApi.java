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
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.upLift.model.Donor;
import org.upLift.model.ErrorResults;
import org.upLift.model.Recipient;
import org.upLift.model.User;

@Validated
public interface UsersApi {

	@Operation(summary = "Add a new user to the app",
			description = "Add a new user to the app.  User may be either donor or recipient.  "
					+ "If donor, the child donorData should be provided.  "
					+ "If recipient, the child recipientData should be provided.",
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
	ResponseEntity<User> addUser(@Parameter(in = ParameterIn.DEFAULT, description = "Create a new user in the app",
			required = true, schema = @Schema()) @Valid @RequestBody User body);

	@Operation(summary = "Deletes a user", description = "delete a user",
			security = { @SecurityRequirement(name = "userstore_auth", scopes = { "write:users", "read:users" }) },
			tags = { "User" })
	@ApiResponses(value = { @ApiResponse(responseCode = "400", description = "Invalid ID supplied") })
	@RequestMapping(value = "/users/{userId}", method = RequestMethod.DELETE)
	void deleteUser(@Parameter(in = ParameterIn.PATH, description = "User id to delete", required = true,
			schema = @Schema()) @PathVariable("userId") Integer userId);

	@Operation(summary = "Find user by ID", description = "Returns a single user, identified by persistence index",
			security = { @SecurityRequirement(name = "api_key"),
					@SecurityRequirement(name = "userstore_auth", scopes = { "read:users" }) },
			tags = { "User" })
	@ApiResponses(
			value = {
					@ApiResponse(responseCode = "200", description = "successful operation",
							content = @Content(mediaType = "application/json",
									schema = @Schema(implementation = User.class))),

					@ApiResponse(responseCode = "400", description = "Invalid ID supplied"),

					@ApiResponse(responseCode = "404", description = "User not found") })
	@GetMapping(value = "/users/{userId}", produces = { "application/json" })
	ResponseEntity<User> getUserById(@Parameter(in = ParameterIn.PATH, description = "ID of user to return",
			required = true, schema = @Schema()) @PathVariable("userId") Integer userId);

	@Operation(summary = "Find user by Cognito sub", description = "Returns a single user, identified by Cognito sub",
			security = { @SecurityRequirement(name = "api_key"),
					@SecurityRequirement(name = "userstore_auth", scopes = { "read:users" }) },
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
					@ApiResponse(responseCode = "400", description = "Invalid request",
							content = @Content(mediaType = "application/json",
									schema = @Schema(implementation = ErrorResults.GeneralError.class))),
					@ApiResponse(responseCode = "404", description = "User not found to update",
							content = @Content(mediaType = "application/json",
									schema = @Schema(implementation = ErrorResults.EntityNotFoundError.class))),
					@ApiResponse(responseCode = "422", description = "Validation exception") })
	@PutMapping(value = "/users", produces = { "application/json" }, consumes = { "application/json" })
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	User updateUser(@Parameter(in = ParameterIn.DEFAULT, description = "Update an existent user in the store",
			required = true, schema = @Schema()) @Valid @RequestBody User body);

	@Operation(summary = "Switch user to a donor",
			description = "Switch user from a recipient to a donor with the provided info",
			security = { @SecurityRequirement(name = "userstore_auth", scopes = { "write:users", "read:users" }) },
			tags = { "Donor", "User" })
	@ApiResponses(
			value = {
					@ApiResponse(responseCode = "200", description = "Switched to donor",
							content = @Content(mediaType = "application/json",
									schema = @Schema(implementation = User.class))),
					@ApiResponse(responseCode = "400", description = "User already a donor, can't switch",
							content = @Content(mediaType = "application/json",
									schema = @Schema(implementation = ErrorResults.GeneralError.class))),
					@ApiResponse(responseCode = "404", description = "User not found to update",
							content = @Content(mediaType = "application/json",
									schema = @Schema(implementation = ErrorResults.EntityNotFoundError.class))),
					@ApiResponse(responseCode = "422", description = "Validation exception") })
	@PutMapping(value = "/users/switch/donor/{userId}", produces = { "application/json" },
			consumes = { "application/json" })
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	User addDonor(
			@Parameter(in = ParameterIn.PATH, description = "Id of the user to switch to a donor", required = true,
					schema = @Schema()) @PathVariable("userId") int userId,
			@Parameter(in = ParameterIn.DEFAULT,
					description = "Provide donor info to switch user to a donor, should NOT include the id property",
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
					@ApiResponse(responseCode = "400", description = "User already a donor, can't switch",
							content = @Content(mediaType = "application/json",
									schema = @Schema(implementation = ErrorResults.GeneralError.class))),
					@ApiResponse(responseCode = "404", description = "User not found to update",
							content = @Content(mediaType = "application/json",
									schema = @Schema(implementation = ErrorResults.EntityNotFoundError.class))),
					@ApiResponse(responseCode = "422", description = "Validation exception") })
	@PutMapping(value = "/users/switch/recipient/{userId}", produces = { "application/json" },
			consumes = { "application/json" })
	@ResponseStatus(HttpStatus.OK)
	@ResponseBody
	User addRecipient(
			@Parameter(in = ParameterIn.PATH, description = "Id of the user to switch to a recipient", required = true,
					schema = @Schema()) @PathVariable("userId") int userId,
			@Parameter(in = ParameterIn.DEFAULT, description = "Provide donor info to switch user to a recipient",
					required = true, schema = @Schema()) @Valid @RequestBody Recipient body);

}

package org.upLift.api;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.upLift.model.Recipient;

import jakarta.validation.Valid;
import jakarta.servlet.http.HttpServletRequest;
import org.upLift.services.RecipientService;
import org.upLift.services.UserService;

import java.io.IOException;
import java.util.List;

@jakarta.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen",
		date = "2025-03-16T14:18:35.909799305Z[GMT]")
@RestController
public class RecipientsApiController implements RecipientsApi {

	private static final Logger log = LoggerFactory.getLogger(RecipientsApiController.class);

	private final ObjectMapper objectMapper;

	private final HttpServletRequest request;

	private final RecipientService recipientService;

	private final UserService userService;

	@org.springframework.beans.factory.annotation.Autowired
	public RecipientsApiController(ObjectMapper objectMapper, HttpServletRequest request,
			RecipientService recipientService, UserService userService) {
		this.objectMapper = objectMapper;
		this.request = request;
		this.recipientService = recipientService;
		this.userService = userService;
	}

	public ResponseEntity<Recipient> addRecipient(
			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
					required = true,
					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			@Parameter(in = ParameterIn.DEFAULT, description = "Create a new recipient in the store", required = true,
					schema = @Schema()) @Valid @RequestBody Recipient body) {
		String accept = request.getHeader("Accept");
		if (accept != null) {
			try {
				// Get existing user with provided id
				if (userService.getUserById(body.getId()).isEmpty()) {
					log.error("User with provided Id not found {}", body.getId());
					return new ResponseEntity<>(HttpStatus.NOT_FOUND);
				}

				// This assumes we have a User already built to create a recipient. This
				// is required because the user id is
				// a foreign key and a primary key for the Recipient.
				body.setUser(userService.getUserById(body.getId()).get());

				// The UI may send us an id or nothing, BUT we need to guarantee the id to
				// be null
				// so it can be set by the database from the provided user appropriately.
				body.setId(null);

				Recipient newRecipient = recipientService.saveRecipient(body);
				return new ResponseEntity<>(newRecipient, HttpStatus.CREATED);
			}
			catch (RuntimeException e) {
				log.error("Couldn't serialize response for content type application/json", e);
				return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}

		return new ResponseEntity<Recipient>(HttpStatus.NOT_IMPLEMENTED);
	}

	public ResponseEntity<Void> deleteRecipient(
			@Parameter(in = ParameterIn.PATH, description = "Recipient id to delete", required = true,
					schema = @Schema()) @PathVariable("recipientId") Long recipientId,
			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
					required = true,
					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			@Parameter(in = ParameterIn.HEADER, description = "", schema = @Schema()) @RequestHeader(value = "api_key",
					required = false) String apiKey) {
		String accept = request.getHeader("Accept");
		return new ResponseEntity<Void>(HttpStatus.NOT_IMPLEMENTED);
	}

	public ResponseEntity<List<Recipient>> findRecipientsByTags(
			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
					required = true,
					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			@Parameter(in = ParameterIn.QUERY, description = "Tags to filter by",
					schema = @Schema()) @Valid @RequestParam(value = "tags", required = false) List<String> tags) {
		String accept = request.getHeader("Accept");
		if (accept != null) {
			try {
				return new ResponseEntity<List<Recipient>>(objectMapper.readValue(
						"[ {\n  \"income_verified\" : true,\n  \"cognito_id\" : \"oijwedf-wrefwefr-saedf3rweg-gv\",\n  \"amount_received\" : 300.15,\n  \"nickname\" : \"PotatoKing\",\n  \"id\" : 10,\n  \"last_profile_text\" : \"I like potatoes.\",\n  \"email\" : \"testUser\",\n  \"username\" : \"testUser\",\n  \"tags\" : [ {\n    \"tag_name\" : \"Potato\"\n  }, {\n    \"tag_name\" : \"Potato\"\n  } ]\n}, {\n  \"income_verified\" : true,\n  \"cognito_id\" : \"oijwedf-wrefwefr-saedf3rweg-gv\",\n  \"amount_received\" : 300.15,\n  \"nickname\" : \"PotatoKing\",\n  \"id\" : 10,\n  \"last_profile_text\" : \"I like potatoes.\",\n  \"email\" : \"testUser\",\n  \"username\" : \"testUser\",\n  \"tags\" : [ {\n    \"tag_name\" : \"Potato\"\n  }, {\n    \"tag_name\" : \"Potato\"\n  } ]\n} ]",
						List.class), HttpStatus.NOT_IMPLEMENTED);
			}
			catch (IOException e) {
				log.error("Couldn't serialize response for content type application/json", e);
				return new ResponseEntity<List<Recipient>>(HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}

		return new ResponseEntity<List<Recipient>>(HttpStatus.NOT_IMPLEMENTED);
	}

	public ResponseEntity<Recipient> getRecipientById(
			@Parameter(in = ParameterIn.PATH, description = "ID of recipient to return", required = true,
					schema = @Schema()) @PathVariable("recipientId") Long recipientId,
			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
					required = true,
					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId) {
		String accept = request.getHeader("Accept");
		if (accept != null) {
			try {
				return new ResponseEntity<Recipient>(objectMapper.readValue(
						"{\n  \"income_verified\" : true,\n  \"cognito_id\" : \"oijwedf-wrefwefr-saedf3rweg-gv\",\n  \"amount_received\" : 300.15,\n  \"nickname\" : \"PotatoKing\",\n  \"id\" : 10,\n  \"last_profile_text\" : \"I like potatoes.\",\n  \"email\" : \"testUser\",\n  \"username\" : \"testUser\",\n  \"tags\" : [ {\n    \"tag_name\" : \"Potato\"\n  }, {\n    \"tag_name\" : \"Potato\"\n  } ]\n}",
						Recipient.class), HttpStatus.NOT_IMPLEMENTED);
			}
			catch (IOException e) {
				log.error("Couldn't serialize response for content type application/json", e);
				return new ResponseEntity<Recipient>(HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}

		return new ResponseEntity<Recipient>(HttpStatus.NOT_IMPLEMENTED);
	}

	public ResponseEntity<Recipient> updateRecipient(
			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
					required = true,
					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			@Parameter(in = ParameterIn.DEFAULT, description = "Update an existent recipient in the store",
					required = true, schema = @Schema()) @Valid @RequestBody Recipient body) {
		String accept = request.getHeader("Accept");
		if (accept != null) {
			try {
				return new ResponseEntity<Recipient>(objectMapper.readValue(
						"{\n  \"income_verified\" : true,\n  \"cognito_id\" : \"oijwedf-wrefwefr-saedf3rweg-gv\",\n  \"amount_received\" : 300.15,\n  \"nickname\" : \"PotatoKing\",\n  \"id\" : 10,\n  \"last_profile_text\" : \"I like potatoes.\",\n  \"email\" : \"testUser\",\n  \"username\" : \"testUser\",\n  \"tags\" : [ {\n    \"tag_name\" : \"Potato\"\n  }, {\n    \"tag_name\" : \"Potato\"\n  } ]\n}",
						Recipient.class), HttpStatus.NOT_IMPLEMENTED);
			}
			catch (IOException e) {
				log.error("Couldn't serialize response for content type application/json", e);
				return new ResponseEntity<Recipient>(HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}

		return new ResponseEntity<Recipient>(HttpStatus.NOT_IMPLEMENTED);
	}

	public ResponseEntity<Void> updateRecipientTags(
			@Parameter(in = ParameterIn.PATH, description = "Recipient id to generate tags for", required = true,
					schema = @Schema()) @PathVariable("recipientId") Long recipientId,
			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
					required = true,
					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			@Parameter(in = ParameterIn.HEADER, description = "", schema = @Schema()) @RequestHeader(value = "api_key",
					required = false) String apiKey,
			@Parameter(in = ParameterIn.QUERY,
					description = "A combined set of text or paragraph detailing the description to be used for tag generation",
					schema = @Schema()) @Valid @RequestParam(value = "query_text", required = false) String queryText) {
		String accept = request.getHeader("Accept");
		return new ResponseEntity<Void>(HttpStatus.NOT_IMPLEMENTED);
	}

	public ResponseEntity<Void> updateRecipientWithForm(
			@Parameter(in = ParameterIn.PATH, description = "ID of recipient that needs to be updated", required = true,
					schema = @Schema()) @PathVariable("recipientId") Long recipientId,
			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
					required = true,
					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			@Parameter(in = ParameterIn.QUERY, description = "Name of recipient that needs to be updated",
					schema = @Schema()) @Valid @RequestParam(value = "name", required = false) String name,
			@Parameter(in = ParameterIn.QUERY, description = "Status of recipient that needs to be updated",
					schema = @Schema()) @Valid @RequestParam(value = "status", required = false) String status) {
		String accept = request.getHeader("Accept");
		return new ResponseEntity<Void>(HttpStatus.NOT_IMPLEMENTED);
	}

}

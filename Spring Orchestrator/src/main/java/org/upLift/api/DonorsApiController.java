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
import org.springframework.web.bind.annotation.*;
import org.upLift.model.Donor;
import org.upLift.services.DonorService;
import org.upLift.services.UserService;

import java.io.IOException;

@jakarta.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen",
		date = "2025-03-16T14:18:35.909799305Z[GMT]")
@RestController
public class DonorsApiController implements DonorsApi {

	private static final Logger log = LoggerFactory.getLogger(DonorsApiController.class);

	private final ObjectMapper objectMapper;

	private final DonorService donorService;

	private final HttpServletRequest request;

	private final UserService userService;

	@org.springframework.beans.factory.annotation.Autowired
	public DonorsApiController(ObjectMapper objectMapper, DonorService donorService, HttpServletRequest request,
			UserService userService) {
		this.objectMapper = objectMapper;
		this.donorService = donorService;
		this.request = request;
		this.userService = userService;
	}

	public ResponseEntity<Donor> addDonor(
			// @Parameter(in = ParameterIn.HEADER, description = "Tracks the session for
			// the given set of requests.",
			// required = true,
			// schema = @Schema()) @RequestHeader(value = "session_id", required = true)
			// String sessionId,
			@Parameter(in = ParameterIn.DEFAULT, description = "Create a new recipient in the store", required = true,
					schema = @Schema()) @Valid @RequestBody Donor body) {
		String accept = request.getHeader("Accept");
		if (accept != null) {
			try {
				// Get existing user with provided id
				if (userService.getUserById(body.getId()).isEmpty()) {
					log.error("User with provided Id not found {}", body.getId());
					return new ResponseEntity<>(HttpStatus.NOT_FOUND);
				}

				// This assumes we have a User already built to create a donor. This is
				// required because the user id is
				// a foreign key and a primary key for the Donor.
				body.setUser(userService.getUserById(body.getId()).get());

				// The UI may send us an id or nothing, BUT we need to guarantee the id to
				// be null
				// so it can be set by the database from the provided user appropriately.
				body.setId(null);

				Donor newDonor = donorService.saveDonor(body);
				return new ResponseEntity<>(newDonor, HttpStatus.CREATED);
			}
			catch (RuntimeException e) {
				log.error("Couldn't serialize response for content type application/json", e);
				return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}

		return new ResponseEntity<>(HttpStatus.NOT_IMPLEMENTED);
	}

	public ResponseEntity<Void> deleteDonor(
			@Parameter(in = ParameterIn.PATH, description = "Donor id to delete", required = true,
					schema = @Schema()) @PathVariable("donorId") Long donorId,
			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
					required = true,
					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			@Parameter(in = ParameterIn.HEADER, description = "", schema = @Schema()) @RequestHeader(value = "api_key",
					required = false) String apiKey) {
		String accept = request.getHeader("Accept");
		return new ResponseEntity<Void>(HttpStatus.NOT_IMPLEMENTED);
	}

	public ResponseEntity<Donor> getDonorById(
			@Parameter(in = ParameterIn.PATH, description = "ID of donor to return", required = true,
					schema = @Schema()) @PathVariable("donorId") Long donorId,
			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
					required = true,
					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId) {
		String accept = request.getHeader("Accept");
		if (accept != null) {
			try {
				return new ResponseEntity<Donor>(objectMapper.readValue(
						"{\n  \"cognito_id\" : \"oijwedf-wrefwefr-saedf3rweg-gv\",\n  \"nickname\" : \"PotatoKing\",\n  \"id\" : 10,\n  \"last_quiz_text\" : \"I like tomatoes.\",\n  \"email\" : \"testUser\",\n  \"username\" : \"testUser\",\n  \"tags\" : [ {\n    \"tag_name\" : \"Potato\"\n  }, {\n    \"tag_name\" : \"Potato\"\n  } ]\n}",
						Donor.class), HttpStatus.NOT_IMPLEMENTED);
			}
			catch (IOException e) {
				log.error("Couldn't serialize response for content type application/json", e);
				return new ResponseEntity<Donor>(HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}

		return new ResponseEntity<Donor>(HttpStatus.NOT_IMPLEMENTED);
	}

	public ResponseEntity<Donor> updateDonor(
			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
					required = true,
					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			@Parameter(in = ParameterIn.DEFAULT, description = "Update an existent donor in the store", required = true,
					schema = @Schema()) @Valid @RequestBody Donor body) {
		String accept = request.getHeader("Accept");
		if (accept != null) {
			try {
				return new ResponseEntity<Donor>(objectMapper.readValue(
						"{\n  \"income_verified\" : true,\n  \"cognito_id\" : \"oijwedf-wrefwefr-saedf3rweg-gv\",\n  \"amount_received\" : 300.15,\n  \"nickname\" : \"PotatoKing\",\n  \"id\" : 10,\n  \"last_profile_text\" : \"I like potatoes.\",\n  \"email\" : \"testUser\",\n  \"username\" : \"testUser\",\n  \"tags\" : [ {\n    \"tag_name\" : \"Potato\"\n  }, {\n    \"tag_name\" : \"Potato\"\n  } ]\n}",
						Donor.class), HttpStatus.NOT_IMPLEMENTED);
			}
			catch (IOException e) {
				log.error("Couldn't serialize response for content type application/json", e);
				return new ResponseEntity<Donor>(HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}

		return new ResponseEntity<Donor>(HttpStatus.NOT_IMPLEMENTED);
	}

	public ResponseEntity<Void> updateDonorTags(
			@Parameter(in = ParameterIn.PATH, description = "Donor id to generate tags for", required = true,
					schema = @Schema()) @PathVariable("donorId") Long donorId,
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

	public ResponseEntity<Void> updateDonorWithForm(
			@Parameter(in = ParameterIn.PATH, description = "ID of donor that needs to be updated", required = true,
					schema = @Schema()) @PathVariable("donorId") Long donorId,
			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
					required = true,
					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			@Parameter(in = ParameterIn.QUERY, description = "Name of donor that needs to be updated",
					schema = @Schema()) @Valid @RequestParam(value = "name", required = false) String name,
			@Parameter(in = ParameterIn.QUERY, description = "Status of donor that needs to be updated",
					schema = @Schema()) @Valid @RequestParam(value = "status", required = false) String status) {
		String accept = request.getHeader("Accept");
		return new ResponseEntity<Void>(HttpStatus.NOT_IMPLEMENTED);
	}

}

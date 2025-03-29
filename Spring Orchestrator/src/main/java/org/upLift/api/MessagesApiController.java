package org.upLift.api;

import org.upLift.model.Message;
import org.upLift.model.MessageSearchInput;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.media.Schema;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;

import jakarta.validation.Valid;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@jakarta.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen",
		date = "2025-03-16T14:18:35.909799305Z[GMT]")
@RestController
public class MessagesApiController implements MessagesApi {

	private static final Logger log = LoggerFactory.getLogger(MessagesApiController.class);

	private final ObjectMapper objectMapper;

	private final HttpServletRequest request;

	@org.springframework.beans.factory.annotation.Autowired
	public MessagesApiController(ObjectMapper objectMapper, HttpServletRequest request) {
		this.objectMapper = objectMapper;
		this.request = request;
	}

	public ResponseEntity<List<Message>> messagesGet(@Parameter(in = ParameterIn.HEADER,
			description = "Tracks the session for the given set of requests.", required = true,
			schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId) {
		String accept = request.getHeader("Accept");
		if (accept != null) {
			try {
				return new ResponseEntity<List<Message>>(objectMapper.readValue(
						"[ {\n  \"created_at\" : \"2024-03-15T10:00:00Z\",\n  \"id\" : 1,\n  \"donor_id\" : 101,\n  \"message\" : \"Hello, how can I help?\",\n  \"recipient_id\" : 202\n}, {\n  \"created_at\" : \"2024-03-15T10:00:00Z\",\n  \"id\" : 1,\n  \"donor_id\" : 101,\n  \"message\" : \"Hello, how can I help?\",\n  \"recipient_id\" : 202\n} ]",
						List.class), HttpStatus.NOT_IMPLEMENTED);
			}
			catch (IOException e) {
				log.error("Couldn't serialize response for content type application/json", e);
				return new ResponseEntity<List<Message>>(HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}

		return new ResponseEntity<List<Message>>(HttpStatus.NOT_IMPLEMENTED);
	}

	public ResponseEntity<Message> messagesIdGet(
			@Parameter(in = ParameterIn.PATH, description = "", required = true,
					schema = @Schema()) @PathVariable("id") Integer id,
			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
					required = true,
					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId) {
		String accept = request.getHeader("Accept");
		if (accept != null) {
			try {
				return new ResponseEntity<Message>(objectMapper.readValue(
						"{\n  \"created_at\" : \"2024-03-15T10:00:00Z\",\n  \"id\" : 1,\n  \"donor_id\" : 101,\n  \"message\" : \"Hello, how can I help?\",\n  \"recipient_id\" : 202\n}",
						Message.class), HttpStatus.NOT_IMPLEMENTED);
			}
			catch (IOException e) {
				log.error("Couldn't serialize response for content type application/json", e);
				return new ResponseEntity<Message>(HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}

		return new ResponseEntity<Message>(HttpStatus.NOT_IMPLEMENTED);
	}

	public ResponseEntity<Message> messagesPost(
			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
					required = true,
					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			@Parameter(in = ParameterIn.DEFAULT, description = "", required = true,
					schema = @Schema()) @Valid @RequestBody Message body) {
		String accept = request.getHeader("Accept");
		if (accept != null) {
			try {
				return new ResponseEntity<Message>(objectMapper.readValue(
						"{\n  \"created_at\" : \"2024-03-15T10:00:00Z\",\n  \"id\" : 1,\n  \"donor_id\" : 101,\n  \"message\" : \"Hello, how can I help?\",\n  \"recipient_id\" : 202\n}",
						Message.class), HttpStatus.NOT_IMPLEMENTED);
			}
			catch (IOException e) {
				log.error("Couldn't serialize response for content type application/json", e);
				return new ResponseEntity<Message>(HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}

		return new ResponseEntity<Message>(HttpStatus.NOT_IMPLEMENTED);
	}

	public ResponseEntity<List<Message>> messagesSearchPost(
			@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests.",
					required = true,
					schema = @Schema()) @RequestHeader(value = "session_id", required = true) String sessionId,
			@Parameter(in = ParameterIn.DEFAULT, description = "", required = true,
					schema = @Schema()) @Valid @RequestBody MessageSearchInput body) {
		String accept = request.getHeader("Accept");
		if (accept != null) {
			try {
				return new ResponseEntity<List<Message>>(objectMapper.readValue(
						"[ {\n  \"created_at\" : \"2024-03-15T10:00:00Z\",\n  \"id\" : 1,\n  \"donor_id\" : 101,\n  \"message\" : \"Hello, how can I help?\",\n  \"recipient_id\" : 202\n}, {\n  \"created_at\" : \"2024-03-15T10:00:00Z\",\n  \"id\" : 1,\n  \"donor_id\" : 101,\n  \"message\" : \"Hello, how can I help?\",\n  \"recipient_id\" : 202\n} ]",
						List.class), HttpStatus.NOT_IMPLEMENTED);
			}
			catch (IOException e) {
				log.error("Couldn't serialize response for content type application/json", e);
				return new ResponseEntity<List<Message>>(HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}

		return new ResponseEntity<List<Message>>(HttpStatus.NOT_IMPLEMENTED);
	}

}

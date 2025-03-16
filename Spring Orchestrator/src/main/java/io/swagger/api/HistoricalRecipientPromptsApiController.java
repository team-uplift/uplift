package io.swagger.api;

import io.swagger.model.HistoricalRecipientPrompt;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.Valid;
import javax.validation.constraints.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@javax.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen", date = "2025-03-16T14:18:35.909799305Z[GMT]")
@RestController
public class HistoricalRecipientPromptsApiController implements HistoricalRecipientPromptsApi {

    private static final Logger log = LoggerFactory.getLogger(HistoricalRecipientPromptsApiController.class);

    private final ObjectMapper objectMapper;

    private final HttpServletRequest request;

    @org.springframework.beans.factory.annotation.Autowired
    public HistoricalRecipientPromptsApiController(ObjectMapper objectMapper, HttpServletRequest request) {
        this.objectMapper = objectMapper;
        this.request = request;
    }

    public ResponseEntity<List<HistoricalRecipientPrompt>> historicalRecipientPromptsGet(@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests." ,required=true,schema=@Schema()) @RequestHeader(value="session_id", required=true) String sessionId
) {
        String accept = request.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            try {
                return new ResponseEntity<List<HistoricalRecipientPrompt>>(objectMapper.readValue("[ {\n  \"created_at\" : \"2024-03-15T10:00:00Z\",\n  \"id\" : 1,\n  \"prompt\" : \"Requesting food assistance\",\n  \"recipient_id\" : 202\n}, {\n  \"created_at\" : \"2024-03-15T10:00:00Z\",\n  \"id\" : 1,\n  \"prompt\" : \"Requesting food assistance\",\n  \"recipient_id\" : 202\n} ]", List.class), HttpStatus.NOT_IMPLEMENTED);
            } catch (IOException e) {
                log.error("Couldn't serialize response for content type application/json", e);
                return new ResponseEntity<List<HistoricalRecipientPrompt>>(HttpStatus.INTERNAL_SERVER_ERROR);
            }
        }

        return new ResponseEntity<List<HistoricalRecipientPrompt>>(HttpStatus.NOT_IMPLEMENTED);
    }

    public ResponseEntity<HistoricalRecipientPrompt> historicalRecipientPromptsPost(@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests." ,required=true,schema=@Schema()) @RequestHeader(value="session_id", required=true) String sessionId
,@Parameter(in = ParameterIn.DEFAULT, description = "", required=true, schema=@Schema()) @Valid @RequestBody HistoricalRecipientPrompt body
) {
        String accept = request.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            try {
                return new ResponseEntity<HistoricalRecipientPrompt>(objectMapper.readValue("{\n  \"created_at\" : \"2024-03-15T10:00:00Z\",\n  \"id\" : 1,\n  \"prompt\" : \"Requesting food assistance\",\n  \"recipient_id\" : 202\n}", HistoricalRecipientPrompt.class), HttpStatus.NOT_IMPLEMENTED);
            } catch (IOException e) {
                log.error("Couldn't serialize response for content type application/json", e);
                return new ResponseEntity<HistoricalRecipientPrompt>(HttpStatus.INTERNAL_SERVER_ERROR);
            }
        }

        return new ResponseEntity<HistoricalRecipientPrompt>(HttpStatus.NOT_IMPLEMENTED);
    }

    public ResponseEntity<List<HistoricalRecipientPrompt>> historicalRecipientPromptsRecipientIdGet(@Parameter(in = ParameterIn.PATH, description = "", required=true, schema=@Schema()) @PathVariable("recipient_id") Integer recipientId
,@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests." ,required=true,schema=@Schema()) @RequestHeader(value="session_id", required=true) String sessionId
) {
        String accept = request.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            try {
                return new ResponseEntity<List<HistoricalRecipientPrompt>>(objectMapper.readValue("[ {\n  \"created_at\" : \"2024-03-15T10:00:00Z\",\n  \"id\" : 1,\n  \"prompt\" : \"Requesting food assistance\",\n  \"recipient_id\" : 202\n}, {\n  \"created_at\" : \"2024-03-15T10:00:00Z\",\n  \"id\" : 1,\n  \"prompt\" : \"Requesting food assistance\",\n  \"recipient_id\" : 202\n} ]", List.class), HttpStatus.NOT_IMPLEMENTED);
            } catch (IOException e) {
                log.error("Couldn't serialize response for content type application/json", e);
                return new ResponseEntity<List<HistoricalRecipientPrompt>>(HttpStatus.INTERNAL_SERVER_ERROR);
            }
        }

        return new ResponseEntity<List<HistoricalRecipientPrompt>>(HttpStatus.NOT_IMPLEMENTED);
    }

}

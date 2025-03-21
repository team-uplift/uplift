package org.upLift.api;

import org.upLift.model.HistoricalDonorPrompt;
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

import javax.validation.Valid;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@javax.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen", date = "2025-03-16T14:18:35.909799305Z[GMT]")
@RestController
public class HistoricalDonorPromptsApiController implements HistoricalDonorPromptsApi {

    private static final Logger log = LoggerFactory.getLogger(HistoricalDonorPromptsApiController.class);

    private final ObjectMapper objectMapper;

    private final HttpServletRequest request;

    @org.springframework.beans.factory.annotation.Autowired
    public HistoricalDonorPromptsApiController(ObjectMapper objectMapper, HttpServletRequest request) {
        this.objectMapper = objectMapper;
        this.request = request;
    }

    public ResponseEntity<List<HistoricalDonorPrompt>> historicalDonorPromptsDonorIdGet(@Parameter(in = ParameterIn.PATH, description = "", required=true, schema=@Schema()) @PathVariable("donor_id") Integer donorId
,@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests." ,required=true,schema=@Schema()) @RequestHeader(value="session_id", required=true) String sessionId
) {
        String accept = request.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            try {
                return new ResponseEntity<List<HistoricalDonorPrompt>>(objectMapper.readValue("[ {\n  \"created_at\" : \"2024-03-15T10:00:00Z\",\n  \"id\" : 1,\n  \"donor_id\" : 101,\n  \"prompt\" : \"Willing to donate clothes\"\n}, {\n  \"created_at\" : \"2024-03-15T10:00:00Z\",\n  \"id\" : 1,\n  \"donor_id\" : 101,\n  \"prompt\" : \"Willing to donate clothes\"\n} ]", List.class), HttpStatus.NOT_IMPLEMENTED);
            } catch (IOException e) {
                log.error("Couldn't serialize response for content type application/json", e);
                return new ResponseEntity<List<HistoricalDonorPrompt>>(HttpStatus.INTERNAL_SERVER_ERROR);
            }
        }

        return new ResponseEntity<List<HistoricalDonorPrompt>>(HttpStatus.NOT_IMPLEMENTED);
    }

    public ResponseEntity<List<HistoricalDonorPrompt>> historicalDonorPromptsGet(@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests." ,required=true,schema=@Schema()) @RequestHeader(value="session_id", required=true) String sessionId
) {
        String accept = request.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            try {
                return new ResponseEntity<List<HistoricalDonorPrompt>>(objectMapper.readValue("[ {\n  \"created_at\" : \"2024-03-15T10:00:00Z\",\n  \"id\" : 1,\n  \"donor_id\" : 101,\n  \"prompt\" : \"Willing to donate clothes\"\n}, {\n  \"created_at\" : \"2024-03-15T10:00:00Z\",\n  \"id\" : 1,\n  \"donor_id\" : 101,\n  \"prompt\" : \"Willing to donate clothes\"\n} ]", List.class), HttpStatus.NOT_IMPLEMENTED);
            } catch (IOException e) {
                log.error("Couldn't serialize response for content type application/json", e);
                return new ResponseEntity<List<HistoricalDonorPrompt>>(HttpStatus.INTERNAL_SERVER_ERROR);
            }
        }

        return new ResponseEntity<List<HistoricalDonorPrompt>>(HttpStatus.NOT_IMPLEMENTED);
    }

    public ResponseEntity<HistoricalDonorPrompt> historicalDonorPromptsPost(@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests." ,required=true,schema=@Schema()) @RequestHeader(value="session_id", required=true) String sessionId
,@Parameter(in = ParameterIn.DEFAULT, description = "", required=true, schema=@Schema()) @Valid @RequestBody HistoricalDonorPrompt body
) {
        String accept = request.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            try {
                return new ResponseEntity<HistoricalDonorPrompt>(objectMapper.readValue("{\n  \"created_at\" : \"2024-03-15T10:00:00Z\",\n  \"id\" : 1,\n  \"donor_id\" : 101,\n  \"prompt\" : \"Willing to donate clothes\"\n}", HistoricalDonorPrompt.class), HttpStatus.NOT_IMPLEMENTED);
            } catch (IOException e) {
                log.error("Couldn't serialize response for content type application/json", e);
                return new ResponseEntity<HistoricalDonorPrompt>(HttpStatus.INTERNAL_SERVER_ERROR);
            }
        }

        return new ResponseEntity<HistoricalDonorPrompt>(HttpStatus.NOT_IMPLEMENTED);
    }

}

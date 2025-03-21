package org.upLift.api;

import org.upLift.model.Donation;
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

@jakarta.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen", date = "2025-03-16T14:18:35.909799305Z[GMT]")
@RestController
public class DonationsApiController implements DonationsApi {

    private static final Logger log = LoggerFactory.getLogger(DonationsApiController.class);

    private final ObjectMapper objectMapper;

    private final HttpServletRequest request;

    @org.springframework.beans.factory.annotation.Autowired
    public DonationsApiController(ObjectMapper objectMapper, HttpServletRequest request) {
        this.objectMapper = objectMapper;
        this.request = request;
    }

    public ResponseEntity<List<Donation>> donationsGet(@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests." ,required=true,schema=@Schema()) @RequestHeader(value="session_id", required=true) String sessionId
) {
        String accept = request.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            try {
                return new ResponseEntity<List<Donation>>(objectMapper.readValue("[ {\n  \"amount\" : 500,\n  \"id\" : 1,\n  \"donor_id\" : 101,\n  \"recipient_id\" : 202\n}, {\n  \"amount\" : 500,\n  \"id\" : 1,\n  \"donor_id\" : 101,\n  \"recipient_id\" : 202\n} ]", List.class), HttpStatus.NOT_IMPLEMENTED);
            } catch (IOException e) {
                log.error("Couldn't serialize response for content type application/json", e);
                return new ResponseEntity<List<Donation>>(HttpStatus.INTERNAL_SERVER_ERROR);
            }
        }

        return new ResponseEntity<List<Donation>>(HttpStatus.NOT_IMPLEMENTED);
    }

    public ResponseEntity<Donation> donationsIdGet(@Parameter(in = ParameterIn.PATH, description = "", required=true, schema=@Schema()) @PathVariable("id") Integer id
,@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests." ,required=true,schema=@Schema()) @RequestHeader(value="session_id", required=true) String sessionId
) {
        String accept = request.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            try {
                return new ResponseEntity<Donation>(objectMapper.readValue("{\n  \"amount\" : 500,\n  \"id\" : 1,\n  \"donor_id\" : 101,\n  \"recipient_id\" : 202\n}", Donation.class), HttpStatus.NOT_IMPLEMENTED);
            } catch (IOException e) {
                log.error("Couldn't serialize response for content type application/json", e);
                return new ResponseEntity<Donation>(HttpStatus.INTERNAL_SERVER_ERROR);
            }
        }

        return new ResponseEntity<Donation>(HttpStatus.NOT_IMPLEMENTED);
    }

    public ResponseEntity<Donation> donationsPost(@Parameter(in = ParameterIn.HEADER, description = "Tracks the session for the given set of requests." ,required=true,schema=@Schema()) @RequestHeader(value="session_id", required=true) String sessionId
,@Parameter(in = ParameterIn.DEFAULT, description = "", required=true, schema=@Schema()) @Valid @RequestBody Donation body
) {
        String accept = request.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            try {
                return new ResponseEntity<Donation>(objectMapper.readValue("{\n  \"amount\" : 500,\n  \"id\" : 1,\n  \"donor_id\" : 101,\n  \"recipient_id\" : 202\n}", Donation.class), HttpStatus.NOT_IMPLEMENTED);
            } catch (IOException e) {
                log.error("Couldn't serialize response for content type application/json", e);
                return new ResponseEntity<Donation>(HttpStatus.INTERNAL_SERVER_ERROR);
            }
        }

        return new ResponseEntity<Donation>(HttpStatus.NOT_IMPLEMENTED);
    }

}

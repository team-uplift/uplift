package org.upLift.api;

import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.upLift.exceptions.ModelException;
import org.upLift.exceptions.TimingException;
import org.upLift.model.FormQuestion;
import org.upLift.model.Recipient;
import org.upLift.model.RecipientTag;
import org.upLift.model.Tag;
import org.upLift.services.RecipientService;
import org.upLift.services.TextractService;
import org.upLift.services.UserService;
import software.amazon.awssdk.core.SdkBytes;

import java.io.IOException;
import java.util.List;
import java.util.Set;

@jakarta.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen",
		date = "2025-03-16T14:18:35.909799305Z[GMT]")
@RestController
public class RecipientsApiController implements RecipientsApi {

	private static final Logger LOG = LoggerFactory.getLogger(RecipientsApiController.class);

	private static final int DEFAULT_NUMBER_OF_TAGS = 15;

	private final RecipientService recipientService;

	private final TextractService textractService;

	private final UserService userService;

	@Autowired
	public RecipientsApiController(RecipientService recipientService, TextractService textractService, UserService userService) {
		this.recipientService = recipientService;
        this.textractService = textractService;
        this.userService = userService;
	}

	public ResponseEntity<List<Tag>> getRandomSelectedTags(
			@RequestParam(value = "quantity", required = false) Integer quantity) {
		LOG.info("Returning {} random selected tags", quantity);
		int numberOfTags = quantity != null ? quantity : DEFAULT_NUMBER_OF_TAGS;
		return new ResponseEntity<>(recipientService.getRandomSelectedTags(numberOfTags), HttpStatus.OK);
	}

	@Override
	public ResponseEntity<List<Recipient>> findRecipientsByTags(
			@Valid @RequestParam(value = "tag", required = false) List<String> tags) {
		LOG.info("Finding recipients that match selected tags");
		LOG.debug("Tags used to match: {}", tags);
		return new ResponseEntity<>(recipientService.getMatchingRecipientsByTags(tags), HttpStatus.OK);
	}

	@Override
	public ResponseEntity<List<RecipientTag>> updateRecipientTags(@PathVariable("recipientId") Integer recipientId,
																  @Valid @RequestBody List<FormQuestion> formQuestions) {
		LOG.info("Updating recipient tags for recipient {}", recipientId);
		try {
			List<RecipientTag> generatedTags = recipientService.generateRecipientTags(recipientId, formQuestions);
			return new ResponseEntity<>(generatedTags, HttpStatus.CREATED);
		} catch (TimingException e) {
			LOG.warn(e.getMessage());
			return new ResponseEntity<>(HttpStatus.TOO_EARLY);
		} catch (ModelException e) {
			LOG.error(e.getMessage());
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}

	@Override
	public ResponseEntity<Void> updateSelectedRecipientTags(@PathVariable("recipientId") Integer recipientId,
															@Valid @RequestBody Set<String> selectedTags) {
		LOG.info("Updating selected tags for recipient {}", recipientId);
		LOG.debug("SelectedTags: {}", selectedTags);
		try {
			recipientService.updateSelectedTags(recipientId, selectedTags);
			return new ResponseEntity<>(HttpStatus.NO_CONTENT);
		} catch (ModelException e) {
			LOG.error(e.getMessage());
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}

	@Override
	public ResponseEntity<Boolean> verifyRecipientIncome(Integer recipientId, MultipartFile file) {
		try {
			// Get the file's bytes from the uploaded MultipartFile
			byte[] bytes = file.getBytes();

			Boolean isValidated = textractService.validateRecipientIncome(SdkBytes.fromByteArray(bytes), recipientId);

			return new ResponseEntity<>(isValidated, HttpStatus.OK);
		} catch (IOException e) {
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}

	}
}

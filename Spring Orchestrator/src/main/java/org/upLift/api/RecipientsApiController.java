package org.upLift.api;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.upLift.exceptions.EntityNotFoundException;
import org.upLift.exceptions.ModelException;
import org.upLift.exceptions.TimingException;
import org.upLift.model.FormQuestion;
import org.upLift.model.Recipient;
import org.upLift.model.RecipientTag;
import org.upLift.model.Tag;
import org.upLift.services.RecipientService;
import org.upLift.services.TextractService;
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

	@Autowired
	public RecipientsApiController(RecipientService recipientService, TextractService textractService) {
		this.recipientService = recipientService;
		this.textractService = textractService;
	}

	public ResponseEntity<List<Tag>> getRandomSelectedTags(Integer quantity) {
		int numberOfTags = quantity != null ? quantity : DEFAULT_NUMBER_OF_TAGS;
		LOG.info("Returning {} random selected tags", quantity);
		return new ResponseEntity<>(recipientService.getRandomSelectedTags(numberOfTags), HttpStatus.OK);
	}

	@Override
	public ResponseEntity<List<Recipient>> findRecipientsByTags(List<String> tags) {
		LOG.info("Finding recipients that match selected tags");
		LOG.debug("Tags used to match: {}", tags);
		return new ResponseEntity<>(recipientService.getMatchingRecipientsByTags(tags), HttpStatus.OK);
	}

	@Override
	public ResponseEntity<List<RecipientTag>> updateRecipientTags(Integer recipientId,
			List<FormQuestion> formQuestions) {
		LOG.info("Updating recipient tags for recipient {}", recipientId);
		try {
			List<RecipientTag> generatedTags = recipientService.generateRecipientTags(recipientId, formQuestions);
			return new ResponseEntity<>(generatedTags, HttpStatus.CREATED);
		}
		catch (TimingException e) {
			LOG.warn(e.getMessage());
			return new ResponseEntity<>(HttpStatus.TOO_EARLY);
		}
		catch (ModelException e) {
			LOG.error(e.getMessage());
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}

	@Override
	public void updateSelectedRecipientTags(Integer recipientId, Set<String> selectedTags) {
		LOG.info("Updating selected tags for recipient {}", recipientId);
		LOG.debug("SelectedTags: {}", selectedTags);
		recipientService.updateSelectedTags(recipientId, selectedTags);
	}

	@Override
	public ResponseEntity<Boolean> verifyRecipientIncome(Integer recipientId, MultipartFile file) {
		LOG.info("Verifying income for recipient {}", recipientId);
		if (recipientService.existsById(recipientId)) {
			try {
				// Get the file's bytes from the uploaded MultipartFile
				byte[] bytes = file.getBytes();
				Boolean isValidated = textractService.validateRecipientIncome(SdkBytes.fromByteArray(bytes),
						recipientId);

				return new ResponseEntity<>(isValidated, HttpStatus.OK);
			}
			catch (IOException e) {
				LOG.error("Error verifying income for recipient {}", recipientId, e);
				return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}
		else {
			throw new EntityNotFoundException(recipientId, "Recipient", "Recipient not found, can't verify income");
		}

	}

	@Override
	public ResponseEntity<List<Recipient>> getMatchedRecipient(List<FormQuestion> formQuestions) {
		return new ResponseEntity<>(recipientService.getMatchingRecipientsByDonorPrompt(formQuestions), HttpStatus.OK);
	}

}

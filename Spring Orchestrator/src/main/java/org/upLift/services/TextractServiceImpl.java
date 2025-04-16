package org.upLift.services;

import org.springframework.stereotype.Service;
import org.upLift.model.Recipient;
import software.amazon.awssdk.core.SdkBytes;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.textract.TextractClient;
import software.amazon.awssdk.services.textract.model.DetectDocumentTextRequest;
import software.amazon.awssdk.services.textract.model.DetectDocumentTextResponse;
import software.amazon.awssdk.services.textract.model.Document;
import software.amazon.awssdk.services.textract.model.Block;

import java.time.Instant;
import java.util.List;

@Service
public class TextractServiceImpl implements TextractService {

	private final RecipientService recipientService;

	TextractServiceImpl(RecipientService recipientService) {
		this.recipientService = recipientService;
	}

	public Boolean validateRecipientIncome(SdkBytes imageBytes, Integer recipientId) {
		Region region = Region.US_EAST_1;
		TextractClient textractClient = TextractClient.builder().region(region).build();

		// Get the input Document object as bytes.
		Document myDoc = Document.builder().bytes(imageBytes).build();

		DetectDocumentTextRequest detectDocumentTextRequest = DetectDocumentTextRequest.builder()
			.document(myDoc)
			.build();

		// Invoke the Detect operation.
		DetectDocumentTextResponse textResponse = textractClient.detectDocumentText(detectDocumentTextRequest);
		List<Block> docInfo = textResponse.blocks();
		boolean isIncomeFound = false;
		boolean isBox15Found = false;
		String income = "";

		for (Block block : docInfo) {

			if (block.text() != null) {
				if (isIncomeFound && isBox15Found) {
					income = block.text();
					break;
				}

				if (block.text().equals("income")) {
					isIncomeFound = true;
					continue;
				}

				if (block.text().equals("15") && isIncomeFound) {
					isBox15Found = true;
					continue;
				}
				else if (isIncomeFound) {
					isIncomeFound = false;
				}
			}
		}

		textractClient.close();

		if (Double.valueOf(income) < 30000.00) {
			// Update the recipient
			Recipient recipient = recipientService.getRecipientById(recipientId);

			recipient.setIncomeLastVerified(Instant.now());
			recipientService.saveRecipient(recipient);
			return true;
		}

		return false;
	}

}

/**
 * The TextractServiceImpl is responsible for automating the validation of a recipient’s reported income by leveraging
 * Amazon Textract’s OCR capabilities. When given an image (as SdkBytes) and a recipient ID, it spins up a Textract
 * client in the configured AWS region, submits the document for text detection, then scans the resulting text blocks
 * in search of the “income” label followed by box “15” to capture the numeric value. That extracted income is compared
 * against a configurable threshold (defaulting to $30,000), and—if it falls below the threshold—the service retrieves
 * the corresponding Recipient via the RecipientService, updates its incomeLastVerified timestamp, and persists the
 * change. This encapsulates the end-to-end flow of pulling a figure from an uploaded document and applying business
 * logic to mark a recipient’s income as verified.
 */
package org.upLift.services;

import org.springframework.beans.factory.annotation.Value;
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

	@Value("${uplift.income_threshold:30000.0}")
	private double income_threshold;

	@Value("${uplift.textract_region:us-east-1}")
	private String string_region;

	// Region cannot be null even during initialization so a default must be provided.
	private Region region = Region.US_EAST_1;

	private final RecipientService recipientService;

	TextractServiceImpl(RecipientService recipientService) {
		this.recipientService = recipientService;
	}

	public Boolean validateRecipientIncome(SdkBytes imageBytes, Integer recipientId) {
		region = Region.of(string_region);
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

		if (Double.valueOf(income) < income_threshold) {
			// Update the recipient
			Recipient recipient = recipientService.getRecipientById(recipientId);

			recipient.setIncomeLastVerified(Instant.now());
			recipientService.saveRecipient(recipient);
			return true;
		}

		return false;
	}

}

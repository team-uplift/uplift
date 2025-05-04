package org.upLift.services;

import org.upLift.model.Recipient;
import software.amazon.awssdk.core.SdkBytes;

/**
 * Service interface for interacting with AWS Textract to validate recipient income
 * documents.
 */
public interface TextractService {

	/**
	 * Validates the income of a recipient by analyzing the provided image of a document.
	 * @param imageBytes the image bytes of the document to be analyzed
	 * @param recipientId the ID of the recipient whose income is being validated
	 * @return {@code true} if the recipient's income is successfully validated,
	 * {@code false} otherwise
	 */
	public Boolean validateRecipientIncome(SdkBytes imageBytes, Integer recipientId);

}

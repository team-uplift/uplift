package org.upLift.services;

import org.upLift.model.Recipient;
import software.amazon.awssdk.core.SdkBytes;

public interface TextractService {

	public Boolean validateRecipientIncome(SdkBytes imageBytes, Integer recipientId);

}

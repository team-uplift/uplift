package org.upLift.services;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.MockedStatic;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;
import org.upLift.model.Recipient;
import software.amazon.awssdk.core.SdkBytes;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.textract.TextractClient;
import software.amazon.awssdk.services.textract.TextractClientBuilder;
import software.amazon.awssdk.services.textract.model.Block;
import software.amazon.awssdk.services.textract.model.DetectDocumentTextRequest;
import software.amazon.awssdk.services.textract.model.DetectDocumentTextResponse;

import java.time.Instant;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class TextractServiceImplTest {

	@BeforeEach
	public void init() {
		ReflectionTestUtils.setField(service, "income_threshold", 30000);
		ReflectionTestUtils.setField(service, "string_region", "us-east-1");
	}

	private final RecipientService recipientService = mock(RecipientService.class);

	@InjectMocks
	private final TextractServiceImpl service = new TextractServiceImpl(recipientService);

	@Test
	void validateRecipientIncome_whenIncomeUnderThreshold_updatesRecipientAndReturnsTrue() {
		// arrange
		SdkBytes imageBytes = SdkBytes.fromByteArray(new byte[] { 0x01, 0x02 });
		int recipientId = 42;
		Recipient recipient = new Recipient();
		recipient.setIncomeLastVerified(null);
		when(recipientService.getRecipientById(recipientId)).thenReturn(recipient);
		when(recipientService.saveRecipient(recipient)).thenReturn(recipient);

		// stub the static TextractClient.builder() chain
		try (MockedStatic<TextractClient> textractStatic = mockStatic(TextractClient.class)) {
			var builderMock = mock(TextractClientBuilder.class);
			var clientMock = mock(TextractClient.class);
			textractStatic.when(() -> TextractClient.builder()).thenReturn(builderMock);
			when(builderMock.region(Region.US_EAST_1)).thenReturn(builderMock);
			when(builderMock.build()).thenReturn(clientMock);

			// simulate AWS response: blocks ["income","15","25000"]
			Block bIncome = Block.builder().text("income").build();
			Block bBox15 = Block.builder().text("15").build();
			Block bValue = Block.builder().text("25000").build();
			DetectDocumentTextResponse awsResponse = DetectDocumentTextResponse.builder()
				.blocks(List.of(bIncome, bBox15, bValue))
				.build();

			when(clientMock.detectDocumentText(any(DetectDocumentTextRequest.class))).thenReturn(awsResponse);

			// act
			boolean result = service.validateRecipientIncome(imageBytes, recipientId);

			// assert
			assertTrue(result, "Should return true for income < 30000");
			// verify client was closed
			verify(clientMock).close();
			// verify recipient was fetched and saved
			verify(recipientService).getRecipientById(recipientId);
			verify(recipientService).saveRecipient(recipient);
			// incomeLastVerified should now be set
			assertNotNull(recipient.getIncomeLastVerified());
			assertTrue(recipient.getIncomeLastVerified().isBefore(Instant.now().plusSeconds(1)));
		}
	}

	@Test
	void validateRecipientIncome_whenIncomeAboveThreshold_returnsFalseAndDoesNotSave() {
		// arrange
		SdkBytes imageBytes = SdkBytes.fromByteArray(new byte[] {});
		int recipientId = 99;

		// stub the static TextractClient.builder() chain
		try (MockedStatic<TextractClient> textractStatic = mockStatic(TextractClient.class)) {
			var builderMock = mock(TextractClientBuilder.class);
			var clientMock = mock(TextractClient.class);
			textractStatic.when(() -> TextractClient.builder()).thenReturn(builderMock);
			when(builderMock.region(Region.US_EAST_1)).thenReturn(builderMock);
			when(builderMock.build()).thenReturn(clientMock);

			// simulate AWS response: blocks ["income","15","35000"]
			Block bIncome = Block.builder().text("income").build();
			Block bBox15 = Block.builder().text("15").build();
			Block bValue = Block.builder().text("35000").build();
			DetectDocumentTextResponse awsResponse = DetectDocumentTextResponse.builder()
				.blocks(List.of(bIncome, bBox15, bValue))
				.build();

			when(clientMock.detectDocumentText(any(DetectDocumentTextRequest.class))).thenReturn(awsResponse);

			// act
			boolean result = service.validateRecipientIncome(imageBytes, recipientId);

			// assert
			assertFalse(result, "Should return false for income >= 30000");
			// client.close should still be called
			verify(clientMock).close();
			// recipientService should not be invoked
			verify(recipientService, never()).getRecipientById(anyInt());
			verify(recipientService, never()).saveRecipient(any());
		}
	}

}

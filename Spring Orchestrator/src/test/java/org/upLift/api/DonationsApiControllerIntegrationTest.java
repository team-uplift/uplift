package org.upLift.api;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.upLift.model.Donation;

import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;

import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

// Tests largely built by JetBrains AI Assistant with some manual tweaks
class DonationsApiControllerIntegrationTest extends BaseControllerIntegrationTest {

	@Autowired
	private MockMvc mockMvc;

	@Autowired
	private ObjectMapper objectMapper;

	@Test
	void donationsIdGet() throws Exception {
		// Test getting existing donation
		var result = mockMvc.perform(get("/donations/1"))
			.andExpect(status().isOk())
			.andExpect(content().contentType(MediaType.APPLICATION_JSON))
			.andExpect(jsonPath("$.id", is(1)))
			.andExpect(jsonPath("$.donorId", is(3)))
			.andExpect(jsonPath("$.recipientId", is(1)))
			.andExpect(jsonPath("$.amount", is(50)))
			.andExpect(jsonPath("$.createdAt", is("2023-10-21T16:00:30.321Z")))
			// Check that donor data is loaded
			.andExpect(jsonPath("$.donor").exists())
			.andExpect(jsonPath("$.donor.id", is(3)))
			.andExpect(jsonPath("$.donor.nickname", is("KindDonor1")))
			.andExpect(jsonPath("$.donor.createdAt", is("2023-10-10T12:30:50.789Z")))
			// Check that private donor data isn't loaded
			.andExpect(jsonPath("$.donor.user").doesNotExist());
		checkPublicRecipientData(result, "$");

		// Test getting non-existent donation
		mockMvc.perform(get("/donations/999"))
			.andExpect(status().isNotFound())
			.andExpect(content().contentType(MediaType.APPLICATION_JSON))
			.andExpect(jsonPath("$.errorMessage", is("Donation not found")))
			.andExpect(jsonPath("$.status", is(404)))
			.andExpect(jsonPath("$.errorType", is("Not Found")))
			.andExpect(jsonPath("$.path", is("/donations/999")))
			.andExpect(jsonPath("$.notFoundEntityId", is(999)))
			.andExpect(jsonPath("$.notFoundEntityType", is("Donation")));
	}

	void checkPublicRecipientData(ResultActions actions, String prefix) throws Exception {
		// Check that recipient data is included
		checkRecipient1PublicData(actions, prefix);
		// Check that private properties are not included
		checkPrivateRecipientPropertiesNotPresent(actions, prefix);
	}

	@Test
	void donationsGetByDonor() throws Exception {
		// Test getting donations for existing donor
		var result = mockMvc.perform(get("/donations/donor/3"))
			.andExpect(status().isOk())
			.andExpect(content().contentType(MediaType.APPLICATION_JSON))
			.andExpect(jsonPath("$", hasSize(2)))
			// First donation - check donation properties - full public recipient data
			// will be checked below
			.andExpect(jsonPath("$[0].id", is(1)))
			.andExpect(jsonPath("$[0].amount", is(50)))
			.andExpect(jsonPath("$[0].createdAt", is("2023-10-21T16:00:30.321Z")))
			// Second donation - check public properties
			.andExpect(jsonPath("$[1].id", is(2)))
			.andExpect(jsonPath("$[1].amount", is(75)))
			.andExpect(jsonPath("$[1].createdAt", is("2023-10-22T17:05:40.654Z")))
			.andExpect(jsonPath("$[1].recipient.id", is(2)))
			.andExpect(jsonPath("$[1].recipient.nickname", is("Janie")))
			.andExpect(jsonPath("$[1].recipient.lastAboutMe", is("About Jane")))
			.andExpect(jsonPath("$[1].recipient.lastReasonForHelp", is("Reason 2")))
			.andExpect(jsonPath("$[1].recipient.tags", hasSize(5)))
			.andExpect(jsonPath("$[1].recipient.tags[?(@.tagName=='housing')].selected", hasItem(true)))
			.andExpect(jsonPath("$[1].recipient.tags[?(@.tagName=='utilities')].selected", hasItem(true)));
		checkPublicRecipientData(result, "$[0]");
		checkRecipient2PublicData(result, "$[1]");
		checkPrivateRecipientPropertiesNotPresent(result, "$[1]");

		// Test getting donations for non-existent donor
		mockMvc.perform(get("/donations/donor/999"))
			.andExpect(status().isNotFound())
			.andExpect(content().contentType(MediaType.APPLICATION_JSON))
			.andExpect(jsonPath("$.errorMessage", is("Donor not found")))
			.andExpect(jsonPath("$.status", is(404)))
			.andExpect(jsonPath("$.errorType", is("Not Found")))
			.andExpect(jsonPath("$.path", is("/donations/donor/999")))
			.andExpect(jsonPath("$.notFoundEntityId", is(999)))
			.andExpect(jsonPath("$.notFoundEntityType", is("Donor")));
	}

	@Test
	void donationsGetByRecipient() throws Exception {
		// Test getting donations for existing recipient
		mockMvc.perform(get("/donations/recipient/1"))
			.andExpect(status().isOk())
			.andExpect(content().contentType(MediaType.APPLICATION_JSON))
			.andExpect(jsonPath("$", hasSize(2)))
			// Check donation 1, public donor properties only
			.andExpect(jsonPath("$[0].id", is(1)))
			.andExpect(jsonPath("$[0].amount", is(50)))
			.andExpect(jsonPath("$[0].donor.id", is(3)))
			.andExpect(jsonPath("$[0].donor.nickname", is("KindDonor1")))
			.andExpect(jsonPath("$[0].donor.createdAt", is("2023-10-10T12:30:50.789Z")))
			.andExpect(jsonPath("$[0].donor.user").doesNotExist())
			.andExpect(jsonPath("$[1].id", is(3)))
			.andExpect(jsonPath("$[1].donor.id", is(4)))
			.andExpect(jsonPath("$[1].amount", is(100)))
			// Check that full recipient isn't included
			.andExpect(jsonPath("$[0].recipient").doesNotExist())
			.andExpect(jsonPath("$[1].recipient").doesNotExist());

		// Test getting donations for non-existent recipient
		mockMvc.perform(get("/donations/recipient/999"))
			.andExpect(status().isNotFound())
			.andExpect(content().contentType(MediaType.APPLICATION_JSON))
			.andExpect(jsonPath("$.errorMessage", is("Recipient not found")))
			.andExpect(jsonPath("$.status", is(404)))
			.andExpect(jsonPath("$.errorType", is("Not Found")))
			.andExpect(jsonPath("$.path", is("/donations/recipient/999")))
			.andExpect(jsonPath("$.notFoundEntityId", is(999)))
			.andExpect(jsonPath("$.notFoundEntityType", is("Recipient")));
	}

	@Test
	void donationsPost() throws Exception {
		// It's a little hokey, but we want to check that the last donation timestamp is
		// greater than "now", so create a String for "now" to use as comparison - because
		// the numbers are formatted with leading zeros, the String greater than check
		// should work correctly
		String timestampLimit = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
			.format(ZonedDateTime.now(ZoneOffset.UTC));

		// Create new donation
		Donation newDonation = new Donation().amount(5);
		newDonation.setDonorId(8);
		newDonation.setRecipientId(6);

		// Test posting valid donation
		var result = mockMvc
			.perform(post("/donations").contentType(MediaType.APPLICATION_JSON)
				.content(objectMapper.writeValueAsString(newDonation)))
			.andExpect(status().isCreated())
			.andExpect(content().contentType(MediaType.APPLICATION_JSON))
			.andExpect(jsonPath("$.donorId", is(8)))
			.andExpect(jsonPath("$.amount", is(5)))
			// Check that public recipient properties are present
			.andExpect(jsonPath("$.recipient.id", is(6)))
			.andExpect(jsonPath("$.recipient.nickname", is("Mike")))
			.andExpect(jsonPath("$.recipient.lastAboutMe", is("About Michael")))
			.andExpect(jsonPath("$.recipient.lastReasonForHelp", is("Seeking assistance")))
			.andExpect(jsonPath("$.recipient.imageUrl", is("http://example.com/image4.jpg")))
			.andExpect(jsonPath("$.recipient.lastDonationTimestamp").exists())
			.andExpect(jsonPath("$.recipient.lastDonationTimestamp", is(greaterThan(timestampLimit))))
			.andExpect(jsonPath("$.recipient.tags", hasSize(6)))
			.andExpect(jsonPath("$.recipient.tags[*].selected", contains(true, true, true, true, true, true)))
			.andExpect(jsonPath("$.recipient.tags[0].tagName", is("financial-planning")))
			.andExpect(jsonPath("$.recipient.tags[1].tagName", is("health")))
			.andExpect(jsonPath("$.recipient.tags[2].tagName", is("housing")))
			.andExpect(jsonPath("$.recipient.tags[3].tagName", is("job-training")))
			.andExpect(jsonPath("$.recipient.tags[4].tagName", is("transportation")))
			.andExpect(jsonPath("$.recipient.tags[5].tagName", is("utilities")));
		checkPrivateRecipientPropertiesNotPresent(result, "$");

		// Test posting donation with non-existent donor
		newDonation.setDonorId(999);
		mockMvc
			.perform(post("/donations").contentType(MediaType.APPLICATION_JSON)
				.content(objectMapper.writeValueAsString(newDonation)))
			.andExpect(status().isBadRequest());

		// Test posting donation with non-existent recipient
		newDonation.setDonorId(3);
		newDonation.setRecipientId(999);
		mockMvc
			.perform(post("/donations").contentType(MediaType.APPLICATION_JSON)
				.content(objectMapper.writeValueAsString(newDonation)))
			.andExpect(status().isBadRequest());
	}

}

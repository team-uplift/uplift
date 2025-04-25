package org.upLift.api;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.upLift.model.Donation;

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

	@Disabled
	@Test
	void donationsIdGet() throws Exception {
		// Test getting existing donation
		mockMvc.perform(get("/donations/1"))
			.andExpect(status().isOk())
			.andExpect(content().contentType(MediaType.APPLICATION_JSON))
			.andExpect(jsonPath("$.id", is(1)))
			.andExpect(jsonPath("$.donorId", is(3)))
			.andExpect(jsonPath("$.recipientId", is(1)))
			.andExpect(jsonPath("$.amount", is(50)))
			.andExpect(jsonPath("$.createdAt", is("2023-10-21T16:00:30.321Z")))
			.andExpect(jsonPath("$.donor.nickname", is("KindDonor1")));

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

	@Test
	void donationsGetByDonor() throws Exception {
		// Test getting donations for existing donor
		mockMvc.perform(get("/donations/donor/3"))
			.andExpect(status().isOk())
			.andExpect(content().contentType(MediaType.APPLICATION_JSON))
			.andExpect(jsonPath("$", hasSize(2)))
			// First donation - check public properties
			.andExpect(jsonPath("$[0].id", is(1)))
			.andExpect(jsonPath("$[0].amount", is(50)))
			.andExpect(jsonPath("$[0].createdAt", is("2023-10-21T16:00:30.321Z")))
			.andExpect(jsonPath("$[0].recipient.id", is(1)))
			.andExpect(jsonPath("$[0].recipient.nickname", is("Johnny")))
			.andExpect(jsonPath("$[0].recipient.lastAboutMe", is("About John")))
			.andExpect(jsonPath("$[0].recipient.lastReasonForHelp", is("Reason 1")))
			.andExpect(jsonPath("$[0].recipient.tags", hasSize(7)))
			.andExpect(jsonPath("$[0].recipient.tags[*].selected", contains(true, true, true, true, true, true, true)))
			.andExpect(jsonPath("$[0].recipient.tags[0].tagName", is("childcare")))
			.andExpect(jsonPath("$[0].recipient.tags[1].tagName", is("clothing")))
			.andExpect(jsonPath("$[0].recipient.tags[2].tagName", is("food")))
			.andExpect(jsonPath("$[0].recipient.tags[3].tagName", is("health")))
			.andExpect(jsonPath("$[0].recipient.tags[4].tagName", is("housing")))
			.andExpect(jsonPath("$[0].recipient.tags[5].tagName", is("mental-health")))
			.andExpect(jsonPath("$[0].recipient.tags[6].tagName", is("utilities")))
			// First donation - verify private properties are not included
			.andExpect(jsonPath("$[0].recipient.user").doesNotExist())
			.andExpect(jsonPath("$[0].recipient.firstName").doesNotExist())
			.andExpect(jsonPath("$[0].recipient.lastName").doesNotExist())
			.andExpect(jsonPath("$[0].recipient.streetAddress1").doesNotExist())
			.andExpect(jsonPath("$[0].recipient.streetAddress2").doesNotExist())
			.andExpect(jsonPath("$[0].recipient.city").doesNotExist())
			.andExpect(jsonPath("$[0].recipient.state").doesNotExist())
			.andExpect(jsonPath("$[0].recipient.zipCode").doesNotExist())
			.andExpect(jsonPath("$[0].recipient.identityLastVerified").doesNotExist())
			.andExpect(jsonPath("$[0].recipient.incomeLastVerified").doesNotExist())
			.andExpect(jsonPath("$[0].recipient.formQuestions").doesNotExist())
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
			.andExpect(jsonPath("$[1].amount", is(100)));

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
		// Create new donation
		Donation newDonation = new Donation().amount(5);
		newDonation.setDonorId(8);
		newDonation.setRecipientId(5);

		// Test posting valid donation
		mockMvc
			.perform(post("/donations").contentType(MediaType.APPLICATION_JSON)
				.content(objectMapper.writeValueAsString(newDonation)))
			.andExpect(status().isCreated())
			.andExpect(content().contentType(MediaType.APPLICATION_JSON))
			.andExpect(jsonPath("$.donorId", is(8)))
			.andExpect(jsonPath("$.amount", is(5)))
			// Check that public recipient properties are present
			.andExpect(jsonPath("$.recipient.id", is(5)))
			.andExpect(jsonPath("$.recipient.nickname", is("Sare")))
			.andExpect(jsonPath("$.recipient.lastAboutMe", is("About Sarah")))
			.andExpect(jsonPath("$.recipient.lastReasonForHelp", is("Reason 3")))
			.andExpect(jsonPath("$.recipient.tags", hasSize(5)))
			.andExpect(jsonPath("$.recipient.tags[*].selected", contains(true, true, true, true, true)))
			.andExpect(jsonPath("$.recipient.tags[0].tagName", is("childcare")))
			.andExpect(jsonPath("$.recipient.tags[1].tagName", is("food-banks")))
			.andExpect(jsonPath("$.recipient.tags[2].tagName", is("housing")))
			.andExpect(jsonPath("$.recipient.tags[3].tagName", is("job-training")))
			.andExpect(jsonPath("$.recipient.tags[4].tagName", is("mental-health")))
			// Check that private properties are not included
			.andExpect(jsonPath("$.recipient.user").doesNotExist())
			.andExpect(jsonPath("$.recipient.firstName").doesNotExist())
			.andExpect(jsonPath("$.recipient.lastName").doesNotExist())
			.andExpect(jsonPath("$.recipient.streetAddress1").doesNotExist())
			.andExpect(jsonPath("$.recipient.streetAddress2").doesNotExist())
			.andExpect(jsonPath("$.recipient.city").doesNotExist())
			.andExpect(jsonPath("$.recipient.state").doesNotExist())
			.andExpect(jsonPath("$.recipient.zipCode").doesNotExist())
			.andExpect(jsonPath("$.recipient.identityLastVerified").doesNotExist())
			.andExpect(jsonPath("$.recipient.incomeLastVerified").doesNotExist())
			.andExpect(jsonPath("$.recipient.formQuestions").doesNotExist());

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

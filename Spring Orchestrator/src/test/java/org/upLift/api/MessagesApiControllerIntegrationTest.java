package org.upLift.api;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.upLift.model.Message;
import org.upLift.repositories.MessageRepository;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

// Tests largely built by JetBrains AI Assistant with some manual tweaks
class MessagesApiControllerIntegrationTest extends BaseControllerIntegrationTest {

	@Autowired
	private MockMvc mockMvc;

	@Autowired
	private ObjectMapper objectMapper;

	@Autowired
	private MessageRepository messageRepository;

	@Test
	void messagesIdGet() throws Exception {
		// Test getting existing message
		mockMvc.perform(get("/messages/1"))
			.andExpect(status().isOk())
			.andExpect(content().contentType(MediaType.APPLICATION_JSON))
			.andExpect(jsonPath("$.id", is(1)))
			.andExpect(jsonPath("$.donationId", is(2)))
			.andExpect(jsonPath("$.message", is("Hope this helps!")))
			.andExpect(jsonPath("$.donorRead", is(true)))
			.andExpect(jsonPath("$.createdAt", is("2023-10-22T19:15:30.123Z")));

		// Test getting non-existent message
		mockMvc.perform(get("/messages/999"))
			.andExpect(status().isNotFound())
			.andExpect(content().contentType(MediaType.APPLICATION_JSON))
			.andExpect(jsonPath("$.errorMessage", is("Message not found")))
			.andExpect(jsonPath("$.status", is(404)))
			.andExpect(jsonPath("$.errorType", is("Not Found")))
			.andExpect(jsonPath("$.timestamp", not(emptyString())))
			.andExpect(jsonPath("$.path", is("/messages/999")))
			.andExpect(jsonPath("$.notFoundEntityId", is(999)))
			.andExpect(jsonPath("$.notFoundEntityType", is("Message")));
	}

	@Test
	void messagesGetByDonor() throws Exception {
		// Test getting messages for existing donor
		mockMvc.perform(get("/messages/donor/3"))
			.andExpect(status().isOk())
			.andExpect(content().contentType(MediaType.APPLICATION_JSON))
			.andExpect(jsonPath("$", hasSize(2)))
			.andExpect(jsonPath("$[0].id", is(2)))
			.andExpect(jsonPath("$[0].donationId", is(1)))
			.andExpect(jsonPath("$[0].message", is("Take care!")))
			.andExpect(jsonPath("$[0].donorRead", is(false)))
			.andExpect(jsonPath("$[1].id", is(1)))
			.andExpect(jsonPath("$[1].donationId", is(2)))
			.andExpect(jsonPath("$[1].message", is("Hope this helps!")))
			.andExpect(jsonPath("$[1].donorRead", is(true)));

		// Test getting messages for existing donor with no messages
		mockMvc.perform(get("/messages/donor/8"))
			.andExpect(status().isOk())
			.andExpect(content().contentType(MediaType.APPLICATION_JSON))
			.andExpect(jsonPath("$", hasSize(0)));

		// Test getting messages for non-existent donor
		mockMvc.perform(get("/messages/donor/999"))
			.andExpect(status().isNotFound())
			.andExpect(content().contentType(MediaType.APPLICATION_JSON))
			.andExpect(jsonPath("$.errorMessage", is("Donor not found")))
			.andExpect(jsonPath("$.status", is(404)))
			.andExpect(jsonPath("$.errorType", is("Not Found")))
			.andExpect(jsonPath("$.timestamp", not(emptyString())))
			.andExpect(jsonPath("$.path", is("/messages/donor/999")))
			.andExpect(jsonPath("$.notFoundEntityId", is(999)))
			.andExpect(jsonPath("$.notFoundEntityType", is("Donor")));
	}

	@Test
	void messagesPost() throws Exception {
		// Create new message
		Message newMessage = new Message().donationId(4).message("Thank you so much!");

		// Test posting valid message
		mockMvc
			.perform(post("/messages").contentType(MediaType.APPLICATION_JSON)
				.content(objectMapper.writeValueAsString(newMessage)))
			.andExpect(status().isCreated())
			.andExpect(content().contentType(MediaType.APPLICATION_JSON))
			.andExpect(jsonPath("$.id", is(4)))
			.andExpect(jsonPath("$.thankYouMessage.donationId", is(4)))
			.andExpect(jsonPath("$.thankYouMessage.message", is("Thank you so much!")))
			.andExpect(jsonPath("$.thankYouMessage.donorRead", is(false)))
			// Check donation properties are correct based on JSON view
			.andExpect(jsonPath("$.donorId", is(4)))
			.andExpect(jsonPath("$.recipientId", is(5)))
			.andExpect(jsonPath("$.amount", is(25)))
			.andExpect(jsonPath("$.createdAt", is("2023-10-25T09:48:57.023Z")))
			.andExpect(jsonPath("$.donor").exists())
			.andExpect(jsonPath("$.donor.id", is(4)))
			.andExpect(jsonPath("$.donor.nickname", is("HelpfulDonor2")))
			.andExpect(jsonPath("$.donor.createdAt", is("2023-10-15T13:35:00.321Z")))
			// Check recipient data not included
			.andExpect(jsonPath("$.recipient").doesNotExist());

		// Test posting message for non-existent donation
		newMessage.setDonationId(999);
		mockMvc
			.perform(post("/messages").contentType(MediaType.APPLICATION_JSON)
				.content(objectMapper.writeValueAsString(newMessage)))
			.andExpect(status().isNotFound())
			.andExpect(content().contentType(MediaType.APPLICATION_JSON))
			.andExpect(jsonPath("$.errorMessage", is("No donation found, can't send new message")))
			.andExpect(jsonPath("$.status", is(404)))
			.andExpect(jsonPath("$.errorType", is("Not Found")))
			.andExpect(jsonPath("$.timestamp", not(emptyString())))
			.andExpect(jsonPath("$.path", is("/messages")))
			.andExpect(jsonPath("$.notFoundEntityId", is(999)))
			.andExpect(jsonPath("$.notFoundEntityType", is("Donation")));

		// Test posting message for donation that already has a message
		newMessage.setDonationId(1);
		mockMvc
			.perform(post("/messages").contentType(MediaType.APPLICATION_JSON)
				.content(objectMapper.writeValueAsString(newMessage)))
			.andExpect(status().isBadRequest())
			.andExpect(content().contentType(MediaType.APPLICATION_JSON))
			.andExpect(
					jsonPath("$.errorMessage", is("Invalid request: thank you message already exists for donation 1")))
			.andExpect(jsonPath("$.status", is(400)))
			.andExpect(jsonPath("$.errorType", is("Bad Request")))
			.andExpect(jsonPath("$.timestamp", not(emptyString())))
			.andExpect(jsonPath("$.path", is("/messages")));
	}

	@Test
	void messagesMarkRead() throws Exception {
		// Check that message isn't yet marked read
		var messageOptional = messageRepository.findById(3);
		assertThat(messageOptional.isPresent(), is(true));
		assertThat(messageOptional.get().isDonorRead(), is(false));

		// Test marking existing message as read
		mockMvc.perform(put("/messages/read/3"))
			.andExpect(status().isOk())
			.andExpect(content().contentType(MediaType.APPLICATION_JSON))
			.andExpect(jsonPath("$.id", is(3)))
			.andExpect(jsonPath("$.donationId", is(3)))
			.andExpect(jsonPath("$.message", is("Wishing the best!")))
			.andExpect(jsonPath("$.donorRead", is(true)))
			.andExpect(jsonPath("$.createdAt", is("2023-10-24T21:25:50.789Z")));

		// Test marking non-existent message as read
		mockMvc.perform(put("/messages/read/999"))
			.andExpect(status().isNotFound())
			.andExpect(content().contentType(MediaType.APPLICATION_JSON))
			.andExpect(jsonPath("$.errorMessage", is("No message found, can't mark it sent")))
			.andExpect(jsonPath("$.status", is(404)))
			.andExpect(jsonPath("$.errorType", is("Not Found")))
			.andExpect(jsonPath("$.timestamp", not(emptyString())))
			.andExpect(jsonPath("$.path", is("/messages/read/999")))
			.andExpect(jsonPath("$.notFoundEntityId", is(999)))
			.andExpect(jsonPath("$.notFoundEntityType", is("Message")));
	}

}

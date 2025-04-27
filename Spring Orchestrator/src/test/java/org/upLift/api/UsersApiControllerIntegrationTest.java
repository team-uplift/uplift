package org.upLift.api;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.annotation.DirtiesContext;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.upLift.model.Donor;
import org.upLift.model.Recipient;
import org.upLift.model.User;

import java.time.LocalDate;

import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@DirtiesContext(classMode = DirtiesContext.ClassMode.AFTER_CLASS)
class UsersApiControllerIntegrationTest extends BaseControllerIntegrationTest {

	@Autowired
	private MockMvc mockMvc;

	@Autowired
	private ObjectMapper objectMapper;

	ResultActions checkUser1(ResultActions result, String prefix) throws Exception {
		// Income verification for this user is dynamically set to 90 days before "now",
		// so just check the date
		LocalDate incomeVerificationDate = LocalDate.now().minusDays(90);

		result.andExpect(jsonPath(prefix + ".id", is(1)))
			.andExpect(jsonPath(prefix + ".cognitoId", is("550e8400-e29b-41d4-a716-446655440000")))
			.andExpect(jsonPath(prefix + ".email", is("recipient1@example.com")))
			.andExpect(jsonPath(prefix + ".recipient", is(true)))
			.andExpect(jsonPath(prefix + ".createdAt", is("2023-10-01T10:20:30.123Z")))
			.andExpect(jsonPath(prefix + ".donorData").doesNotExist())
			// Check recipient private data is present
			.andExpect(jsonPath(prefix + ".recipientData.firstName", is("John")))
			.andExpect(jsonPath(prefix + ".recipientData.lastName", is("Doe")))
			.andExpect(jsonPath(prefix + ".recipientData.streetAddress1", is("123 Elm St")))
			.andExpect(jsonPath(prefix + ".recipientData.streetAddress2", is("")))
			.andExpect(jsonPath(prefix + ".recipientData.city", is("Springfield")))
			.andExpect(jsonPath(prefix + ".recipientData.state", is("IL")))
			.andExpect(jsonPath(prefix + ".recipientData.zipCode", is("62701")))
			.andExpect(jsonPath(prefix + ".recipientData.formQuestions", hasSize(2)))
			.andExpect(jsonPath(prefix + ".recipientData.formQuestions[0].question", is("question1")))
			.andExpect(jsonPath(prefix + ".recipientData.formQuestions[0].answer", is("Answer1")))
			.andExpect(jsonPath(prefix + ".recipientData.formQuestions[1].question", is("question2")))
			.andExpect(jsonPath(prefix + ".recipientData.formQuestions[1].answer", is("Answer2")))
			.andExpect(jsonPath(prefix + ".recipientData.identityLastVerified", is("2023-10-01T11:15:00.123Z")))
			.andExpect(jsonPath(prefix + ".recipientData.incomeLastVerified",
					startsWith(incomeVerificationDate.toString())))
			.andExpect(jsonPath(prefix + ".recipientData.tagsLastGenerated", is("2023-10-05T09:10:10.789Z")));
		checkRecipient1PublicData(result, prefix + ".recipientData");
		return result;
	}

	ResultActions checkUser3(ResultActions result, String prefix) throws Exception {
		result.andExpect(jsonPath(prefix + ".id", is(3)))
			.andExpect(jsonPath(prefix + ".cognitoId", is("550e8400-e29b-41d4-a716-446655440002")))
			.andExpect(jsonPath(prefix + ".email", is("donor1@example.com")))
			.andExpect(jsonPath(prefix + ".recipient", is(false)))
			.andExpect(jsonPath(prefix + ".createdAt", is("2023-10-10T12:30:50.789Z")))
			.andExpect(jsonPath(prefix + ".recipientData").doesNotExist());
		checkDonor1PublicData(result, prefix + ".donorData");
		return result;
	}

	@Test
	void getUserById_Recipient() throws Exception {
		var result = mockMvc.perform(get("/users/1").contentType(MediaType.APPLICATION_JSON))
			.andExpect(status().isOk());

		// Check user data
		checkUser1(result, "$");
	}

	@Test
	void getUserById_Donor() throws Exception {
		var result = mockMvc.perform(get("/users/3").contentType(MediaType.APPLICATION_JSON))
			.andExpect(status().isOk());
		checkUser3(result, "$");
	}

	@Test
	void getUserByCognitoId_Recipient() throws Exception {
		var result = mockMvc
			.perform(get("/users/cognito/550e8400-e29b-41d4-a716-446655440000").contentType(MediaType.APPLICATION_JSON))
			.andExpect(status().isOk())
			.andExpect(jsonPath("$.donor").doesNotExist());

		// Check user data
		checkUser1(result, "$");
	}

	@Test
	void getUserByCognitoId_Donor() throws Exception {
		var result = mockMvc
			.perform(get("/users/cognito/550e8400-e29b-41d4-a716-446655440002").contentType(MediaType.APPLICATION_JSON))
			.andExpect(status().isOk())
			.andExpect(jsonPath("$.donor").doesNotExist());

		// Check user data
		checkUser3(result, "$");
	}

	@Test
	void addUser() throws Exception {
		User newUser = new User().cognitoId("test-cognito-id").email("test@example.com").recipient(true);

		Recipient recipientData = new Recipient();
		recipientData.setLastAboutMe("Test about me");
		recipientData.setLastReasonForHelp("Test reason for help");
		recipientData.setFirstName("Jane");
		recipientData.setLastName("Smith");
		recipientData.setStreetAddress1("456 Main St");
		recipientData.setStreetAddress2("Apt 2B");
		recipientData.setCity("Boston");
		recipientData.setState("MA");
		recipientData.setZipCode("02108");
		newUser.setRecipientData(recipientData);

		var result = mockMvc.perform(post("/users").contentType(MediaType.APPLICATION_JSON)
			.content(objectMapper.writeValueAsString(newUser)));

		result.andExpect(status().isCreated())
			.andExpect(jsonPath("$.id", notNullValue()))
			.andExpect(jsonPath("$.cognitoId", is("test-cognito-id")))
			.andExpect(jsonPath("$.email", is("test@example.com")))
			.andExpect(jsonPath("$.recipient", is(true)))
			.andExpect(jsonPath("$.createdAt", notNullValue()))
			.andExpect(jsonPath("$.recipientData.firstName", is("Jane")))
			.andExpect(jsonPath("$.recipientData.lastName", is("Smith")))
			.andExpect(jsonPath("$.recipientData.streetAddress1", is("456 Main St")))
			.andExpect(jsonPath("$.recipientData.streetAddress2", is("Apt 2B")))
			.andExpect(jsonPath("$.recipientData.city", is("Boston")))
			.andExpect(jsonPath("$.recipientData.state", is("MA")))
			.andExpect(jsonPath("$.recipientData.zipCode", is("02108")))
			.andExpect(jsonPath("$.recipientData.lastAboutMe", is("Test about me")))
			.andExpect(jsonPath("$.recipientData.lastReasonForHelp", is("Test reason for help")))
			.andExpect(jsonPath("$.recipientData.nickname", notNullValue()))
			.andExpect(jsonPath("$.recipientData.imageUrl", notNullValue()));
	}

	@Test
	void updateUser_Recipient() throws Exception {
		User updatedUser = new User().id(7)
			.cognitoId("550e8400-e29b-41d4-a716-446655440007")
			.email("updated@example.com")
			.recipient(true);

		Recipient recipientData = new Recipient();
		recipientData.setId(7);
		recipientData.setLastAboutMe("Updated about me");
		recipientData.setLastReasonForHelp("Updated reason");
		recipientData.setNickname("Pink flamingo");
		recipientData.setFirstName("Updated");
		recipientData.setLastName("Name");
		recipientData.setStreetAddress1("789 Update St");
		recipientData.setStreetAddress2("Suite 101");
		recipientData.setCity("Chicago");
		recipientData.setState("IL");
		recipientData.setZipCode("60601");
		updatedUser.setRecipientData(recipientData);

		var result = mockMvc.perform(put("/users").contentType(MediaType.APPLICATION_JSON)
			.content(objectMapper.writeValueAsString(updatedUser)));

		result.andExpect(status().isOk())
			.andExpect(jsonPath("$.id", is(7)))
			.andExpect(jsonPath("$.cognitoId", is("550e8400-e29b-41d4-a716-446655440007")))
			.andExpect(jsonPath("$.email", is("updated@example.com")))
			.andExpect(jsonPath("$.recipient", is(true)))
			.andExpect(jsonPath("$.createdAt", is("2023-10-27T11:32:57.123Z"))) // Original
																				// creation
																				// time
			.andExpect(jsonPath("$.recipientData.id", is(7)))
			.andExpect(jsonPath("$.recipientData.nickname", is("Pink flamingo")))
			.andExpect(jsonPath("$.recipientData.firstName", is("Updated")))
			.andExpect(jsonPath("$.recipientData.lastName", is("Name")))
			.andExpect(jsonPath("$.recipientData.streetAddress1", is("789 Update St")))
			.andExpect(jsonPath("$.recipientData.streetAddress2", is("Suite 101")))
			.andExpect(jsonPath("$.recipientData.city", is("Chicago")))
			.andExpect(jsonPath("$.recipientData.state", is("IL")))
			.andExpect(jsonPath("$.recipientData.zipCode", is("60601")))
			.andExpect(jsonPath("$.recipientData.lastAboutMe", is("Updated about me")))
			.andExpect(jsonPath("$.recipientData.lastReasonForHelp", is("Updated reason")))
			// Check that original values for other properties haven't changed
			.andExpect(jsonPath("$.recipientData.imageUrl", is("https://example.com/image7.jpg")))
			.andExpect(jsonPath("$.recipientData.formQuestions", hasSize(1)))
			.andExpect(jsonPath("$.recipientData.formQuestions[0].question", is("question7")))
			.andExpect(jsonPath("$.recipientData.formQuestions[0].answer", is("answer7")))
			.andExpect(jsonPath("$.recipientData.createdAt", is("2023-10-27T11:32:57.123Z")))
			.andExpect(jsonPath("$.recipientData.tagsLastGenerated", is("2023-10-27T11:31:43.471Z")))
			// identity last verified is dynamically set to 10 days before "now", so just
			// check the date
			.andExpect(jsonPath("$.recipientData.identityLastVerified",
					startsWith(LocalDate.now().minusDays(10).toString())))
			// Similarly, income last verified is dynamically set to 100 days before
			// "now", so just check the date
			.andExpect(jsonPath("$.recipientData.incomeLastVerified",
					startsWith(LocalDate.now().minusDays(100).toString())))
			.andExpect(jsonPath("$.recipientData.lastDonationTimestamp").doesNotExist());
	}

	@Test
	void updateUser_Donor() throws Exception {
		User updatedUser = new User().id(8)
			.cognitoId("550e8400-e29b-41d4-a716-446655440006")
			.email("updated.donor@example.com")
			.recipient(false);

		Donor donorData = new Donor();
		donorData.setNickname("Updated GenerousSoul3");
		updatedUser.setDonorData(donorData);

		var result = mockMvc.perform(put("/users").contentType(MediaType.APPLICATION_JSON)
			.content(objectMapper.writeValueAsString(updatedUser)));

		result.andExpect(status().isOk())
			.andExpect(jsonPath("$.id", is(8)))
			.andExpect(jsonPath("$.cognitoId", is("550e8400-e29b-41d4-a716-446655440006")))
			.andExpect(jsonPath("$.email", is("updated.donor@example.com")))
			.andExpect(jsonPath("$.recipient", is(false)))
			.andExpect(jsonPath("$.createdAt", is("2023-10-15T16:30:30.123Z"))) // Original
																				// creation
																				// time
			.andExpect(jsonPath("$.donorData.id", is(8)))
			.andExpect(jsonPath("$.donorData.nickname", is("Updated GenerousSoul3")))
			.andExpect(jsonPath("$.donorData.createdAt", is("2023-10-15T16:30:30.123Z"))) // Original
																							// creation
																							// time
			.andExpect(jsonPath("$.recipientData").doesNotExist());
	}

	@Test
	void updateUser_Error() throws Exception {
		// Test updating non-existent user
		User nonExistentUser = new User().id(999)
			.cognitoId("non-existent-id")
			.email("nonexistent@example.com")
			.recipient(true);

		mockMvc
			.perform(put("/users").contentType(MediaType.APPLICATION_JSON)
				.content(objectMapper.writeValueAsString(nonExistentUser)))
			.andExpect(status().isNotFound())
			.andExpect(jsonPath("$.errorMessage", is("User with id 999 not found, can't update entry")))
			.andExpect(jsonPath("$.status", is(404)))
			.andExpect(jsonPath("$.errorType", is("Not Found")))
			.andExpect(jsonPath("$.timestamp").exists())
			.andExpect(jsonPath("$.path", is("/users")))
			.andExpect(jsonPath("$.notFoundEntityId", is(999)))
			.andExpect(jsonPath("$.notFoundEntityType", is("User")));

		// Test updating existing recipient user with wrong recipient flag
		User userWithWrongFlag = new User().id(1)
			.cognitoId("550e8400-e29b-41d4-a716-446655440000")
			.email("recipient1@example.com")
			.recipient(false); // Wrong flag - user 1 is a recipient

		mockMvc
			.perform(put("/users").contentType(MediaType.APPLICATION_JSON)
				.content(objectMapper.writeValueAsString(userWithWrongFlag)))
			.andExpect(status().isBadRequest())
			.andExpect(jsonPath("$.errorMessage",
					is("Can't switch user type with this method, please use the appropriate 'switch' endpoint")))
			.andExpect(jsonPath("$.status", is(400)))
			.andExpect(jsonPath("$.errorType", is("Bad Request")))
			.andExpect(jsonPath("$.timestamp").exists())
			.andExpect(jsonPath("$.path", is("/users")));
	}

	@Test
	void addDonor() throws Exception {
		Donor donor = new Donor();
		donor.setNickname("TestDonor");

		var result = mockMvc.perform(put("/users/switch/donor/6").contentType(MediaType.APPLICATION_JSON)
			.content(objectMapper.writeValueAsString(donor)));

		result.andExpect(status().isOk())
			.andExpect(jsonPath("$.id", is(6)))
			.andExpect(jsonPath("$.recipient", is(false)))
			.andExpect(jsonPath("$.donorData.nickname", is("TestDonor")));
	}

	@Test
	void addDonor_Error() throws Exception {
		// Test adding donor for non-existent user
		Donor nonExistentRequest = new Donor();
		nonExistentRequest.setNickname("NonExistentDonor");

		mockMvc
			.perform(put("/users/switch/donor/999").contentType(MediaType.APPLICATION_JSON)
				.content(objectMapper.writeValueAsString(nonExistentRequest)))
			.andExpect(status().isNotFound())
			.andExpect(jsonPath("$.errorMessage", is("User with id 999 not found, can't switch to donor")))
			.andExpect(jsonPath("$.status", is(404)))
			.andExpect(jsonPath("$.errorType", is("Not Found")))
			.andExpect(jsonPath("$.timestamp").exists())
			.andExpect(jsonPath("$.path", is("/users/switch/donor/999")))
			.andExpect(jsonPath("$.notFoundEntityId", is(999)))
			.andExpect(jsonPath("$.notFoundEntityType", is("User")));

		// Test adding donor for existing donor user
		Donor invalidTypeRequest = new Donor();
		invalidTypeRequest.setNickname("InvalidDonor");

		mockMvc
			.perform(put("/users/switch/donor/3").contentType(MediaType.APPLICATION_JSON)
				.content(objectMapper.writeValueAsString(invalidTypeRequest)))
			.andExpect(status().isBadRequest())
			.andExpect(jsonPath("$.errorMessage", is("User 3 is already a donor")))
			.andExpect(jsonPath("$.status", is(400)))
			.andExpect(jsonPath("$.errorType", is("Bad Request")))
			.andExpect(jsonPath("$.timestamp").exists())
			.andExpect(jsonPath("$.path", is("/users/switch/donor/3")));
	}

	@Test
	void addRecipient() throws Exception {
		Recipient request = new Recipient();
		request.setLastAboutMe("My story of perseverance");
		request.setLastReasonForHelp("Seeking assistance for education");
		request.setFirstName("Jane");
		request.setLastName("Smith");
		request.setStreetAddress1("123 Hope Street");
		request.setCity("Springfield");
		request.setState("IL");
		request.setZipCode("62701");

		var result = mockMvc.perform(put("/users/switch/recipient/4").contentType(MediaType.APPLICATION_JSON)
			.content(objectMapper.writeValueAsString(request)));

		result.andExpect(status().isOk())
			.andExpect(jsonPath("$.id", is(4)))
			.andExpect(jsonPath("$.cognitoId", is("550e8400-e29b-41d4-a716-446655440003")))
			.andExpect(jsonPath("$.email", is("donor2@example.com")))
			.andExpect(jsonPath("$.recipient", is(true)))
			// User-level createdAt should be unchanged
			.andExpect(jsonPath("$.createdAt", is("2023-10-15T13:35:00.321Z")))
			.andExpect(jsonPath("$.recipientData.id", is(4)))
			.andExpect(jsonPath("$.recipientData.lastAboutMe", is("My story of perseverance")))
			.andExpect(jsonPath("$.recipientData.lastReasonForHelp", is("Seeking assistance for education")))
			.andExpect(jsonPath("$.recipientData.firstName", is("Jane")))
			.andExpect(jsonPath("$.recipientData.lastName", is("Smith")))
			.andExpect(jsonPath("$.recipientData.streetAddress1", is("123 Hope Street")))
			.andExpect(jsonPath("$.recipientData.streetAddress2").doesNotExist())
			.andExpect(jsonPath("$.recipientData.city", is("Springfield")))
			.andExpect(jsonPath("$.recipientData.state", is("IL")))
			.andExpect(jsonPath("$.recipientData.zipCode", is("62701")))
			// Donor nickname copied over
			.andExpect(jsonPath("$.recipientData.nickname", is("HelpfulDonor2")))
			// Image URL is created by the service
			.andExpect(jsonPath("$.recipientData.imageUrl", is(notNullValue())))
			// Entry should have been created today
			.andExpect(jsonPath("$.recipientData.createdAt", startsWith(LocalDate.now().toString())))
			// Verify that other Recipient properties don't exist
			.andExpect(jsonPath("$.recipientData.formQuestions").doesNotExist())
			.andExpect(jsonPath("$.recipientData.identityLastVerified").doesNotExist())
			.andExpect(jsonPath("$.recipientData.incomeLastVerified").doesNotExist())
			.andExpect(jsonPath("$.recipientData.tagsLastGenerated").doesNotExist())
			.andExpect(jsonPath("$.recipientData.lastDonationTimestamp").doesNotExist())
			// Check that donor data is still present as well
			.andExpect(jsonPath("$.donorData").exists())
			.andExpect(jsonPath("$.donorData.id", is(4)))
			.andExpect(jsonPath("$.donorData.nickname", is("HelpfulDonor2")))
			.andExpect(jsonPath("$.donorData.createdAt", is("2023-10-15T13:35:00.321Z")));
	}

	@Test
	void addRecipient_Error() throws Exception {
		// Test adding recipient for non-existent user
		Recipient nonExistentRequest = new Recipient();
		nonExistentRequest.setNickname("NonExistentRecipient");
		nonExistentRequest.setLastAboutMe("About me text");
		nonExistentRequest.setLastReasonForHelp("Need help because...");

		mockMvc
			.perform(put("/users/switch/recipient/999").contentType(MediaType.APPLICATION_JSON)
				.content(objectMapper.writeValueAsString(nonExistentRequest)))
			.andExpect(status().isNotFound())
			.andExpect(jsonPath("$.errorMessage", is("User with id 999 not found, can't switch to recipient")))
			.andExpect(jsonPath("$.status", is(404)))
			.andExpect(jsonPath("$.errorType", is("Not Found")))
			.andExpect(jsonPath("$.timestamp").exists())
			.andExpect(jsonPath("$.path", is("/users/switch/recipient/999")))
			.andExpect(jsonPath("$.notFoundEntityId", is(999)))
			.andExpect(jsonPath("$.notFoundEntityType", is("User")));

		// Test adding recipient for existing recipient user
		Recipient invalidTypeRequest = new Recipient();
		invalidTypeRequest.setNickname("InvalidRecipient");
		invalidTypeRequest.setLastAboutMe("About me text");
		invalidTypeRequest.setLastReasonForHelp("Need help because...");

		mockMvc
			.perform(put("/users/switch/recipient/1").contentType(MediaType.APPLICATION_JSON)
				.content(objectMapper.writeValueAsString(invalidTypeRequest)))
			.andExpect(status().isBadRequest())
			.andExpect(jsonPath("$.errorMessage", is("User 1 is already a recipient")))
			.andExpect(jsonPath("$.status", is(400)))
			.andExpect(jsonPath("$.errorType", is("Bad Request")))
			.andExpect(jsonPath("$.timestamp").exists())
			.andExpect(jsonPath("$.path", is("/users/switch/recipient/1")));
	}

}

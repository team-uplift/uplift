package org.upLift.services;

import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.core.io.Resource;
import org.upLift.model.Tag;
import org.upLift.repositories.TagRepository;

import java.util.List;
import java.util.Map;
import java.util.function.Consumer;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class BedrockServiceImplTest {

	@Mock
	private TagRepository tagRepository;

	@Mock
	private ChatModel chatModel;

	private BedrockServiceImpl service;

	@BeforeEach
	void setUp() {
		service = new BedrockServiceImpl(chatModel, tagRepository);
	}

	@Test
	void getTagsFromPrompt_returnsParsedMap() {
		String prompt = "a test prompt";
		String llmResponse = "TagOne:0.75, tagTwo:0.25, Third Tag:1.0";

		String finalPrompt = "Only generate a comma separated list of tags/descriptors and associated "
				+ "numeric weights (from 0 to 1) in the format tag:number. "
				+ "If the tag is more than one word separate the tag's words with a space. "
				+ "Do not use underscores or dashes. Tags are less than 4 words each. "
				+ "Remove any gendered language and racial content. "
				+ "Generate at least 15 tags. "
				+ "The tags describe the contents and the weights are how relevant the tag is to the following prompt: "
				+ prompt;

		// mock static ChatClient.create(...) to return a deep-stubbed ChatClient
		try (MockedStatic<ChatClient> chatClientStatic = mockStatic(ChatClient.class)) {
			var chatClientMock = mock(ChatClient.class, RETURNS_DEEP_STUBS);
			chatClientStatic.when(() -> ChatClient.create(chatModel))
					.thenReturn(chatClientMock);

			// stub the builder chain to return our fake response
			when(chatClientMock.prompt()
					.user((Consumer<ChatClient.PromptUserSpec>) any())
					.call()
					.content())
					.thenReturn(llmResponse);

			Map<String, Double> tags = service.getTagsFromPrompt(prompt);

			// keys should be lower-cased and trimmed
			assertEquals(3, tags.size());
			assertTrue(tags.containsKey("tagone"));
			assertEquals(0.75, tags.get("tagone"));
			assertTrue(tags.containsKey("tagtwo"));
			assertEquals(0.25, tags.get("tagtwo"));
			assertTrue(tags.containsKey("third tag"));
			assertEquals(1.0, tags.get("third tag"));
		}
	}

	@Test
	void getTagsFromPrompt_withNullResponse_returnsEmptyMap() {
		try (MockedStatic<ChatClient> chatClientStatic = mockStatic(ChatClient.class)) {
			var chatClientMock = mock(ChatClient.class, RETURNS_DEEP_STUBS);
			chatClientStatic.when(() -> ChatClient.create(chatModel))
					.thenReturn(chatClientMock);
			when(chatClientMock.prompt()
					.user((Consumer<ChatClient.PromptUserSpec>) any())
					.call()
					.content())
					.thenReturn(null);

			Map<String, Double> tags = service.getTagsFromPrompt("whatever");

			assertNotNull(tags);
			assertTrue(tags.isEmpty());
		}
	}

	@Test
	void matchTagsFromPrompt_returnsListOfTags() {
		String prompt = "find matching tags";
		// prepare some known tags
		Tag t1 = mock(Tag.class);
		when(t1.toPromptString()).thenReturn("Alpha");
		Tag t2 = mock(Tag.class);
		when(t2.toPromptString()).thenReturn("Beta");
		when(tagRepository.findAll()).thenReturn(List.of(t1, t2));

		String llmMatchResponse = "alpha, beta, gamma";

		try (MockedStatic<ChatClient> chatClientStatic = mockStatic(ChatClient.class)) {
			var chatClientMock = mock(ChatClient.class, RETURNS_DEEP_STUBS);
			chatClientStatic.when(() -> ChatClient.create(chatModel))
					.thenReturn(chatClientMock);
			when(chatClientMock.prompt()
					.user((Consumer<ChatClient.PromptUserSpec>) any())
					.call()
					.content())
					.thenReturn(llmMatchResponse);

			List<String> matched = service.matchTagsFromPrompt(prompt);

			assertEquals(3, matched.size());
			assertEquals(List.of("alpha", "beta", "gamma"), matched);
		}
	}

	@Test
	void matchTagsFromPrompt_withNullResponse_returnsEmptyList() {
		when(tagRepository.findAll()).thenReturn(List.of()); // no tags needed, but still triggers prompt

		try (MockedStatic<ChatClient> chatClientStatic = mockStatic(ChatClient.class)) {
			var chatClientMock = mock(ChatClient.class, RETURNS_DEEP_STUBS);
			chatClientStatic.when(() -> ChatClient.create(chatModel))
					.thenReturn(chatClientMock);
			when(chatClientMock.prompt()
					.user((Consumer<ChatClient.PromptUserSpec>) any())
					.call()
					.content())
					.thenReturn(null);

			List<String> matched = service.matchTagsFromPrompt("anything");

			assertNotNull(matched);
			assertTrue(matched.isEmpty());
		}
	}
}

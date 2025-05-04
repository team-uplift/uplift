/**
 * The BedrockServiceImpl encapsulates all interactions with the underlying LLM “Bedrock” chat service to translate
 * free-form text into structured tags and weights or to pick the best matching tags from a known list. When you call
 * getTagsFromPrompt, it builds a carefully constrained prompt instructing the model to emit at least 15 comma-separated
 * tag:weight pairs, invokes the chat API via ChatClient.create(chatModel), then parses and normalizes the response into
 * a Map<String,Double>. Likewise, matchTagsFromPrompt first loads every existing tag from the database, weaves them
 * into a RAG-style prompt asking the model to pick the most relevant ones for a given text, and then breaks the comma
 * list back into a List<String>. Throughout, it handles null or empty responses gracefully, lower-cases and trims tag
 * names, logs the raw model output, and centralizes all prompt construction and parsing logic so the rest of the
 * application can work with plain Java collections rather than raw LLM calls.
 */
package org.upLift.services;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.stereotype.Service;
import org.upLift.model.Tag;
import org.upLift.repositories.TagRepository;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class BedrockServiceImpl implements BedrockService {

	private final TagRepository tagRepository;

	public Logger logger = LoggerFactory.getLogger(this.getClass());

	private final ChatModel chatModel;

	public BedrockServiceImpl(ChatModel chatModel, TagRepository tagRepository) {
		this.chatModel = chatModel;
		this.tagRepository = tagRepository;
	}

	// @formatter:off
	// Not sure why the Maven run previously worked with this formatting??
	@Override
	public Map<String, Double> getTagsFromPrompt(String prompt) {
        String finalPrompt = "Only generate a comma separated list of tags/descriptors and associated "
				+ "numeric weights (from 0 to 1) in the format tag:number. "
				+ "If the tag is more than one word separate the tag's words with a space. "
                + "Do not use underscores or dashes. Tags are less than 4 words each. "
                + "Remove any gendered language and racial content. "
                + "Generate at least 15 tags. "
				+ "The tags describe the contents and the weights are how relevant the tag is to the following prompt: "
				+ prompt;
        String response = ChatClient.create(chatModel)
                .prompt()
                .user(u -> u.text(finalPrompt))
                .call()
                .content();

        List<String> finalResponse = new ArrayList<>();
        if (response != null) {
            finalResponse = List.of(response.split(", "));
        }

        Map<String, Double> finalTags = new HashMap<>();
        for (String tag : finalResponse) {
            List<String> preProcessedValues = List.of(tag.split(":"));
            finalTags.put(preProcessedValues.get(0).toLowerCase().trim(),
					Double.parseDouble(preProcessedValues.get(1)));
        }

        logger.info(response);

        return finalTags;
    }

	/**
     * This method will implement the LLM recipient matching based on the tag generation with a simple rag based prompting.
     * @param prompt
     * @return
     */
	@Override
    public List<String> matchTagsFromPrompt(String prompt) {
        List<Tag> knownTags = new ArrayList<>();
        knownTags = tagRepository.findAll();

        // Implement the injected rag content to filter the output and isolate responses to specifically known tags.
        String allTags = "Tags: " + knownTags.stream().map(Tag::toPromptString).collect(Collectors.joining(", "));

        // Build the request to send to bedrock with the rag sidecar.
        String finalPrompt = "Match to the provided list tags that best match the contents of the following prompt. "
				+ "Only respond with a comma separated list of the tags. Do not respond in sentences. "
				+ "Do not organize the tags. Do not categorize the tags. Do not use underscores or dashes. \n "
				+ "Prompt: " + prompt + " \n" + allTags;
        String response = ChatClient.create(chatModel)
                .prompt()
                .user(u -> u.text(finalPrompt))
                .call()
                .content();

        List<String> finalResponse = new ArrayList<>();
        if (response != null) {
            finalResponse = List.of(response.split(", "));
        }

        logger.info(response);

        return finalResponse;
    }
	// @formatter:on

}

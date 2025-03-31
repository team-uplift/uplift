package org.upLift.services;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.model.Media;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class BedrockServiceImpl implements BedrockService {

	public Logger logger = LoggerFactory.getLogger(this.getClass());

	private final ChatModel chatModel;

	public BedrockServiceImpl(ChatModel chatModel) {
		this.chatModel = chatModel;
	}

	@Override
    public Map<String, Double> getTagsFromPrompt(String prompt) {
        String finalPrompt = STR."Only generate a comma seperated list of tags/descriptors and associated numeric weights (from 0 to 1) in the format tag:number. If the tag is more than one word seperate the tag's words with a space. Do not use underscores or dashes. Tags are less than 4 words each. Generate at least 15 tags. The tags describe the contents and the weights are how relevant the tag is to the following prompt: \{prompt}";
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
            finalTags.put(preProcessedValues.get(0), Double.parseDouble(preProcessedValues.get(1)));
        }

        logger.info(response);

        return finalTags;
    }

	@Override
    public Map<String, Double> matchTagsFromPrompt(String prompt) {
        String finalPrompt = STR."Match to the provided list tags/descriptors that best describe the contents of the following prompt and provide numeric weights to each tag to show how close the descriptor is to the prompt: \{prompt}";
        String response = ChatClient.create(chatModel)
                .prompt()
                .user(u -> u.text(finalPrompt)
                        .media(Media.Format.DOC_CSV, new ClassPathResource("/tags.csv"))
                )
                .call()
                .content();

        // TODO - Process the output
        // Recipients -> find the recipients have highest weighted tags
        // Recipients -> filter recipients with need already met.
        // Recipients -> Artificially inject recipients based on results.
        Map<String, Double> finalResponse = new HashMap<>();

        logger.info(response);

        return finalResponse;
    }

}

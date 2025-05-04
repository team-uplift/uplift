package org.upLift.services;

import java.util.List;
import java.util.Map;

/**
 * Service interface for interacting with the Bedrock AI model to generate and match tags.
 */
public interface BedrockService {

	/**
	 * Generates tags and their associated weights based on the provided prompt.
	 * @param prompt the input prompt used to generate tags
	 * @return a map where the keys are the generated tags and the values are their
	 * associated weights
	 */
	Map<String, Double> getTagsFromPrompt(String prompt);

	/**
	 * Matches the provided prompt to a predefined list of tags.
	 * @param prompt the input prompt used to match tags
	 * @return a list of tags that best match the provided prompt
	 */
	List<String> matchTagsFromPrompt(String prompt);

}

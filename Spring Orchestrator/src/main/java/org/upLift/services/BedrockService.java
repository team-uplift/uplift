package org.upLift.services;

import java.util.List;
import java.util.Map;

public interface BedrockService {

	Map<String, Double> getTagsFromPrompt(String prompt);

	List<String> matchTagsFromPrompt(String prompt);

}

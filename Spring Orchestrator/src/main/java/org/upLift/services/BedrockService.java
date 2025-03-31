package org.upLift.services;

import java.util.List;
import java.util.Map;

public interface BedrockService {

	public Map<String, Double> getTagsFromPrompt(String prompt);

	public Map<String, Double> matchTagsFromPrompt(String prompt);

}

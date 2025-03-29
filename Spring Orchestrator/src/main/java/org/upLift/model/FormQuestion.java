package org.upLift.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;

/**
 * JSON-only model class, used to hold a single form question asked of a user with their
 * response.
 */
public class FormQuestion {

	@JsonProperty("question")
	private String question;

	@JsonProperty("answer")
	private String answer;

	@Schema(example = "What was the biggest challenge in the last 6 months?",
			description = "question posed to the user")

	public String getQuestion() {
		return question;
	}

	public void setQuestion(String question) {
		this.question = question;
	}

	@Schema(example = "I was laid off 2 months ago.", description = "user's answer to the question")

	public String getAnswer() {
		return answer;
	}

	public void setAnswer(String answer) {
		this.answer = answer;
	}

}

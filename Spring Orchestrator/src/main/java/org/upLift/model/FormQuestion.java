package org.upLift.model;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * JSON-only model class, used to hold a single form question asked of a recipient with their response.
 */
public class FormQuestion {

	@JsonProperty("question")
	private String question;

	@JsonProperty("answer")
	private String answer;

	public String getQuestion() {
		return question;
	}

	public void setQuestion(String question) {
		this.question = question;
	}

	public String getAnswer() {
		return answer;
	}

	public void setAnswer(String answer) {
		this.answer = answer;
	}
}

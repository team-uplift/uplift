package org.upLift.model;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonSetter;
import com.fasterxml.jackson.annotation.Nulls;
import io.swagger.v3.oas.annotations.media.Schema;
import org.springframework.validation.annotation.Validated;
import org.upLift.configuration.NotUndefined;

import java.time.Instant;
import java.util.Objects;

/**
 * HistoricalDonorPrompt
 */
@Validated
@NotUndefined
@jakarta.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen",
		date = "2025-03-16T14:18:35.909799305Z[GMT]")

public class HistoricalDonorPrompt extends AbstractCreatedEntity {

	@JsonProperty("donorId")

	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	@JsonSetter(nulls = Nulls.FAIL) // FAIL setting if the value is null
	private Integer donorSessionId = null;

	@JsonProperty("prompt")

	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	@JsonSetter(nulls = Nulls.FAIL) // FAIL setting if the value is null
	private String prompt = null;

	public HistoricalDonorPrompt id(Integer id) {
		setId(id);
		return this;
	}

	public HistoricalDonorPrompt donorSessionId(Integer donorId) {

		this.donorSessionId = donorId;
		return this;
	}

	/**
	 * Get donorId
	 * @return donorId
	 **/

	@Schema(example = "101", description = "persistence index ")

	public Integer getDonorId() {
		return donorSessionId;
	}

	public void setDonorId(Integer donorId) {
		this.donorSessionId = donorId;
	}

	public HistoricalDonorPrompt prompt(String prompt) {

		this.prompt = prompt;
		return this;
	}

	/**
	 * Get prompt
	 * @return prompt
	 **/

	@Schema(example = "Pick one of the following", description = "Prompt provided to donor to select tag")

	public String getPrompt() {
		return prompt;
	}

	public void setPrompt(String prompt) {
		this.prompt = prompt;
	}

	public HistoricalDonorPrompt createdAt(Instant createdAt) {
		return (HistoricalDonorPrompt) super.createdAt(createdAt);
	}

	@Override
	public boolean equals(java.lang.Object o) {
		if (this == o) {
			return true;
		}
		if (o == null || getClass() != o.getClass()) {
			return false;
		}
		HistoricalDonorPrompt historicalDonorPrompt = (HistoricalDonorPrompt) o;
		return Objects.equals(this.getId(), historicalDonorPrompt.getId())
				&& Objects.equals(this.donorSessionId, historicalDonorPrompt.donorSessionId)
				&& Objects.equals(this.prompt, historicalDonorPrompt.prompt)
				&& Objects.equals(this.getCreatedAt(), historicalDonorPrompt.getCreatedAt());
	}

	@Override
	public int hashCode() {
		return Objects.hash(getId(), donorSessionId, prompt, getCreatedAt());
	}

	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("class HistoricalDonorPrompt {\n");

		sb.append("    id: ").append(toIndentedString(getId())).append("\n");
		sb.append("    donorId: ").append(toIndentedString(donorSessionId)).append("\n");
		sb.append("    prompt: ").append(toIndentedString(prompt)).append("\n");
		sb.append("    createdAt: ").append(toIndentedString(getCreatedAt())).append("\n");
		sb.append("}");
		return sb.toString();
	}

}

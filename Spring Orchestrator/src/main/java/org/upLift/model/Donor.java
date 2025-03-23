package org.upLift.model;

import java.util.Objects;
import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import java.util.ArrayList;
import java.util.List;
import org.springframework.validation.annotation.Validated;
import org.upLift.configuration.NotUndefined;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonSetter;
import com.fasterxml.jackson.annotation.Nulls;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;

/**
 * Donor
 */
@Validated
@NotUndefined
@jakarta.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen",
		date = "2025-03-16T14:18:35.909799305Z[GMT]")

public class Donor {

	@JsonProperty("id")

	private Long id = null;

	@JsonProperty("cognito_id")

	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	@JsonSetter(nulls = Nulls.FAIL) // FAIL setting if the value is null
	private String cognitoId = null;

	@JsonProperty("username")

	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	@JsonSetter(nulls = Nulls.FAIL) // FAIL setting if the value is null
	private String username = null;

	@JsonProperty("email")

	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	@JsonSetter(nulls = Nulls.FAIL) // FAIL setting if the value is null
	private String email = null;

	@JsonProperty("last_quiz_text")

	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	@JsonSetter(nulls = Nulls.FAIL) // FAIL setting if the value is null
	private String lastQuizText = null;

	@JsonProperty("nickname")

	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	@JsonSetter(nulls = Nulls.FAIL) // FAIL setting if the value is null
	private String nickname = null;

	@JsonProperty("tags")
	@Valid
	private List<Tag> tags = null;

	public Donor id(Long id) {

		this.id = id;
		return this;
	}

	/**
	 * Get id
	 * @return id
	 **/

	@Schema(example = "10", required = true, description = "")

	@NotNull
	public Long getId() {
		return id;
	}

	public void setId(Long id) {

		this.id = id;
	}

	public Donor cognitoId(String cognitoId) {

		this.cognitoId = cognitoId;
		return this;
	}

	/**
	 * Get cognitoId
	 * @return cognitoId
	 **/

	@Schema(example = "oijwedf-wrefwefr-saedf3rweg-gv", description = "")

	public String getCognitoId() {
		return cognitoId;
	}

	public void setCognitoId(String cognitoId) {
		this.cognitoId = cognitoId;
	}

	public Donor username(String username) {

		this.username = username;
		return this;
	}

	/**
	 * Get username
	 * @return username
	 **/

	@Schema(example = "testUser", description = "")

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public Donor email(String email) {

		this.email = email;
		return this;
	}

	/**
	 * Get email
	 * @return email
	 **/

	@Schema(example = "testUser", description = "")

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Donor lastQuizText(String lastQuizText) {

		this.lastQuizText = lastQuizText;
		return this;
	}

	/**
	 * Get lastQuizText
	 * @return lastQuizText
	 **/

	@Schema(example = "I like tomatoes.", description = "")

	public String getLastQuizText() {
		return lastQuizText;
	}

	public void setLastQuizText(String lastQuizText) {
		this.lastQuizText = lastQuizText;
	}

	public Donor nickname(String nickname) {

		this.nickname = nickname;
		return this;
	}

	/**
	 * Get nickname
	 * @return nickname
	 **/

	@Schema(example = "PotatoKing", description = "")

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public Donor tags(List<Tag> tags) {

		this.tags = tags;
		return this;
	}

	public Donor addTagsItem(Tag tagsItem) {
		if (this.tags == null) {
			this.tags = new ArrayList<Tag>();
		}
		this.tags.add(tagsItem);
		return this;
	}

	/**
	 * Get tags
	 * @return tags
	 **/

	@Schema(description = "")
	@Valid
	public List<Tag> getTags() {
		return tags;
	}

	public void setTags(List<Tag> tags) {
		this.tags = tags;
	}

	@Override
	public boolean equals(java.lang.Object o) {
		if (this == o) {
			return true;
		}
		if (o == null || getClass() != o.getClass()) {
			return false;
		}
		Donor donor = (Donor) o;
		return Objects.equals(this.id, donor.id) && Objects.equals(this.cognitoId, donor.cognitoId)
				&& Objects.equals(this.username, donor.username) && Objects.equals(this.email, donor.email)
				&& Objects.equals(this.lastQuizText, donor.lastQuizText)
				&& Objects.equals(this.nickname, donor.nickname) && Objects.equals(this.tags, donor.tags);
	}

	@Override
	public int hashCode() {
		return Objects.hash(id, cognitoId, username, email, lastQuizText, nickname, tags);
	}

	@Override
	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append("class Donor {\n");

		sb.append("    id: ").append(toIndentedString(id)).append("\n");
		sb.append("    cognitoId: ").append(toIndentedString(cognitoId)).append("\n");
		sb.append("    username: ").append(toIndentedString(username)).append("\n");
		sb.append("    email: ").append(toIndentedString(email)).append("\n");
		sb.append("    lastQuizText: ").append(toIndentedString(lastQuizText)).append("\n");
		sb.append("    nickname: ").append(toIndentedString(nickname)).append("\n");
		sb.append("    tags: ").append(toIndentedString(tags)).append("\n");
		sb.append("}");
		return sb.toString();
	}

	/**
	 * Convert the given object to string with each line indented by 4 spaces (except the
	 * first line).
	 */
	private String toIndentedString(java.lang.Object o) {
		if (o == null) {
			return "null";
		}
		return o.toString().replace("\n", "\n    ");
	}

}

package org.upLift.model;

import com.fasterxml.jackson.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;

import java.util.Objects;

@Entity
@Table(name = "users")
public class User extends AbstractCreatedEntity {

	@Column(name = "cognito_id", unique = true)
	@JsonProperty("cognitoId")
	private String cognitoId = null;

	@Column(name = "email")
	@JsonProperty("email")
	@JsonSetter(nulls = Nulls.FAIL) // FAIL setting if the value is null
	private String email = null;

	@Column(name = "recipient", nullable = false)
	@JsonProperty("recipient")
	@JsonSetter(nulls = Nulls.FAIL) // FAIL setting if the value is null
	private boolean recipient;

	@OneToOne(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	@JsonProperty("recipientData")
	private Recipient recipientData;

	@OneToOne(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	@JsonProperty("donorData")
	private Donor donorData;

	public User id(Integer id) {
		return (User) super.id(id);
	}

	public User cognitoId(String cognitoId) {
		this.cognitoId = cognitoId;
		return this;
	}

	/**
	 * Get cognitoId
	 * @return cognitoId
	 **/

	@Schema(example = "oijwedf-wrefwefr-saedf3rweg-gv", description = "UUID assigned by Cognito when a user registers")

	public String getCognitoId() {
		return cognitoId;
	}

	public void setCognitoId(String cognitoId) {
		this.cognitoId = cognitoId;
	}

	public User email(String email) {
		this.email = email;
		return this;
	}

	/**
	 * Get email
	 * @return email
	 **/

	@Schema(example = "user@nonsense.com", description = "email of the recipient, serves as username to log in")

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public User recipient(boolean recipient) {
		this.recipient = recipient;
		return this;
	}

	@Schema(example = "true",
			description = "flag indicating whether user is currently acting as a recipient or a donor, "
					+ "used to guide which set of data is loaded")

	public boolean isRecipient() {
		return recipient;
	}

	public void setRecipient(boolean recipient) {
		this.recipient = recipient;
	}

	@JsonIgnore
	public boolean isDonor() {
		return !recipient;
	}

	@Schema(implementation = Recipient.class,
			description = "holds all recipient-specific data, only present if recipient flag is true")

	public Recipient getRecipientData() {
		return recipientData;
	}

	public void setRecipientData(Recipient recipientData) {
		this.recipientData = recipientData;
		if (recipientData != null) {
			recipientData.setUser(this);
		}
	}

	@Schema(implementation = Donor.class,
			description = "holds all donor-specific data, only present if recipient flag is false")

	public Donor getDonorData() {
		return donorData;
	}

	public void setDonorData(Donor donorData) {
		this.donorData = donorData;
		if (donorData != null) {
			donorData.setUser(this);
		}
	}

	@Override
	public boolean equals(Object o) {
		if (o == null || getClass() != o.getClass())
			return false;
		User user = (User) o;
		return Objects.equals(cognitoId, user.cognitoId) && Objects.equals(email, user.email);
	}

	@Override
	public int hashCode() {
		return Objects.hash(cognitoId, email);
	}

	@Override
	public String toString() {
		// @formatter:off
		return "class User {\n"
				+ "    id: " + toIndentedString(getId()) + "\n"
				+ "    cognitoId: " + toIndentedString(cognitoId) + "\n"
				+ "    email: " + toIndentedString(email) + "\n"
				+ "    recipient flag: " + toIndentedString(recipient) + "\n"
				+ "    createdAt: " + toIndentedString(getCreatedAt()) + "\n"
				+ "}";
		// @formatter:on
	}

}

package org.upLift.model;

import com.fasterxml.jackson.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.annotation.Generated;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import org.springframework.validation.annotation.Validated;
import org.upLift.configuration.NotUndefined;

import java.util.Objects;

/**
 * Message
 */
@Validated
@NotUndefined
@Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen", date = "2025-03-16T14:18:35.909799305Z[GMT]")
@Entity
@Table(name = "messages")
public class Message extends AbstractCreatedEntity {

	@JsonIgnore
	@NotNull
	@OneToOne(optional = false)
	@JoinColumn(name = "donation_id", referencedColumnName = "id", nullable = false)
	private Donation donation;

	@NotNull
	@Column(name = "message", nullable = false)
	@JsonProperty("message")
	@JsonSetter(nulls = Nulls.FAIL) // FAIL setting if the value is null
	private String message;

	@Column(name = "donor_read", nullable = false)
	@JsonProperty("donorRead")
	private boolean donorRead;

	public Message id(Integer id) {
		return (Message) super.id(id);
	}

	public Message donation(Donation donation) {
		this.donation = donation;
		return this;
	}

	/**
	 * Get donationId
	 * @return donationId
	 **/

	@Schema(example = "101", description = "persistence index of the donation to which this message is linked")

	@JsonGetter("donationId")
	public Integer getDonationId() {
		return donation != null ? donation.getId() : null;
	}

	public Message donationId(int donationId) {
		this.setDonationId(donationId);
		return this;
	}

	@JsonSetter("donationId")
	public void setDonationId(Integer donationId) {
		this.donation = new Donation().id(donationId);
	}

	public Donation getDonation() {
		return donation;
	}

	public void setDonation(Donation donation) {
		this.donation = donation;
	}

	public Message message(String message) {

		this.message = message;
		return this;
	}

	/**
	 * Get message
	 * @return message
	 **/

	@Schema(example = "Thank you for your kind gift!",
			description = "thank-you message from the recipient to the donor")

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public Message donorRead(boolean donorRead) {
		this.donorRead = donorRead;
		return this;
	}

	@Schema(example = "true", description = "indicates if the donor has already seen this message or not")

	public boolean isDonorRead() {
		return donorRead;
	}

	public void setDonorRead(boolean donorRead) {
		this.donorRead = donorRead;
	}

	@Override
	public boolean equals(java.lang.Object o) {
		if (this == o) {
			return true;
		}
		if (o == null || getClass() != o.getClass()) {
			return false;
		}
		Message message = (Message) o;
		return Objects.equals(this.getId(), message.getId()) && Objects.equals(this.donation, message.donation);
	}

	@Override
	public int hashCode() {
		return Objects.hash(getId(), donation);
	}

	@Override
	public String toString() {
		// @formatter:off
		return "class Message {\n"
				+ "    id: " + toIndentedString(getId()) + "\n"
				+ "    donationId: " + toIndentedString(donation.getId()) + "\n"
				+ "    message: " + toIndentedString(message) + "\n"
				+ "    createdAt: " + toIndentedString(getCreatedAt()) + "\n"
				+ "}";
		// @formatter:on
	}

}

package org.upLift.model;

import com.fasterxml.jackson.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import org.springframework.validation.annotation.Validated;
import org.upLift.configuration.NotUndefined;

import java.io.Serializable;
import java.time.Instant;
import java.util.Objects;

/**
 * Donation entity class that links donor to recipient, with amount and donation date.
 * Comparable implementation sorts in reverse order by donation date, with most recent
 * donation first.
 */
@Validated
@NotUndefined
@jakarta.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen",
		date = "2025-03-16T14:18:35.909799305Z[GMT]")
@Entity
@Table(name = "donations")
public class Donation extends AbstractCreatedEntity implements Comparable<Donation>, Serializable {

	// For some endpoints we want the full Donor object and for others we want the full
	// Recipient, so
	// just mark the properties as @JsonIgnore and set up getters/setters as needed
	public Donation id(Integer id) {
		return (Donation) super.id(id);
	}

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "donor_id", referencedColumnName = "id", nullable = false)
	@JsonIgnore
	private Donor donor;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "recipient_id", referencedColumnName = "id", nullable = false)
	@JsonIgnore
	private Recipient recipient;

	@Column(name = "amount", nullable = false)
	@JsonProperty("amount")
	private Integer amount = null;

	@OneToOne(cascade = CascadeType.ALL, orphanRemoval = true, mappedBy = "donation")
	@JsonProperty("thank_you_message")
	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	private Message thankYouMessage;

	public Donation createdAt(Instant createdAt) {
		return (Donation) super.createdAt(createdAt);
	}

	public Donation donor(Donor donor) {
		this.donor = donor;
		return this;
	}

	/**
	 * Get donorId
	 * @return donorId
	 **/

	@Schema(example = "101", requiredMode = Schema.RequiredMode.REQUIRED,
			description = "persistence index of the donor who gave this donation")

	@JsonView(UpliftJsonViews.FullRecipient.class)
	@JsonGetter("donor_id")
	public Integer getDonorId() {
		return donor.getId();
	}

	@JsonSetter("donor_id")
	public void setDonorId(Integer donorId) {
		this.donor = new Donor().id(donorId);
	}

	@Schema(implementation = Donor.class, description = "full object for the donor who gave this donation")

	@JsonView(UpliftJsonViews.FullDonor.class)
	@JsonGetter("donor")
	public Donor getDonor() {
		return donor;
	}

	public void setDonor(Donor donor) {
		this.donor = donor;
	}

	public Donation recipient(Recipient recipient) {

		this.recipient = recipient;
		return this;
	}

	/**
	 * Get recipientId
	 * @return recipientId
	 **/

	@Schema(example = "202", requiredMode = Schema.RequiredMode.REQUIRED,
			description = "persistence index of the recipient who received this donation")

	@JsonView(UpliftJsonViews.FullDonor.class)
	@JsonGetter("recipient_id")
	public Integer getRecipientId() {
		return recipient.getId();
	}

	@JsonSetter("recipient_id")
	public void setRecipientId(Integer recipientId) {
		this.recipient = new Recipient().id(recipientId);
	}

	@Schema(implementation = Recipient.class, description = "full object for the recipient who received this donation")

	@JsonView(UpliftJsonViews.FullRecipient.class)
	@JsonGetter("recipient")
	public Recipient getRecipient() {
		return recipient;
	}

	public void setRecipient(Recipient recipient) {
		this.recipient = recipient;
	}

	public Donation amount(Integer amount) {

		this.amount = amount;
		return this;
	}

	/**
	 * Get amount
	 * @return amount
	 **/

	@Schema(example = "1000", requiredMode = Schema.RequiredMode.REQUIRED,
			description = "amount (in cents) of the donation")

	@NotNull
	public Integer getAmount() {
		return amount;
	}

	public void setAmount(Integer amount) {

		this.amount = amount;
	}

	@Schema(implementation = Message.class,
			description = "holds the thank-you message from the recipient to the donor, if any")

	public Message getThankYouMessage() {
		return thankYouMessage;
	}

	public void setThankYouMessage(Message thankYouMessage) {
		this.thankYouMessage = thankYouMessage;
	}

	@Override
	public boolean equals(Object o) {
		if (this == o) {
			return true;
		}
		if (o == null || getClass() != o.getClass()) {
			return false;
		}
		Donation donation = (Donation) o;
		return Objects.equals(this.getId(), donation.getId()) && Objects.equals(this.donor, donation.donor)
				&& Objects.equals(this.recipient, donation.recipient) && Objects.equals(this.amount, donation.amount);
	}

	@Override
	public int hashCode() {
		return Objects.hash(getId(), donor, recipient, amount);
	}

	@Override
	public String toString() {

		String sb = "class Donation {\n" + "    id: " + toIndentedString(getId()) + "\n" + "    donorId: "
				+ toIndentedString(donor.getId()) + "\n" + "    recipientId: " + toIndentedString(recipient.getId())
				+ "\n" + "    amount: " + toIndentedString(amount) + "\n" + "}";
		return sb;
	}

	@Override
	public int compareTo(Donation o) {
		return o.getCreatedAt().compareTo(this.getCreatedAt());
	}

}

package org.upLift.model;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.ArrayList;
import java.util.List;

/***
 * This class represents the tremendous order body request. See json for example: {
 * "payment": { "funding_source_id": "BALANCE" }, "reward": { "value": { "denomination":
 * 50, "currency_code": "USD" }, "delivery": { "method": "EMAIL" }, "recipient": { "name":
 * "Jane Doe", "email": "recipient@example.com" }, "products": [ "N9QEV7YC3HLK" ] } }
 */
public class TremendousOrderRequest {

	public TremendousOrderRequest(User recipient, int donation_amount) {
		reward = new Reward(
				recipient.getRecipientData().getFirstName() + " " + recipient.getRecipientData().getLastName(),
				recipient.getEmail(), donation_amount);

	}

	private Payment payment = new Payment(); // Payment is set by an env variable but for
												// the POC will always be "BALANCE"

	private Reward reward;

	// Getters and Setters
	public Payment getPayment() {
		return payment;
	}

	public void setPayment(Payment payment) {
		this.payment = payment;
	}

	public Reward getReward() {
		return reward;
	}

	public void setReward(Reward reward) {
		this.reward = reward;
	}

	// Inner Classes
	public static class Payment {

		@JsonProperty("funding_source_id")
		private final String funding_source_id = System.getenv("FUNDING_SOURCE_ID");

		@JsonProperty("funding_source_id")
		public String getFundingSourceId() {
			return funding_source_id;
		}

	}

	public static class Reward {

		public Reward(String recipientName, String recipientEmail, int donationAmount) {
			recipient = new RecipientInner();
			recipient.setName(recipientName);
			recipient.setEmail(recipientEmail);

			value = new Value();
			value.setDenomination(donationAmount);
		}

		private Value value;

		// Delivery is static and thus pre-initialized
		private Delivery delivery = new Delivery();

		private RecipientInner recipient;

		// This is a final array list of the Instacart product code. We're only supporting
		// this reward in our system thus making it a final attribute.
		private final List<String> products = new ArrayList<>(List.of("N9QEV7YC3HLK"));

		public Value getValue() {
			return value;
		}

		public void setValue(Value value) {
			this.value = value;
		}

		public Delivery getDelivery() {
			return delivery;
		}

		public void setDelivery(Delivery delivery) {
			this.delivery = delivery;
		}

		public RecipientInner getRecipient() {
			return recipient;
		}

		public void setRecipient(RecipientInner recipient) {
			this.recipient = recipient;
		}

		public List<String> getProducts() {
			return products;
		}

	}

	public static class Value {

		private int denomination;

		private final String currencyCode = "USD"; // Final String as we're only
													// supporting USD.

		public int getDenomination() {
			return denomination;
		}

		public void setDenomination(int denomination) {
			this.denomination = denomination;
		}

		public String getCurrencyCode() {
			return currencyCode;
		}

	}

	public static class Delivery {

		private final String method = "EMAIL"; // Final String for email as this will be
												// the only currently supported method.

		private final Meta meta = new Meta();

		public static class Meta {

			@JsonProperty("subject_line")
			private final String subject_line = "A donor has sent you a gift!";

			private final String message = "A very special gift to help you with groceries.";

			@JsonProperty("from_name")
			private final String from_name = "A humble donor.";

			@JsonProperty("subject_line")
			public String getSubject_line() {
				return subject_line;
			}

			public String getMessage() {
				return message;
			}

			@JsonProperty("from_name")
			public String getFrom_name() {
				return from_name;
			}

		}

		public String getMethod() {
			return method;
		}

		public Meta getMeta() {
			return meta;
		}

	}

	public static class RecipientInner {

		private String name;

		private String email;

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		public String getEmail() {
			return email;
		}

		public void setEmail(String email) {
			this.email = email;
		}

	}

}

package org.upLift.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonUnwrapped;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;

import java.io.Serializable;
import java.time.Instant;
import java.util.Objects;

@Entity
@Table(name = "recipient_tags")
@IdClass(RecipientTag.RecipientTagId.class)
public class RecipientTag implements Comparable<RecipientTag>, Serializable {

	@Id
	@Column(name = "recipient_id")
	@JsonIgnore
	private Integer recipientId;

	@Id
	@Column(name = "tag_name")
	@JsonIgnore
	private String tagName;

	@Column(name = "weight")
	@JsonProperty("weight")
	private double weight;

	@Column(name = "added_at", nullable = false)
	@JsonProperty("added_at")
	private Instant addedAt;

	@ManyToOne
	@PrimaryKeyJoinColumn(name = "recipient_id", referencedColumnName = "id")
	@JsonIgnore
	private Recipient recipient;

	@ManyToOne
	@PrimaryKeyJoinColumn(name = "tag_name", referencedColumnName = "tag_name")
	// Unwrap the tag into this object for easier use on the front end
	@JsonUnwrapped
	private Tag tag;

	public RecipientTag() {
		addedAt = Instant.now();
	}

	public Integer getRecipientId() {
		return recipientId;
	}

	public void setRecipientId(Integer recipientId) {
		this.recipientId = recipientId;
	}

	public String getTagName() {
		return tagName;
	}

	public void setTagName(String tagName) {
		this.tagName = tagName;
	}

	@Schema(example = "0.587", description = "relevance weight of the tag for the recipient, 0-1")

	public double getWeight() {
		return weight;
	}

	public void setWeight(double weight) {
		this.weight = weight;
	}

	@Schema(example = "2025-03-22T18:57:23.571Z", description = "date/time the tag was last linked with the recipient")

	public Instant getAddedAt() {
		return addedAt;
	}

	public void setAddedAt(Instant addedAt) {
		this.addedAt = addedAt;
	}

	public Recipient getRecipient() {
		return recipient;
	}

	public void setRecipient(Recipient recipient) {
		this.recipient = recipient;
	}

	@Schema(implementation = Tag.class, description = "tag linked to the recipient")

	public Tag getTag() {
		return tag;
	}

	public void setTag(Tag tag) {
		this.tag = tag;
	}

	@Override
	public int compareTo(RecipientTag o) {
		return tag.compareTo(o.getTag());
	}

	@Override
	public boolean equals(Object o) {
		if (o == null || getClass() != o.getClass()) return false;
		RecipientTag that = (RecipientTag) o;
		return Objects.equals(recipientId, that.recipientId) && Objects.equals(tagName, that.tagName);
	}

	@Override
	public int hashCode() {
		return Objects.hash(recipientId, tagName);
	}

	/**
	 * Class used for the composite primary key.
	 */
	public static class RecipientTagId implements Serializable {
		private Integer recipientId;
		private String tagName;

		public RecipientTagId(Integer recipientId, String tagName) {
			this.recipientId = recipientId;
			this.tagName = tagName;
		}

		public Integer getRecipientId() {
			return recipientId;
		}

		public void setRecipientId(Integer recipientId) {
			this.recipientId = recipientId;
		}

		public String getTagName() {
			return tagName;
		}

		public void setTagName(String tagName) {
			this.tagName = tagName;
		}

		@Override
		public boolean equals(Object o) {
			if (o == null || getClass() != o.getClass()) return false;
			RecipientTagId that = (RecipientTagId) o;
			return Objects.equals(recipientId, that.recipientId) && Objects.equals(tagName, that.tagName);
		}

		@Override
		public int hashCode() {
			return Objects.hash(recipientId, tagName);
		}
	}

}

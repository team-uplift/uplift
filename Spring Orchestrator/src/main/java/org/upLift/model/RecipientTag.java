package org.upLift.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonUnwrapped;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;

import java.io.Serializable;
import java.time.Instant;
import java.util.Objects;

@Entity
@Table(name = "recipient_tags",
		uniqueConstraints = { @UniqueConstraint(name = "UQ_recipient_tags_recipient_id_tag_name",
				columnNames = { "recipient_id", "tag_name" }) })
public class RecipientTag extends AbstractEntity implements Comparable<RecipientTag>, Serializable {

	@Column(name = "weight")
	@JsonProperty("weight")
	private double weight;

	@Column(name = "added_at", nullable = false)
	@JsonProperty("addedAt")
	private Instant addedAt;

	@Column(name = "selected", nullable = false)
	@JsonProperty("selected")
	private boolean selected;

	@ManyToOne(optional = false)
	// Even though none of the documentation includes this @JoinColumn, it's necessary
	// because
	// Hibernate/Spring ignore the @Column annotation on the RecipientTagId properties
	@JoinColumn(name = "recipient_id", referencedColumnName = "id")
	@JsonBackReference
	private Recipient recipient;

	@ManyToOne(optional = false)
	// Even though none of the documentation includes this @JoinColumn, it's necessary
	// because
	// Hibernate/Spring ignore the @Column annotation on the RecipientTagId properties
	@JoinColumn(name = "tag_name", referencedColumnName = "tag_name")
	// Unwrap the tag into this object for easier use on the front end and easier
	// deserialization when
	// saving selected/deselected tags
	@JsonUnwrapped
	private Tag tag;

	public RecipientTag() {
		addedAt = Instant.now();
	}

	public RecipientTag id(Integer id) {
		this.setId(id);
		return this;
	}

	// Mark as @JsonIgnore to avoid having issues with duplicate JSON properties
	@JsonIgnore
	public String getTagName() {
		return tag.getTagName();
	}

	public RecipientTag weight(double weight) {
		this.weight = weight;
		return this;
	}

	@Schema(example = "0.587", description = "relevance weight of the tag for the recipient, 0-1")

	public double getWeight() {
		return weight;
	}

	public void setWeight(double weight) {
		this.weight = weight;
	}

	public RecipientTag selected(boolean selected) {
		this.selected = selected;
		return this;
	}

	@Schema(example = "true", description = "indicates whether recipient has selected this tag for display")

	public boolean isSelected() {
		return selected;
	}

	public void setSelected(boolean selected) {
		this.selected = selected;
	}

	public RecipientTag addedAt(Instant addedAt) {
		this.addedAt = addedAt;
		return this;
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
		return getTagName().compareTo(o.getTagName());
	}

	@Override
	public boolean equals(Object o) {
		if (o == null || getClass() != o.getClass())
			return false;
		RecipientTag that = (RecipientTag) o;
		return Objects.equals(tag, that.tag) && Objects.equals(recipient, that.recipient);
	}

	@Override
	public int hashCode() {
		return Objects.hash(tag, recipient);
	}

}

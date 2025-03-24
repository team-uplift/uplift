package org.upLift.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonSetter;
import com.fasterxml.jackson.annotation.Nulls;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import org.springframework.validation.annotation.Validated;
import org.upLift.configuration.NotUndefined;

import java.io.Serializable;
import java.time.Instant;
import java.util.Objects;

/**
 * Tag
 */
@Validated
@NotUndefined
@jakarta.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen",
		date = "2025-03-16T14:18:35.909799305Z[GMT]")
@Entity
@Table(name = "tags")
public class Tag extends AbstractCreatedAt implements Comparable<Tag>, Serializable {

	@Id
	@Column(name = "tag_name")
	@JsonProperty("tag_name")
	@JsonSetter(nulls = Nulls.FAIL) // FAIL setting if the value is null
	private String tagName = null;

	public Tag tagName(String tagName) {
		this.tagName = tagName;
		return this;
	}

	/**
	 * Get tagName
	 * @return tagName
	 **/

	@Schema(example = "Potato", description = "tag linked to one or more recipients")

	public String getTagName() {
		return tagName;
	}

	public void setTagName(String tagName) {
		this.tagName = tagName;
	}

	public Tag createdAt(Instant createdAt) {
		return (Tag) super.createdAt(createdAt);
	}

	@Override
	public boolean equals(java.lang.Object o) {
		if (this == o) {
			return true;
		}
		if (o == null || getClass() != o.getClass()) {
			return false;
		}
		Tag tag = (Tag) o;
		return Objects.equals(this.tagName, tag.tagName);
	}

	@Override
	public int hashCode() {
		return Objects.hash(tagName);
	}

	@Override
	public String toString() {
		// @formatter:off
		return "class Tag {\n"
				+ "    tagName: " + toIndentedString(tagName) + "\n"
				+ "}";
		// @formatter:on
	}

	@Override
	public int compareTo(Tag o) {
		return tagName.compareTo(o.tagName);
	}

}

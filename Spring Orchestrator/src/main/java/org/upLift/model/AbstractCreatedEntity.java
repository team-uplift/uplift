package org.upLift.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.Column;
import jakarta.persistence.MappedSuperclass;

import java.time.Instant;

/**
 * Base class for entity classes that use an auto-incremented Integer id and have a
 * created_at timestamp.
 */
@MappedSuperclass
public abstract class AbstractCreatedEntity extends AbstractEntity {

	@Column(name = "created_at")
	@JsonProperty("created_at")
	private Instant createdAt;

	public AbstractCreatedEntity() {
		initialize();
	}

	private void initialize() {
		createdAt = Instant.now();
	}

	public AbstractCreatedEntity createdAt(Instant createdAt) {
		this.createdAt = createdAt;
		return this;
	}

	/**
	 * Get createdAt
	 * @return createdAt
	 **/

	@Schema(example = "2024-03-15T10:00:00.000Z", description = "Date/time in UTC that the entity instance was created")

	public Instant getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Instant createdAt) {
		this.createdAt = createdAt;
	}

}

package org.upLift.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.Column;
import jakarta.persistence.EntityListeners;
import jakarta.persistence.MappedSuperclass;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.Instant;

/**
 * Base class for entity classes that use an auto-incremented Integer id and have a
 * created_at timestamp.
 */
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
public abstract class AbstractCreatedEntity extends AbstractEntity {

	@CreatedDate
	@Column(name = "created_at")
	@JsonProperty("createdAt")
	private Instant createdAt;

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

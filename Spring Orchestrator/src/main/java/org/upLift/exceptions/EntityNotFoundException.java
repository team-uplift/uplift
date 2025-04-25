package org.upLift.exceptions;

/**
 * Exception thrown when a request or service attempts to load, update, or delete an
 * entity that doesn't exist.
 */
public class EntityNotFoundException extends RuntimeException {

	private final int entityId;

	private final String entityType;

	public EntityNotFoundException(int entityId, String entityType, String message) {
		super(message);
		this.entityId = entityId;
		this.entityType = entityType;
	}

	public int getEntityId() {
		return entityId;
	}

	public String getEntityType() {
		return entityType;
	}

}

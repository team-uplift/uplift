package org.upLift.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import org.springframework.http.HttpStatus;

import java.time.Instant;

/**
 * Class that holds error response model classes, for easier grouping.
 */
public class ErrorResults {

	/**
	 * Generic error response, used for any type of error. Used as base class for more
	 * specialized error responses.
	 */
	public static class GeneralError {

		@JsonProperty("errorMessage")
		private final String errorMessage;

		@JsonProperty("status")
		private final int status;

		@JsonProperty("errorType")
		private final String errorType;

		@JsonProperty("timestamp")
		private final Instant timestamp;

		@JsonProperty("path")
		private String path;

		public GeneralError(String errorMessage, HttpStatus status) {
			this.errorMessage = errorMessage;
			this.status = status.value();
			this.errorType = status.getReasonPhrase();
			this.timestamp = Instant.now();
		}

		@Schema(example = "Example error message", description = "message describing the error")
		public String getErrorMessage() {
			return errorMessage;
		}

		@Schema(example = "400", description = "HTTP error status code")
		public int getStatus() {
			return status;
		}

		@Schema(example = "Bad Request", description = "name of the HTTP error type")
		public String getErrorType() {
			return errorType;
		}

		@Schema(example = "2025-04-24T02:12:42.548Z", description = "timestamp of the error")
		public Instant getTimestamp() {
			return timestamp;
		}

		@Schema(example = "/uplift/message", description = "path of the request that generated the error")
		public String getPath() {
			return path;
		}

		public GeneralError withPath(String path) {
			this.path = path;
			return this;
		}

		public void setPath(String path) {
			this.path = path;
		}

	}

	/**
	 * Error response used when the request is trying to load, update, or delete an entity
	 * that doesn't exist.
	 */
	public static class EntityNotFoundError extends GeneralError {

		@JsonProperty("notFoundEntityId")
		private final int notFoundEntityId;

		@JsonProperty("notFoundEntityType")
		private final String notFoundEntityType;

		public EntityNotFoundError(String errorMessage, int notFoundEntityId, String notFoundEntityType) {
			super(errorMessage, HttpStatus.NOT_FOUND);
			this.notFoundEntityId = notFoundEntityId;
			this.notFoundEntityType = notFoundEntityType;
		}

		@Schema(example = "24", description = "persistence index that doesn't exist")
		public int getNotFoundEntityId() {
			return notFoundEntityId;
		}

		@Schema(example = "recipient",
				description = "type of entity for which there's no entry matching the provided id")
		public String getNotFoundEntityType() {
			return notFoundEntityType;
		}

	}

}

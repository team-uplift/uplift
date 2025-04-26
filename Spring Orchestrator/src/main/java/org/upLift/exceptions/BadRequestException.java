package org.upLift.exceptions;

/**
 * Exception thrown when the request is incorrect, typically because some path variable or
 * query parameter is wrong or missing.
 */
public class BadRequestException extends RuntimeException {

	public BadRequestException(String message) {
		super(message);
	}

}

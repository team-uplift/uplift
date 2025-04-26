package org.upLift.api;

import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.upLift.exceptions.BadRequestException;
import org.upLift.exceptions.EntityNotFoundException;
import org.upLift.exceptions.ModelException;
import org.upLift.model.ErrorResults;

@RestControllerAdvice
public class GlobalExceptionHandler {

	private static final Logger LOG = LoggerFactory.getLogger(GlobalExceptionHandler.class);

	@ResponseStatus(HttpStatus.NOT_FOUND)
	@ResponseBody
	@ExceptionHandler(EntityNotFoundException.class)
	public ErrorResults.EntityNotFoundError handleNotFoundException(EntityNotFoundException ex,
			HttpServletRequest request) {
		LOG.error("{} entity not found: {}", ex.getEntityType(), ex.getEntityId(), ex);
		var error = new ErrorResults.EntityNotFoundError(ex.getMessage(), ex.getEntityId(), ex.getEntityType());
		error.setPath(request.getRequestURI());
		return error;
	}

	@ResponseStatus(HttpStatus.BAD_REQUEST)
	@ResponseBody
	@ExceptionHandler(ModelException.class)
	public ErrorResults.GeneralError handleModelException(ModelException ex, HttpServletRequest request) {
		LOG.error("Model exception", ex);
		return new ErrorResults.GeneralError(ex.getMessage(), HttpStatus.BAD_REQUEST).withPath(request.getRequestURI());
	}

	@ResponseStatus(HttpStatus.BAD_REQUEST)
	@ResponseBody
	@ExceptionHandler(BadRequestException.class)
	public ErrorResults.GeneralError handleBadRequestException(BadRequestException ex, HttpServletRequest request) {
		LOG.error("Model exception", ex);
		return new ErrorResults.GeneralError(ex.getMessage(), HttpStatus.BAD_REQUEST).withPath(request.getRequestURI());
	}

}

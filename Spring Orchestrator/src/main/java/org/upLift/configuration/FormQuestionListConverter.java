package org.upLift.configuration;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.upLift.model.FormQuestion;

import java.util.List;

@Component
@Converter(autoApply = true)
public class FormQuestionListConverter implements AttributeConverter<List<FormQuestion>, String> {

	private static final Logger LOG = LoggerFactory.getLogger(FormQuestionListConverter.class);

	private final ObjectMapper mapper;

	@Autowired
	public FormQuestionListConverter(ObjectMapper mapper) {
		this.mapper = mapper;
	}

	@Override
	public String convertToDatabaseColumn(List<FormQuestion> attribute) {
		try {
			return mapper.writeValueAsString(attribute);
		} catch (JsonProcessingException e) {
			LOG.error("Error serializing form question list to String", e);
			throw new RuntimeException(e);
		}
	}

	@Override
	public List<FormQuestion> convertToEntityAttribute(String dbData) {
		var typeRef = new TypeReference<List<FormQuestion>>() {};
		try {
			return mapper.readValue(dbData, typeRef);
		} catch (JsonProcessingException e) {
			LOG.error("Error converting database column to FormQuestion list", e);
			throw new RuntimeException(e);
		}
	}
}

package org.upLift.model;

import java.util.Objects;
import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import org.threeten.bp.OffsetDateTime;
import org.springframework.validation.annotation.Validated;
import org.upLift.configuration.NotUndefined;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonSetter;
import com.fasterxml.jackson.annotation.Nulls;
import javax.validation.Valid;

/**
 * HistoricalRecipientPrompt
 */
@Validated
@NotUndefined
@javax.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen", date = "2025-03-16T14:18:35.909799305Z[GMT]")


public class HistoricalRecipientPrompt   {
  @JsonProperty("id")

  @JsonInclude(JsonInclude.Include.NON_ABSENT)  // Exclude from JSON if absent
  @JsonSetter(nulls = Nulls.FAIL)    // FAIL setting if the value is null
  private Integer id = null;

  @JsonProperty("recipient_id")

  @JsonInclude(JsonInclude.Include.NON_ABSENT)  // Exclude from JSON if absent
  @JsonSetter(nulls = Nulls.FAIL)    // FAIL setting if the value is null
  private Integer recipientId = null;

  @JsonProperty("prompt")

  @JsonInclude(JsonInclude.Include.NON_ABSENT)  // Exclude from JSON if absent
  @JsonSetter(nulls = Nulls.FAIL)    // FAIL setting if the value is null
  private String prompt = null;

  @JsonProperty("created_at")

  @JsonInclude(JsonInclude.Include.NON_ABSENT)  // Exclude from JSON if absent
  @JsonSetter(nulls = Nulls.FAIL)    // FAIL setting if the value is null
  private OffsetDateTime createdAt = null;


  public HistoricalRecipientPrompt id(Integer id) { 

    this.id = id;
    return this;
  }

  /**
   * Get id
   * @return id
   **/
  
  @Schema(example = "1", description = "")
  
  public Integer getId() {  
    return id;
  }



  public void setId(Integer id) { 
    this.id = id;
  }

  public HistoricalRecipientPrompt recipientId(Integer recipientId) { 

    this.recipientId = recipientId;
    return this;
  }

  /**
   * Get recipientId
   * @return recipientId
   **/
  
  @Schema(example = "202", description = "")
  
  public Integer getRecipientId() {  
    return recipientId;
  }



  public void setRecipientId(Integer recipientId) { 
    this.recipientId = recipientId;
  }

  public HistoricalRecipientPrompt prompt(String prompt) { 

    this.prompt = prompt;
    return this;
  }

  /**
   * Get prompt
   * @return prompt
   **/
  
  @Schema(example = "Requesting food assistance", description = "")
  
  public String getPrompt() {  
    return prompt;
  }



  public void setPrompt(String prompt) { 
    this.prompt = prompt;
  }

  public HistoricalRecipientPrompt createdAt(OffsetDateTime createdAt) { 

    this.createdAt = createdAt;
    return this;
  }

  /**
   * Get createdAt
   * @return createdAt
   **/
  
  @Schema(example = "2024-03-15T10:00Z", description = "")
  
@Valid
  public OffsetDateTime getCreatedAt() {  
    return createdAt;
  }



  public void setCreatedAt(OffsetDateTime createdAt) { 
    this.createdAt = createdAt;
  }

  @Override
  public boolean equals(java.lang.Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    HistoricalRecipientPrompt historicalRecipientPrompt = (HistoricalRecipientPrompt) o;
    return Objects.equals(this.id, historicalRecipientPrompt.id) &&
        Objects.equals(this.recipientId, historicalRecipientPrompt.recipientId) &&
        Objects.equals(this.prompt, historicalRecipientPrompt.prompt) &&
        Objects.equals(this.createdAt, historicalRecipientPrompt.createdAt);
  }

  @Override
  public int hashCode() {
    return Objects.hash(id, recipientId, prompt, createdAt);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class HistoricalRecipientPrompt {\n");
    
    sb.append("    id: ").append(toIndentedString(id)).append("\n");
    sb.append("    recipientId: ").append(toIndentedString(recipientId)).append("\n");
    sb.append("    prompt: ").append(toIndentedString(prompt)).append("\n");
    sb.append("    createdAt: ").append(toIndentedString(createdAt)).append("\n");
    sb.append("}");
    return sb.toString();
  }

  /**
   * Convert the given object to string with each line indented by 4 spaces
   * (except the first line).
   */
  private String toIndentedString(java.lang.Object o) {
    if (o == null) {
      return "null";
    }
    return o.toString().replace("\n", "\n    ");
  }
}

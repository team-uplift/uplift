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
import jakarta.validation.Valid;

/**
 * HistoricalDonorPrompt
 */
@Validated
@NotUndefined
@jakarta.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen", date = "2025-03-16T14:18:35.909799305Z[GMT]")


public class HistoricalDonorPrompt   {
  @JsonProperty("id")

  @JsonInclude(JsonInclude.Include.NON_ABSENT)  // Exclude from JSON if absent
  @JsonSetter(nulls = Nulls.FAIL)    // FAIL setting if the value is null
  private Integer id = null;

  @JsonProperty("donor_id")

  @JsonInclude(JsonInclude.Include.NON_ABSENT)  // Exclude from JSON if absent
  @JsonSetter(nulls = Nulls.FAIL)    // FAIL setting if the value is null
  private Integer donorId = null;

  @JsonProperty("prompt")

  @JsonInclude(JsonInclude.Include.NON_ABSENT)  // Exclude from JSON if absent
  @JsonSetter(nulls = Nulls.FAIL)    // FAIL setting if the value is null
  private String prompt = null;

  @JsonProperty("created_at")

  @JsonInclude(JsonInclude.Include.NON_ABSENT)  // Exclude from JSON if absent
  @JsonSetter(nulls = Nulls.FAIL)    // FAIL setting if the value is null
  private OffsetDateTime createdAt = null;


  public HistoricalDonorPrompt id(Integer id) { 

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

  public HistoricalDonorPrompt donorId(Integer donorId) { 

    this.donorId = donorId;
    return this;
  }

  /**
   * Get donorId
   * @return donorId
   **/
  
  @Schema(example = "101", description = "")
  
  public Integer getDonorId() {  
    return donorId;
  }



  public void setDonorId(Integer donorId) { 
    this.donorId = donorId;
  }

  public HistoricalDonorPrompt prompt(String prompt) { 

    this.prompt = prompt;
    return this;
  }

  /**
   * Get prompt
   * @return prompt
   **/
  
  @Schema(example = "Willing to donate clothes", description = "")
  
  public String getPrompt() {  
    return prompt;
  }



  public void setPrompt(String prompt) { 
    this.prompt = prompt;
  }

  public HistoricalDonorPrompt createdAt(OffsetDateTime createdAt) { 

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
    HistoricalDonorPrompt historicalDonorPrompt = (HistoricalDonorPrompt) o;
    return Objects.equals(this.id, historicalDonorPrompt.id) &&
        Objects.equals(this.donorId, historicalDonorPrompt.donorId) &&
        Objects.equals(this.prompt, historicalDonorPrompt.prompt) &&
        Objects.equals(this.createdAt, historicalDonorPrompt.createdAt);
  }

  @Override
  public int hashCode() {
    return Objects.hash(id, donorId, prompt, createdAt);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class HistoricalDonorPrompt {\n");
    
    sb.append("    id: ").append(toIndentedString(id)).append("\n");
    sb.append("    donorId: ").append(toIndentedString(donorId)).append("\n");
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

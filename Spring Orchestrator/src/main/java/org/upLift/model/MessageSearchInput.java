package org.upLift.model;

import java.util.Objects;
import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import org.springframework.validation.annotation.Validated;
import org.upLift.configuration.NotUndefined;

import javax.validation.constraints.*;

/**
 * MessageSearchInput
 */
@Validated
@NotUndefined
@javax.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen", date = "2025-03-16T14:18:35.909799305Z[GMT]")


public class MessageSearchInput   {
  @JsonProperty("donor_id")

  private Integer donorId = null;

  @JsonProperty("recipient_id")

  private Integer recipientId = null;


  public MessageSearchInput donorId(Integer donorId) { 

    this.donorId = donorId;
    return this;
  }

  /**
   * Get donorId
   * @return donorId
   **/
  
  @Schema(example = "101", required = true, description = "")
  
  @NotNull
  public Integer getDonorId() {  
    return donorId;
  }



  public void setDonorId(Integer donorId) { 

    this.donorId = donorId;
  }

  public MessageSearchInput recipientId(Integer recipientId) { 

    this.recipientId = recipientId;
    return this;
  }

  /**
   * Get recipientId
   * @return recipientId
   **/
  
  @Schema(example = "202", required = true, description = "")
  
  @NotNull
  public Integer getRecipientId() {  
    return recipientId;
  }



  public void setRecipientId(Integer recipientId) { 

    this.recipientId = recipientId;
  }

  @Override
  public boolean equals(java.lang.Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    MessageSearchInput messageSearchInput = (MessageSearchInput) o;
    return Objects.equals(this.donorId, messageSearchInput.donorId) &&
        Objects.equals(this.recipientId, messageSearchInput.recipientId);
  }

  @Override
  public int hashCode() {
    return Objects.hash(donorId, recipientId);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class MessageSearchInput {\n");
    
    sb.append("    donorId: ").append(toIndentedString(donorId)).append("\n");
    sb.append("    recipientId: ").append(toIndentedString(recipientId)).append("\n");
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

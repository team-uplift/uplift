package org.upLift.model;

import java.util.Objects;
import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import org.springframework.validation.annotation.Validated;
import org.upLift.configuration.NotUndefined;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonSetter;
import com.fasterxml.jackson.annotation.Nulls;

import javax.validation.constraints.*;

/**
 * Donation
 */
@Validated
@NotUndefined
@javax.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen", date = "2025-03-16T14:18:35.909799305Z[GMT]")


public class Donation   {
  @JsonProperty("id")

  private Integer id = null;

  @JsonProperty("donor_id")

  @JsonInclude(JsonInclude.Include.NON_ABSENT)  // Exclude from JSON if absent
  @JsonSetter(nulls = Nulls.FAIL)    // FAIL setting if the value is null
  private Integer donorId = null;

  @JsonProperty("recipient_id")

  @JsonInclude(JsonInclude.Include.NON_ABSENT)  // Exclude from JSON if absent
  @JsonSetter(nulls = Nulls.FAIL)    // FAIL setting if the value is null
  private Integer recipientId = null;

  @JsonProperty("amount")

  private Integer amount = null;


  public Donation id(Integer id) { 

    this.id = id;
    return this;
  }

  /**
   * Get id
   * @return id
   **/
  
  @Schema(example = "1", required = true, description = "")
  
  @NotNull
  public Integer getId() {  
    return id;
  }



  public void setId(Integer id) { 

    this.id = id;
  }

  public Donation donorId(Integer donorId) { 

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

  public Donation recipientId(Integer recipientId) { 

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

  public Donation amount(Integer amount) { 

    this.amount = amount;
    return this;
  }

  /**
   * Get amount
   * @return amount
   **/
  
  @Schema(example = "500", required = true, description = "")
  
  @NotNull
  public Integer getAmount() {  
    return amount;
  }



  public void setAmount(Integer amount) { 

    this.amount = amount;
  }

  @Override
  public boolean equals(java.lang.Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    Donation donation = (Donation) o;
    return Objects.equals(this.id, donation.id) &&
        Objects.equals(this.donorId, donation.donorId) &&
        Objects.equals(this.recipientId, donation.recipientId) &&
        Objects.equals(this.amount, donation.amount);
  }

  @Override
  public int hashCode() {
    return Objects.hash(id, donorId, recipientId, amount);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class Donation {\n");
    
    sb.append("    id: ").append(toIndentedString(id)).append("\n");
    sb.append("    donorId: ").append(toIndentedString(donorId)).append("\n");
    sb.append("    recipientId: ").append(toIndentedString(recipientId)).append("\n");
    sb.append("    amount: ").append(toIndentedString(amount)).append("\n");
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

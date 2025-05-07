package org.upLift.model;

import com.fasterxml.jackson.annotation.JsonGetter;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonSetter;
import com.fasterxml.jackson.annotation.Nulls;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import org.springframework.validation.annotation.Validated;
import org.upLift.configuration.NotUndefined;

import java.util.Objects;

/**
 * Note that this class is currently unused - it was added as part of a plan to track donor metadata
 * which hasn't yet been implemented.
 */
@Validated
@NotUndefined
@Entity
@Table(name = "donor_sessions")
public class DonorSession extends AbstractCreatedEntity {

	@ManyToOne
	@JoinColumn(name = "donor_id", nullable = false, referencedColumnName = "id")
	@JsonIgnore
	private Donor donor;

	public DonorSession id(Integer id) {
		setId(id);
		return this;
	}

	public DonorSession donor(Donor donor) {
		setDonor(donor);
		return this;
	}

	public Donor getDonor() {
		return donor;
	}

	public void setDonor(Donor donor) {
		this.donor = donor;
	}

	@Schema(example = "101", description = "persistence index of the donor to whom this session is linked")

	@JsonGetter("donorId")
	public Integer getDonorId() {
		return donor.getId();
	}

	@JsonSetter(value = "donorId", nulls = Nulls.FAIL) // FAIL setting if the value is
														// null
	public void setDonorId(Integer donorId) {
		this.donor = new Donor().id(donorId);
	}

	@Override
	public boolean equals(Object o) {
		if (o == null || getClass() != o.getClass())
			return false;
		DonorSession that = (DonorSession) o;
		return Objects.equals(donor, that.donor) && Objects.equals(getCreatedAt(), that.getCreatedAt());
	}

	@Override
	public int hashCode() {
		return Objects.hash(donor, getCreatedAt());
	}

	@Override
	public String toString() {
		// @formatter:off
		return "class DonorSession {\n"
				+ "    id: " + toIndentedString(getId()) + "\n"
				+ "    donorId: " + toIndentedString(donor.getId()) + "\n"
				+ "    sessionStarted: " + toIndentedString(getCreatedAt()) + "\n"
				+ "}";
		// @formatter:on
	}

}

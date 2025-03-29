package org.upLift.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import org.springframework.validation.annotation.Validated;
import org.upLift.configuration.NotUndefined;

import java.util.Objects;

/**
 * Donor
 */
@Validated
@NotUndefined
@jakarta.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen",
		date = "2025-03-16T14:18:35.909799305Z[GMT]")
@Entity
@Table(name = "donors")
public class Donor extends AbstractCreatedAt {

	@OneToOne
	@MapsId
	@JoinColumn(name = "id", referencedColumnName = "id")
	@JsonIgnore
	private User user;

	@Id
	@Column(name = "id")
	@JsonProperty("id")
	private Integer id = null;

	@JsonProperty("nickname")
	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	private String nickname = null;

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public Donor id(Integer id) {
		this.id = id;
		return this;
	}

	/**
	 * Get id
	 * @return id
	 **/
	@Schema(example = "1", description = "persistence index of the entity")
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Donor nickname(String nickname) {
		this.nickname = nickname;
		return this;
	}

	/**
	 * Get nickname
	 * @return nickname
	 **/

	@Schema(example = "PotatoKing", description = "")

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	@Override
	public boolean equals(Object o) {
		if (this == o) {
			return true;
		}
		if (o == null || getClass() != o.getClass()) {
			return false;
		}
		Donor donor = (Donor) o;
		return Objects.equals(this.getId(), donor.getId()) && Objects.equals(this.user, donor.user);
	}

	@Override
	public int hashCode() {
		return Objects.hash(getId(), user);
	}

	@Override
	public String toString() {
		// @formatter:off
		return "class Donor {\n"
				+ "    id: " + toIndentedString(getId()) + "\n"
//				+ "    user: " + toIndentedString(user.toString()) + "\n"
				+ "    nickname: " + toIndentedString(nickname) + "\n"
				+ "    createdAt: " + toIndentedString(getCreatedAt()) + "\n"
				+ "}";
		// @formatter:on
	}

}

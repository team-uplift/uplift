package org.upLift.model;

import com.fasterxml.jackson.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import jakarta.validation.Valid;
import org.springframework.validation.annotation.Validated;
import org.upLift.configuration.NotUndefined;

import java.time.Instant;
import java.util.List;
import java.util.Objects;
import java.util.SortedSet;
import java.util.TreeSet;

/**
 * Recipient
 */
@SuppressWarnings("unused")
@Validated
@NotUndefined
@jakarta.annotation.Generated(value = "io.swagger.codegen.v3.generators.java.SpringCodegen",
		date = "2025-03-16T14:18:35.909799305Z[GMT]")
@Entity
@Table(name = "recipients")
public class Recipient extends AbstractCreatedAt {

	@OneToOne
	@MapsId
	@JoinColumn(name = "id", referencedColumnName = "id")
	@JsonIgnore
	private User user;

	@Id
	@Column(name = "id")
	@JsonProperty("id")
	private Integer id;

	@Column(name = "first_name")
	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	@JsonProperty("first_name")
	private String firstName;

	@Column(name = "last_name")
	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	@JsonProperty("last_name")
	private String lastName;

	@Column(name = "street_address1")
	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	@JsonProperty("street_address1")
	private String streetAddress1;

	@Column(name = "street_address2")
	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	@JsonProperty("street_address2")
	private String streetAddress2;

	@Column(name = "city")
	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	@JsonProperty("city")
	private String city;

	@Column(name = "state")
	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	@JsonProperty("state")
	private String state;

	@Column(name = "image_url")
	@JsonInclude(JsonInclude.Include.NON_ABSENT)
	@JsonProperty("image_url")
	private String imageUrl;

	@Column(name = "last_about_me")
	@JsonProperty("last_about_me")
	@JsonSetter(nulls = Nulls.FAIL) // FAIL setting if the value is null
	private String lastAboutMe;

	@Column(name = "last_reason_for_help")
	@JsonProperty("last_reason_for_help")
	@JsonSetter(nulls = Nulls.FAIL) // FAIL setting if the value is null
	private String lastReasonForHelp;

	@SuppressWarnings("JpaAttributeTypeInspection")
	@Column(name = "form_questions")
	@JsonProperty("form_questions")
	@JsonSetter(nulls = Nulls.FAIL) // FAIL setting if the value is null
	private List<FormQuestion> formQuestions;

	@Column(name = "identity_last_verified")
	@JsonProperty("identity_last_verified")
	private Instant identityLastVerified;

	@Column(name = "income_last_verified")
	@JsonProperty("income_last_verified")
	private Instant incomeLastVerified;

	@JsonProperty("nickname")
	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	private String nickname = null;

	@Valid
	@OneToMany(mappedBy = "recipient", fetch = FetchType.EAGER)
	@JsonProperty("tags")
	@JsonManagedReference
	private SortedSet<RecipientTag> tags;

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public Recipient id(Integer id) {
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

	public Recipient firstName(String firstName) {
		this.firstName = firstName;
		return this;
	}

	@Schema(example = "Jane", description = "first name of the recipient")

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public Recipient lastName(String lastName) {
		this.lastName = lastName;
		return this;
	}

	@Schema(example = "Doe", description = "Last name of the recipient")

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public Recipient streetAddress1(String streetAddress1) {
		this.streetAddress1 = streetAddress1;
		return this;
	}

	@Schema(example = "123 Main St", description = "street address line 1 of the recipient")

	public String getStreetAddress1() {
		return streetAddress1;
	}

	public void setStreetAddress1(String streetAddress1) {
		this.streetAddress1 = streetAddress1;
	}

	public Recipient streetAddress2(String streetAddress2) {
		this.streetAddress2 = streetAddress2;
		return this;
	}

	@Schema(example = "Apt. 23", description = "street address line 2 of the recipient")

	public String getStreetAddress2() {
		return streetAddress2;
	}

	public void setStreetAddress2(String streetAddress2) {
		this.streetAddress2 = streetAddress2;
	}

	public Recipient city(String city) {
		this.city = city;
		return this;
	}

	@Schema(example = "Anytown", description = "city in which the recipient lives")

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public Recipient state(String state) {
		this.state = state;
		return this;
	}

	@Schema(example = "MA", description = "2-letter postal state code for the state in which the recipient lives")

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	@Schema(example = "https://image.com/image", description = "URL of the image linked to this recipient, if any")

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public Recipient lastAboutMe(String lastAboutMe) {

		this.lastAboutMe = lastAboutMe;
		return this;
	}

	/**
	 * Get lastProfileText
	 * @return lastProfileText
	 **/

	@Schema(example = "I like potatoes.", description = "text entered by the recipient to describe themselves")

	public String getLastAboutMe() {
		return lastAboutMe;
	}

	public void setLastAboutMe(String lastProfileText) {
		this.lastAboutMe = lastProfileText;
	}

	public Recipient lastReasonForHelp(String lastReasonForHelp) {
		this.lastReasonForHelp = lastReasonForHelp;
		return this;
	}

	@Schema(example = "I'm working while taking classes for my GED.",
			description = "text entered by the recipient describing why they need help")

	public String getLastReasonForHelp() {
		return lastReasonForHelp;
	}

	public void setLastReasonForHelp(String lastReasonForHelp) {
		this.lastReasonForHelp = lastReasonForHelp;
	}

	public Recipient identityLastVerified(String identityLastVerified) {
		this.identityLastVerified = Instant.parse(identityLastVerified);
		return this;
	}

	@Schema(example = "[{\"question\": \"What was your biggest challenge in the last six months?\", " +
			"\"answer\": \"Losing my job\"}]",
			description = "String containing JSON object grouping form questions and recipient answers")

	public List<FormQuestion> getFormQuestions() {
		return formQuestions;
	}

	public void setFormQuestions(List<FormQuestion> formQuestions) {
		this.formQuestions = formQuestions;
	}

	@Schema(example = "2025-03-22T18:57:23.571Z", description = "date/time the recipient's identity was last verified")

	public Instant getIdentityLastVerified() {
		return identityLastVerified;
	}

	public void setIdentityLastVerified(Instant identityLastVerified) {
		this.identityLastVerified = identityLastVerified;
	}

	public Recipient incomeVerified(Instant incomeLastVerified) {

		this.incomeLastVerified = incomeLastVerified;
		return this;
	}

	/**
	 * Get incomeVerified
	 * @return incomeVerified
	 **/

	@Schema(example = "2025-03-22T18:57:23.571Z", description = "date/time the recipient's income was last verified")

	public Instant getIncomeLastVerified() {
		return incomeLastVerified;
	}

	public void setIncomeLastVerified(Instant incomeLastVerified) {
		this.incomeLastVerified = incomeLastVerified;
	}

	public Recipient nickname(String nickname) {

		this.nickname = nickname;
		return this;
	}

	/**
	 * Get nickname
	 * @return nickname
	 **/

	@Schema(example = "PotatoKing", description = "nickname for the recipient, assigned when profile is created")

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public Recipient tags(SortedSet<RecipientTag> tags) {

		this.tags = tags;
		return this;
	}

	public Recipient addTagsItem(RecipientTag tagsItem) {
		if (this.tags == null) {
			this.tags = new TreeSet<>();
		}
		this.tags.add(tagsItem);
		return this;
	}

	/**
	 * Get tags
	 * @return tags
	 **/

	@Schema(implementation = RecipientTag.class, description = "tags linked to the recipient")

	@Valid
	public SortedSet<RecipientTag> getTags() {
		return tags;
	}

	public void setTags(SortedSet<RecipientTag> tags) {
		this.tags = tags;
	}

	@Override
	public boolean equals(java.lang.Object o) {
		if (this == o) {
			return true;
		}
		if (o == null || getClass() != o.getClass()) {
			return false;
		}
		Recipient recipient = (Recipient) o;
		return Objects.equals(this.getId(), recipient.getId()) && Objects.equals(this.user, recipient.user);
	}

	@Override
	public int hashCode() {
		return Objects.hash(getId(), user);
	}

	@Override
	public String toString() {
		// @formatter:off
		return "class Recipient {\n" +
				"    id: " + toIndentedString(getId()) + "\n" +
				"    user: " + toIndentedString(user.toString()) + "\n" +
				"    first name: " + toIndentedString(firstName) + "\n" +
				"    last name: " + toIndentedString(lastName) + "\n" +
				"    street address 1: " + toIndentedString(streetAddress1) + "\n" +
				"    street address 2: " + toIndentedString(streetAddress2) + "\n" +
				"    city: " + toIndentedString(city) + "\n" +
				"    state: " + toIndentedString(state) + "\n" +
				"    last about me: " + toIndentedString(lastAboutMe) + "\n" +
				"    last reason for help: " + toIndentedString(lastReasonForHelp) + "\n" +
				"    identityVerified: " + toIndentedString(identityLastVerified) + "\n" +
				"    incomeVerified: " + toIndentedString(incomeLastVerified) + "\n" +
				"    nickname: " + toIndentedString(nickname) + "\n" +
				"    created at: " + toIndentedString(getCreatedAt()) + "\n" +
				"    tags: " + toIndentedString(tags) + "\n" +
				"}";
		// @formatter:on
	}

}

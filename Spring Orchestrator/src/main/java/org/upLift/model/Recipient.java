package org.upLift.model;

import com.fasterxml.jackson.annotation.*;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import jakarta.validation.Valid;
import org.springframework.validation.annotation.Validated;
import org.upLift.configuration.NotUndefined;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Objects;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.stream.Collectors;

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

	// Number of days that a verification is considered "valid" before it has to be redone
	private static final int VERIFICATION_VALID_PERIOD = 365;

	@OneToOne(optional = false, fetch = FetchType.LAZY)
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
	@JsonProperty("firstName")
	private String firstName;

	@Column(name = "last_name")
	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	@JsonProperty("lastName")
	private String lastName;

	@Column(name = "street_address1")
	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	@JsonProperty("streetAddress1")
	private String streetAddress1;

	@Column(name = "street_address2")
	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	@JsonProperty("streetAddress2")
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
	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	@JsonProperty("imageUrl")
	private String imageUrl;

	@Column(name = "last_about_me")
	@JsonProperty("lastAboutMe")
	@JsonSetter(nulls = Nulls.FAIL) // FAIL setting if the value is null
	private String lastAboutMe;

	@Column(name = "last_reason_for_help")
	@JsonProperty("lastReasonForHelp")
	@JsonSetter(nulls = Nulls.FAIL) // FAIL setting if the value is null
	private String lastReasonForHelp;

	@SuppressWarnings("JpaAttributeTypeInspection")
	@Column(name = "form_questions")
	@JsonProperty("formQuestions")
	@JsonSetter(nulls = Nulls.FAIL) // FAIL setting if the value is null
	private List<FormQuestion> formQuestions;

	@Column(name = "identity_last_verified")
	@JsonProperty("identityLastVerified")
	private Instant identityLastVerified;

	@Column(name = "income_last_verified")
	@JsonProperty("incomeLastVerified")
	private Instant incomeLastVerified;

	@JsonProperty("nickname")
	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	private String nickname = null;

	@Column(name = "tags_last_generated_at")
	@JsonProperty("tagsLastGenerated")
	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	private Instant tagsLastGenerated;

	@Column(name = "last_donation_timestamp")
	@JsonInclude(JsonInclude.Include.NON_ABSENT) // Exclude from JSON if absent
	@JsonProperty("lastDonationTimestamp")
	private Instant lastDonationTimestamp;

	@Valid
	@OneToMany(mappedBy = "recipient", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
	// Only want to send the set of "selected" tags to the front end,
	// since only the back end cares about tracking the "unselected" tags
	@JsonIgnore
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

	@Schema(example = "[{\"question\": \"What was your biggest challenge in the last six months?\", "
			+ "\"answer\": \"Losing my job\"}]",
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

	@JsonIgnore
	public boolean isIncomeVerified() {
		if (incomeLastVerified == null) {
			return false;
		}
		Instant oneYearAgo = Instant.now().minus(VERIFICATION_VALID_PERIOD, ChronoUnit.DAYS);
		// Still considered valid if it's equal to "one year ago" - only invalid if it's
		// older
		return !incomeLastVerified.isBefore(oneYearAgo);
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

	public Recipient tagsLastGenerated(Instant tagsLastGenerated) {
		this.tagsLastGenerated = tagsLastGenerated;
		return this;
	}

	@Schema(example = "2025-03-22T18:57:23.571Z", description = "date/time the recipient's tags were last generated")

	public Instant getTagsLastGenerated() {
		return tagsLastGenerated;
	}

	public void setTagsLastGenerated(Instant tagsLastGenerated) {
		this.tagsLastGenerated = tagsLastGenerated;
	}

	public Recipient tags(SortedSet<RecipientTag> tags) {

		this.tags = tags;
		return this;
	}

	public Recipient addTagsItem(RecipientTag tag) {
		if (this.tags == null) {
			this.tags = new TreeSet<>();
		}
		tag.setRecipient(this);
		this.tags.add(tag);

		return this;
	}

	/**
	 * Get tags
	 * @return tags
	 **/

	@Schema(implementation = RecipientTag.class, description = "tags linked to the recipient, ordered by tag name")

	@Valid
	@JsonIgnore
	public SortedSet<RecipientTag> getTags() {
		return tags;
	}

	@JsonIgnore
	public void setTags(SortedSet<RecipientTag> tags) {
		this.tags = tags;
		if (tags != null) {
			for (RecipientTag tag : tags) {
				tag.setRecipient(this);
			}
		}
	}

	@Schema(implementation = RecipientTag.class, description = "tags linked to the recipient")

	@JsonGetter("tags")
	public SortedSet<RecipientTag> getSelectedTags() {
		if (tags != null) {
			return tags.stream().filter(RecipientTag::isSelected).collect(Collectors.toCollection(TreeSet::new));
		}
		else {
			return null;
		}
	}

	@Schema(example = "2025-03-22T18:57:23.571Z", description = "date/time the recipient's last received a donation.")

	public Instant getLastDonationTimestamp() {
		return lastDonationTimestamp;
	}

	public void setLastDonationTimestamp(Instant lastDonationTimestamp) {
		this.lastDonationTimestamp = lastDonationTimestamp;
	}

	// @formatter:off
	// TODO: handle setting selected tags? No tags will be included on initial POST
	//  to create recipient, but need to decided how to handle recipient profile updates
	//  ideally the tags will either be excluded or ignored - this means it then has to
	//  merge with the database entry
	// @formatter:on

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

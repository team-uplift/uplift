package org.upLift.services;

import jakarta.validation.constraints.NotNull;
import org.springframework.validation.annotation.Validated;
import org.upLift.model.Recipient;

import java.util.List;
import java.util.Objects;

/**
 * Service interface for managing fairness in recipient matching. Provides methods to
 * calculate recipient weights and retrieve recipients based on donor-selected tags.
 */
@Validated
public interface FairnessService {

	/**
	 * Calculates the overall "weight" of a recipient for use in finding the top matches
	 * for a donor to choose from.
	 * @param recipient recipient for which the overall weight should be calculated
	 * @param maxSelectedTagWeight maximum weight across matched selected tags, may be
	 * used to scale other weights
	 * @param maxUnselectedTagWeight maximum weight across matched unselected tags, may be
	 * used to scale other weights
	 * @return overall "weight" of the specified recipient, used to order prospective
	 * matches for a donor to choose from
	 */
	double calculateOverallRecipientWeight(@NotNull RecipientWithMatchedTagWeights recipient,
			double maxSelectedTagWeight, double maxUnselectedTagWeight);

	/**
	 * Uses the specified list of tags as selected by the donor to find matching
	 * recipients, ordered by overall recipient weight as calculated using the
	 * calculateOverallRecipientWeight() method. Returns at most a set number of
	 * recipients, which may be modified using an application property.
	 * @param tags List of tags selected by the donor, used to find matching recipients
	 * @return List of recipients that match the donor-selected tags
	 */
	@NotNull
	List<Recipient> getRecipientsFromTags(@NotNull List<String> tags);

	/**
	 * Class used to hold a recipient together with the combined weights of matched tags,
	 * both selected and unselected.
	 */
	class RecipientWithMatchedTagWeights {

		private final Recipient recipient;

		private double selectedTagWeight;

		private double unselectedTagWeight;

		/**
		 * Constructs a new instance of {@code RecipientWithMatchedTagWeights}.
		 * @param recipient the recipient with the matched tag and associated weights
		 */
		public RecipientWithMatchedTagWeights(Recipient recipient) {
			this.recipient = recipient;
		}

		/**
		 * Gets the recipient associated with the matched tags.
		 * @return the recipient
		 */
		public Recipient getRecipient() {
			return recipient;
		}

		/**
		 * Checks if the recipient has any selected tags.
		 * @return {@code true} if the recipient has selected tags, {@code false}
		 * otherwise
		 */
		public boolean hasSelectedTags() {
			return selectedTagWeight > 0;
		}

		/**
		 * Gets the total weight of the selected tags.
		 * @return the total weight of the selected tags
		 */
		public double getSelectedTagWeight() {
			return selectedTagWeight;
		}

		/**
		 * Adds the selected tag weight to the total weight of the selected tags.
		 * @param weight the weight to add
		 */
		public void addSelectedTagWeight(double weight) {
			this.selectedTagWeight += weight;
		}

		/**
		 * Sets the total weight of the selected tags.
		 * @param selectedTagWeight the total weight of the selected tags
		 */
		public void setSelectedTagWeight(double selectedTagWeight) {
			this.selectedTagWeight = selectedTagWeight;
		}

		/**
		 * Checks if the recipient has any unselected tags.
		 * @return {@code true} if the recipient has unselected tags, {@code false}
		 * otherwise
		 */
		public boolean hasUnselectedTags() {
			return unselectedTagWeight > 0;
		}

		/**
		 * Gets the total weight of the unselected tags.
		 * @return the total weight of the unselected tags
		 */
		public double getUnselectedTagWeight() {
			return unselectedTagWeight;
		}

		/**
		 * Adds the specified weight to the total weight of the unselected tags.
		 * @param weight the weight to add
		 */
		public void addUnselectedTagWeight(double weight) {
			this.unselectedTagWeight += weight;
		}

		/**
		 * Sets the total weight of the unselected tags.
		 * @param unselectedTagWeight the total weight of the unselected tags
		 */
		public void setUnselectedTagWeight(double unselectedTagWeight) {
			this.unselectedTagWeight = unselectedTagWeight;
		}

		@Override
		public boolean equals(Object o) {
			if (o == null || getClass() != o.getClass())
				return false;
			RecipientWithMatchedTagWeights that = (RecipientWithMatchedTagWeights) o;
			return Objects.equals(recipient, that.recipient);
		}

		@Override
		public int hashCode() {
			return Objects.hashCode(recipient);
		}

	}

}

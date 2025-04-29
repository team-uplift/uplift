package org.upLift.services;

import jakarta.validation.constraints.NotNull;
import org.springframework.validation.annotation.Validated;
import org.upLift.model.Recipient;

import java.util.List;
import java.util.Map;
import java.util.Objects;

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

		public RecipientWithMatchedTagWeights(Recipient recipient) {
			this.recipient = recipient;
		}

		public Recipient getRecipient() {
			return recipient;
		}

		public boolean hasSelectedTags() {
			return selectedTagWeight > 0;
		}

		public double getSelectedTagWeight() {
			return selectedTagWeight;
		}

		public void addSelectedTagWeight(double weight) {
			this.selectedTagWeight += weight;
		}

		public void setSelectedTagWeight(double selectedTagWeight) {
			this.selectedTagWeight = selectedTagWeight;
		}

		public boolean hasUnselectedTags() {
			return unselectedTagWeight > 0;
		}

		public double getUnselectedTagWeight() {
			return unselectedTagWeight;
		}

		public void addUnselectedTagWeight(double weight) {
			this.unselectedTagWeight += weight;
		}

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

	// TODO - REMOVE
	public Map<Integer, RecipientWithMatchedTagWeights> buildRecipientMap(List<String> tags);

	public List<Recipient> getRecipientsByTags(List<String> tags);

}

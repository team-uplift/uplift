package org.upLift.services;

import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.upLift.model.Recipient;
import org.upLift.model.RecipientTag;
import org.upLift.repositories.RecipientRepository;
import org.upLift.repositories.RecipientTagsRepository;

import java.time.Duration;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.*;

@Service
@Transactional
public class FairnessServiceImpl implements FairnessService {

	/**
	 * Factor by which weights based on selected tags should be multiplied, to ensure
	 * they're always greater than weights based on unselected tags
	 */
	private static final double SELECTED_TAG_FACTOR = 100.0;

	/**
	 * Ideal number of potential recipient matches that should be returned.
	 */
	@Value("${uplift.number_of_matches:10}")
	private int numberOfMatches;

	/**
	 * Flag that determines whether recipients who don't have verified income should be
	 * excluded, primarily intended for use with testing.
	 */
	@Value("${uplift.exclude_unverified_income:true}")
	private boolean excludeUnverifiedIncome;

	private final RecipientTagsRepository recipientTagsRepository;

	private final RecipientRepository recipientRepository;

	public FairnessServiceImpl(RecipientTagsRepository recipientTagsRepository,
			RecipientRepository recipientRepository) {
		this.recipientTagsRepository = recipientTagsRepository;
		this.recipientRepository = recipientRepository;
	}

	@Override
	public double calculateOverallRecipientWeight(RecipientWithMatchedTagWeights recipientWithWeights,
			double maxSelectedTagWeight, double maxUnselectedTagWeight) {
		// For now, base recipient weight on weights of matched tags in combination with
		// the length of time since the last donation

		// Base max tag weight and multiplication factor on whether recipient had any
		// selected tags match or not
		double maxTagWeight;
		double tagWeight;
		double tagWeightFactor;
		if (recipientWithWeights.hasSelectedTags()) {
			maxTagWeight = maxSelectedTagWeight;
			tagWeight = recipientWithWeights.getSelectedTagWeight();
			tagWeightFactor = SELECTED_TAG_FACTOR;
		}
		else {
			maxTagWeight = maxUnselectedTagWeight;
			tagWeight = recipientWithWeights.getUnselectedTagWeight();
			tagWeightFactor = 1.0;
		}

		// Scale donation time based on max tag weight, so that a recipient with no
		// donations, or with the last donation at least 1 year ago, has the max tag
		// weight
		double donationWeight;
		var recipient = recipientWithWeights.getRecipient();
		if (recipient.getLastDonationTimestamp() == null) {
			donationWeight = maxTagWeight;
		}
		else {
			// Consider 1 year to be 365.25 days (for leap years), and scale to
			// maxTagWeight
			var daysSinceLastDonation = Duration.between(recipient.getLastDonationTimestamp(), Instant.now()).toDays();
			donationWeight = daysSinceLastDonation * maxTagWeight / 365.25;
			// Cap value at maxTagWeight
			if (donationWeight > maxTagWeight) {
				donationWeight = maxTagWeight;
			}
		}

		return (tagWeight + donationWeight) * tagWeightFactor;
	}

	@Override
	public List<Recipient> getRecipientsFromTags(List<String> tags) {
		// Collect all the recipients who have matching tags, whether selected or not
		var recipientTagMap = buildRecipientMap(tags);

		// Calculate overall weight for each recipient with at least one matching tag
		var weightedRecipients = buildWeightedRecipients(recipientTagMap.values());

		// Order the recipients
		sortWeightedRecipients(weightedRecipients);

		var recipients = weightedRecipients.stream().map(WeightedRecipient::recipient).toList();

		// Add or remove recipients as needed to match the desired number of recipients
		recipients = resizeRecipients(recipients);

		return recipients;
	}

	/**
	 * Loads all recipients who match the specified tags (whether selected or not) and
	 * builds a map linking persistence id with the object that holds the recipient
	 * together with the cumulative matched tag weights.
	 * @param tags List of tags selected by the donor
	 * @return Map linking recipient persistence index with a
	 * RecipientWithMatchedTagWeights object for each recipient who was linked to at least
	 * one of the specified tags
	 */
	Map<Integer, RecipientWithMatchedTagWeights> buildRecipientMap(List<String> tags) {
		var recipientTagMap = new HashMap<Integer, RecipientWithMatchedTagWeights>();
		for (String tag : tags) {
			List<RecipientTag> recipientTags = recipientTagsRepository.getRecipientTagsByTag_TagName(tag);
			for (RecipientTag recipientTag : recipientTags) {
				var recipient = recipientTag.getRecipient();
				if (excludeUnverifiedIncome && !recipient.isIncomeVerified()) {
					continue;
				}

				var weightedRecipient = recipientTagMap.computeIfAbsent(recipient.getId(),
						k -> new RecipientWithMatchedTagWeights(recipient));
				if (recipientTag.isSelected()) {
					weightedRecipient.addSelectedTagWeight(recipientTag.getWeight());
				}
				else {
					weightedRecipient.addUnselectedTagWeight(recipientTag.getWeight());
				}
			}
		}
		return recipientTagMap;
	}

	/**
	 * Builds a List of weighted recipients from the provided List of recipients, using
	 * the calculateOverallRecipientWeight() method. Note that the returned List is NOT
	 * sorted.
	 * @param recipients List of recipients with cumulative tag weights loaded, for which
	 * overall weights should be calculated
	 * @return List of WeightedRecipient objects, each containing a recipient from the
	 * original list along with the recipient's overall weight
	 */
	List<WeightedRecipient> buildWeightedRecipients(Collection<RecipientWithMatchedTagWeights> recipients) {
		// Iterate over recipients once to find the max tag weights
		double maxSelectedTagWeight = 0;
		double maxUnselectedTagWeight = 0;
		for (RecipientWithMatchedTagWeights recipient : recipients) {
			if (recipient.getSelectedTagWeight() > maxSelectedTagWeight) {
				maxSelectedTagWeight = recipient.getSelectedTagWeight();
			}
			if (recipient.getUnselectedTagWeight() > maxUnselectedTagWeight) {
				maxUnselectedTagWeight = recipient.getUnselectedTagWeight();
			}
		}

		var weightedRecipients = new ArrayList<WeightedRecipient>();
		for (RecipientWithMatchedTagWeights recipient : recipients) {
			double recipientOverallWeight = calculateOverallRecipientWeight(recipient, maxSelectedTagWeight,
					maxUnselectedTagWeight);
			weightedRecipients.add(new WeightedRecipient(recipient.getRecipient(), recipientOverallWeight));
		}
		return weightedRecipients;
	}

	/**
	 * Sorts the specified list such that the best/strongest matches are first and the
	 * weakest matches are last.
	 * @param weightedRecipients List of recipients to sort
	 */
	void sortWeightedRecipients(List<WeightedRecipient> weightedRecipients) {
		var recipientComparator = Comparator.comparing(WeightedRecipient::weight, Comparator.reverseOrder())
			// If weights are the same, fall back on time since last donation
			.thenComparing(WeightedRecipient::getLastDonationTimestamp,
					Comparator.nullsFirst(Comparator.naturalOrder()))
			// Finally fall back on persistence index
			.thenComparing(WeightedRecipient::getId);

		weightedRecipients.sort(recipientComparator);
	}

	/**
	 * Resizes the specified number of recipients to match the desired number of matches,
	 * if possible, by either removing extra recipients or adding more recipients that
	 * don't match the tags. Note that this method may return either the original List or
	 * a new List, so no assumption should be made either way.
	 * @param recipients List of recipients which should be trimmed/expanded to match the
	 * desired number of matches
	 * @return List containing either the desired number of matches or as many recipients
	 * as possible up to the desired number of matches if there aren't enough available
	 */
	List<Recipient> resizeRecipients(List<Recipient> recipients) {
		// If there are fewer than the desired number of matches, add recipients with no
		// matching tags based on date of last donation
		if (recipients.size() < numberOfMatches) {
			addUnmatchedRecipients(recipients);
		}
		// If there are more than the desired NUM_MATCHES, return only the first
		// NUM_MATCHES
		else if (recipients.size() > numberOfMatches) {
			// Create a new ArrayList since the subList() call just returns a view rather
			// than a new List
			recipients = new ArrayList<>(recipients.subList(0, numberOfMatches));
		}
		return recipients;
	}

	/**
	 * Adds recipients who didn't have any matching tags, based on date since last
	 * donation.
	 * @param recipients List of matching recipients to which extra recipients should be
	 * added, up to the desired number of matches if possible
	 */
	void addUnmatchedRecipients(List<Recipient> recipients) {
		// Selecting a cutoff for recipients who received a donation today.
		Instant cutoff = Instant.now().minus(1, ChronoUnit.DAYS);
		List<Recipient> extraRecipients = recipientRepository.getRecipientsByLastDonationTimestamp(cutoff);

		// Add extra recipients up to desired number of matches, if possible
		int i = 0;
		while (recipients.size() < numberOfMatches && i < extraRecipients.size()) {
			var extraRecipient = extraRecipients.get(i);
			if ((!excludeUnverifiedIncome || extraRecipient.isIncomeVerified())
					&& !recipients.contains(extraRecipient)) {
				recipients.add(extraRecipient);
			}
			i++;
		}
	}

	// Package-access setters added to facilitate unit testing, for integration testing
	// and deployment the value should be set using properties.

	void setNumberOfMatches(int numberOfMatches) {
		this.numberOfMatches = numberOfMatches;
	}

	void setExcludeUnverifiedIncome(boolean excludeUnverifiedIncome) {
		this.excludeUnverifiedIncome = excludeUnverifiedIncome;
	}

	record WeightedRecipient(Recipient recipient, double weight) {

		public Instant getLastDonationTimestamp() {
			return recipient.getLastDonationTimestamp();
		}

		public int getId() {
			return recipient.getId();
		}

	}

}

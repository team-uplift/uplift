package org.upLift.services;

import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;
import org.upLift.model.Recipient;
import org.upLift.model.RecipientTag;
import org.upLift.repositories.RecipientRepository;
import org.upLift.repositories.RecipientTagsRepository;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.*;

@Service
@Transactional
public class FairnessServiceImpl implements FairnessService {

    private final RecipientTagsRepository recipientTagsRepository;
    private final RecipientRepository recipientRepository;

    public FairnessServiceImpl(RecipientTagsRepository recipientTagsRepository, RecipientRepository recipientRepository) {
        this.recipientTagsRepository = recipientTagsRepository;
        this.recipientRepository = recipientRepository;
    }
    public Set<RecipientTag> getWeightedRecipientTags(List<String> tags) {
        Set<RecipientTag> recipientTags = new HashSet<>();

        for (String tag : tags) {
            recipientTags.addAll(recipientTagsRepository.getRecipientTagsByTagOrderedByWeight(tag));
        }

        return recipientTags;
    }

    public Set<Recipient> getRecipientsFromRecipientTags(Set<RecipientTag> recipientTags) {
        Set<Recipient> recipients = new HashSet<>();

        // Gather the recipients
        for (RecipientTag recipientTag : recipientTags) {
            recipients.add(recipientTag.getRecipient());
        }

        // Examine when the last donated timestamp was and lower the priority of those recipients.
        Set<Recipient> sortedSet = new TreeSet<>(
                Comparator.comparing(Recipient::getLastDonationTimestamp, Comparator.nullsFirst(Comparator.naturalOrder()))
                        // if timestamps can be equal, add a tie‑breaker to avoid “equal” elements albeit the small chance
                        .thenComparing(Recipient::getId)
        );
        sortedSet.addAll(recipients);

        // Remove unverified recipients
        Instant oneYearAgo = Instant.now().minus(1, ChronoUnit.YEARS);
        for (Recipient recipient : sortedSet) {
            if(recipient.getIncomeLastVerified().isBefore(oneYearAgo)) {
                sortedSet.remove(recipient);
            }
        }

        // If there are less than 10 recipients, gather the recipients with the least donations.
        if (sortedSet.size() < 10) {
            // Selecting a cutoff for recipients who received a donation today.
            Instant cutoff = Instant.now().minus(1, ChronoUnit.DAYS);
            List<Recipient> extraRecipients = recipientRepository.getRecipientsByLastDonationTimestamp(cutoff);

            // Add enough recipients up to ten.
            for(int i = 0; i < 10 - sortedSet.size(); i++) {
                if (extraRecipients.size() > i + 1) {
                    sortedSet.add(extraRecipients.get(i));
                }
            }
        }

        return recipients;
    }
}

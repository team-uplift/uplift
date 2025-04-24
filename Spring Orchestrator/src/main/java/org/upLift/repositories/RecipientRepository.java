package org.upLift.repositories;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.upLift.model.Recipient;

import java.time.Instant;
import java.util.List;

public interface RecipientRepository extends JpaRepository<Recipient, Integer> {

	/**
	 * Loads all recipients that have selected the specified tag.
	 * @param tag name of the tag which the recipient must have selected
	 * @return List of recipients who have selected the specified tag or an empty list if
	 * there are no such recipients
	 */
	List<Recipient> findByTags_SelectedIsTrueAndTags_Tag_TagName(String tag);

	/**
	 * Loads all recipients that are linked to the specified tag, whether they selected it
	 * or not.
	 * @param tag name of the tag to which the recipient must be linked (selected or not)
	 * @return List of recipients who are linked to the specified tag or an empty list if
	 * there are no such recipients
	 */
	@Query("""
			SELECT Recipient FROM Recipient Recipient
			JOIN Recipient.tags RecipientTag
			JOIN RecipientTag.tag Tag
			 		WHERE Tag.tagName IN :tags
			GROUP BY Recipient.id
			ORDER BY COUNT(Tag.tagName) DESC, Recipient.createdAt ASC
			""")
	List<Recipient> findByTags_Tag_TagName(List<String> tags, Pageable pageable);

	@Query("""
			  SELECT e
			    FROM Recipient e
			   WHERE e.lastDonationTimestamp < :cutoff
			      OR e.lastDonationTimestamp IS NULL
			ORDER BY CASE WHEN e.lastDonationTimestamp IS NULL THEN 0 ELSE 1 END,
			         e.lastDonationTimestamp ASC
			""")
	List<Recipient> getRecipientsByLastDonationTimestamp(@Param("cutoff") Instant cutoff);

}

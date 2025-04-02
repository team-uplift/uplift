package org.upLift.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.upLift.model.Recipient;

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
	List<Recipient> findByTags_Tag_TagName(String tag);

}

package org.upLift.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.upLift.model.Tag;

import java.util.List;

public interface TagRepository extends JpaRepository<Tag, String> {

	/**
	 * Retrieves a list of all tags that have been selected by at least one recipient.
	 * @return List containing all tags selected by at least one recipient
	 */
	@Query("""
			SELECT tag.tag FROM RecipientTag tag
			WHERE tag.selected = true
				AND tag.recipient.user.deleted = false
			GROUP BY tag.tag.tagName
			""")
	List<Tag> getSelectedTags();

}

package org.upLift.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.upLift.model.RecipientTag;

import java.util.List;

public interface RecipientTagsRepository extends JpaRepository<RecipientTag, Integer> {

	@Query("""
			SELECT recipientTag FROM RecipientTag recipientTag JOIN FETCH recipientTag.tag
						JOIN FETCH recipientTag.recipient
						WHERE recipientTag.tag.tagName = :tagName
			""")
	List<RecipientTag> getRecipientTagsByTag_TagName(String tagName);

}

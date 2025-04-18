package org.upLift.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.upLift.model.RecipientTag;

import java.util.List;

public interface RecipientTagsRepository extends JpaRepository<RecipientTag, Integer> {

	@Query("""
				SELECT recipientTag FROM RecipientTag recipientTag
							WHERE recipientTag.recipient.id = :recipientId AND recipientTag.tag.tagName = :tagName
			""")
	List<RecipientTag> getRecipientTagByRecipientIdAndTagName(@Param("recipientId") Integer recipientId,
			@Param("tagName") String tagName);

	@Query("""
				SELECT recipientTag FROM RecipientTag recipientTag
							WHERE recipientTag.recipient.id = :recipientId
			""")
	List<RecipientTag> getRecipientTagByRecipientId(Integer recipientId);

	@Query("""
				SELECT recipientTag FROM RecipientTag recipientTag
								WHERE recipientTag.tag.tagName = :tagName ORDER BY recipientTag.weight DESC
			""")
	List<RecipientTag> getRecipientTagsByTagOrderedByWeight(String tagName);

}

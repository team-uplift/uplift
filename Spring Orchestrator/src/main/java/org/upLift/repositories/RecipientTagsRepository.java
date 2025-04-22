package org.upLift.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.upLift.model.RecipientTag;

import java.util.List;

public interface RecipientTagsRepository extends JpaRepository<RecipientTag, Integer> {

	List<RecipientTag> getRecipientTagsByTag_TagName(String tagName);

}

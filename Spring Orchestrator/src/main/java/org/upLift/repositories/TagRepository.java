package org.upLift.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.upLift.model.Tag;

import java.util.List;

public interface TagRepository extends JpaRepository<Tag, Integer> {

	List<Tag> findByTagName(String tagName);

}

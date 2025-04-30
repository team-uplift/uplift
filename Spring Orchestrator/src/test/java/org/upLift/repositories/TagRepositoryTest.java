package org.upLift.repositories;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.upLift.model.Tag;
import org.upLift.model.Recipient;
import org.upLift.model.RecipientTag;
import jakarta.persistence.EntityManager;

import java.util.List;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

class TagRepositoryTest extends BaseRepositoryTest {

	@Autowired
	private TagRepository tagRepository;

	@Autowired
	private RecipientTagsRepository recipientTagsRepository;

	@Autowired
	private EntityManager entityManager; // Inject EntityManager

	@Test
	@DisplayName("Test retrieve selected tags")
	void testGetSelectedTags() {
		Recipient recipient = entityManager.find(Recipient.class, 1);
		if (recipient == null) {
			throw new IllegalStateException("Recipient with ID 1 does not exist in the database.");
		}
		Tag newTag = new Tag();
		newTag.setTagName("shelter");
		newTag.setCategory("basic-needs");
		entityManager.persist(newTag); // Persist the Tag entity
		entityManager.flush(); // Ensure the Tag is saved in the database

		// Add a RecipientTag for 'shelter' with selected=true
		RecipientTag recipientTag = new RecipientTag();
		recipientTag.setTag(newTag);
		recipientTag.setRecipient(recipient);
		recipientTag.setSelected(true);
		recipientTagsRepository.save(recipientTag);

		// Act: Retrieve selected tags
		List<Tag> selectedTags = tagRepository.getSelectedTags();

		// Assert: Validate that 'shelter' is included in the selected tags
		assertThat(selectedTags, is(not(empty()))); // Ensure the list is not empty
		assertThat(selectedTags, hasItem(hasProperty("tagName", is("shelter"))));
	}

}
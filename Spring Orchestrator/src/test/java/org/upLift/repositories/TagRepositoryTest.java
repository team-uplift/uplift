package org.upLift.repositories;

import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.upLift.model.Recipient;
import org.upLift.model.RecipientTag;
import org.upLift.model.Tag;

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
		var result1 = tagRepository.getSelectedTags();
		assertThat(result1, hasSize(12));
		result1.sort(null);
		// Result shouldn't include "education", which is linked only to recipient 2 but
		// not selected, or "elderly parent" which is linked only to deleted recipient 9
		// and is selected
		// @formatter:off
		assertThat(result1, contains(
				createTag("childcare"),
				createTag("clothing"),
				createTag("financial-planning"),
				createTag("food"),
				createTag("food-banks"),
				createTag("health"),
				createTag("housing"),
				createTag("job-training"),
				createTag("legal-aid"),
				createTag("mental-health"),
				createTag("transportation"),
				createTag("utilities")
		));
		// @formatter:on

		Tag newTag = new Tag();
		newTag.setTagName("shelter");
		newTag.setCategory("basic-needs");
		entityManager.persist(newTag); // Persist the Tag entity
		entityManager.flush(); // Ensure the Tag is saved in the database

		// Add a RecipientTag for 'shelter' with selected=true to the deleted recipient
		RecipientTag deletedRecipientTag = new RecipientTag();
		deletedRecipientTag.setTag(newTag);
		deletedRecipientTag.setRecipient(new Recipient().id(9));
		deletedRecipientTag.setSelected(true);
		recipientTagsRepository.save(deletedRecipientTag);

		var result2 = tagRepository.getSelectedTags();
		assertThat("New 'shelter' tag not added because recipient is deleted", result2, hasSize(12));
		for (Tag tag : result2) {
			assertThat(tag.getTagName(), is(not("shelter")));
		}

		// Now link the "shelter" tag to a non-deleted recipient

		// Add a RecipientTag for 'shelter' with selected=true to the deleted recipient
		RecipientTag nonDeletedRecipientTag = new RecipientTag();
		nonDeletedRecipientTag.setTag(newTag);
		nonDeletedRecipientTag.setRecipient(new Recipient().id(1));
		nonDeletedRecipientTag.setSelected(true);
		recipientTagsRepository.save(nonDeletedRecipientTag);

		// Act: Retrieve selected tags
		var result3 = tagRepository.getSelectedTags();

		// Assert: Validate that 'shelter' is now included in the selected tags
		assertThat(result3, hasSize(13));
		assertThat(result3, hasItem(hasProperty("tagName", is("shelter"))));
	}

	Tag createTag(String tagName) {
		return new Tag().tagName(tagName);
	}

}

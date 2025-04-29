package org.upLift.repositories;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.upLift.model.RecipientTag;

import java.time.Instant;
import java.util.Comparator;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

class RecipientTagsRepositoryTest extends BaseRepositoryTest {

	@Autowired
	private RecipientTagsRepository repository;

	@Test
	void findById() {
		var result = repository.findById(4);
		assertThat(result.isPresent(), is(true));
		checkTag(result.get());
	}

	@Test
	void getRecipientTagsByTagName() {
		// Deleted recipient 9 is linked to the "health" tag
		var deletedRecipientTag = repository.findById(36)
			.orElseThrow(() -> new RuntimeException("No recipient tag found"));
		assertThat(deletedRecipientTag.getTagName(), is("health"));
		assertThat(deletedRecipientTag.getRecipient().getId(), is(9));

		var result = repository.getRecipientTagsByTagName("health");

		// Result should not include the recipient tag for the deleted recipient
		assertThat(result, hasSize(4));
		result.sort(Comparator.comparing(RecipientTag::getId));

		var tag1 = result.getFirst();
		checkTag(tag1);

		for (RecipientTag tag : result) {
			assertThat(tag.getTagName(), is("health"));
		}

		var tag2 = result.get(1);
		assertThat(tag2.getId(), is(10));
		assertThat(tag2.getRecipient(), is(notNullValue()));
		assertThat(tag2.getRecipient().getId(), is(2));

		assertThat(result.get(2).getId(), is(18));
		assertThat(result.get(2).getRecipient().getId(), is(5));
		assertThat(result.get(3).getId(), is(26));
		assertThat(result.get(3).getRecipient().getId(), is(6));
	}

	void checkTag(RecipientTag tag) {
		assertThat(tag.getId(), is(4));
		assertThat(tag.getTag(), is(notNullValue()));
		assertThat(tag.getTagName(), is("health"));
		assertThat(tag.getRecipient(), is(notNullValue()));
		assertThat(tag.getRecipient().getId(), is(1));
		assertThat(tag.getWeight(), is(0.8));
		assertThat(tag.isSelected(), is(true));
		assertThat(tag.getAddedAt(), is(Instant.parse("2023-10-05T09:30:30.123Z")));
	}

}

package org.upLift.services;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;
import org.upLift.model.FormQuestion;
import org.upLift.model.Recipient;
import org.upLift.model.RecipientTag;
import org.upLift.model.Tag;
import org.upLift.repositories.RecipientRepository;
import org.upLift.repositories.TagRepository;

import java.time.Instant;
import java.util.HashMap;
import java.util.List;
import java.util.Optional;
import java.util.TreeSet;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

@ExtendWith(MockitoExtension.class)
class RecipientServiceImplUnitTest {

	@Mock
	private RecipientRepository recipientRepository;

	@Mock
	private BedrockService bedrockService;

	@Mock
	private TagRepository tagRepository;

	@Mock
	private FairnessService fairnessService;

	private RecipientServiceImpl recipientService;

	@BeforeEach
	void setUp() {
		recipientService = new RecipientServiceImpl(recipientRepository, bedrockService, tagRepository,
				fairnessService);
	}

	@Test
	void generateRecipientTags() {
		Instant now = Instant.now();

		// Have recipient already linked to two tags
		var tag2 = new Tag().tagName("tag2").category("category2");
		var tag6 = new Tag().tagName("tag6").category("category6");

		var recipient = new Recipient();
		recipient.setId(1);
		// Pre-set weight and selected flag to check for changes
		var linkedTag2 = new RecipientTag().weight(0.73).selected(true);
		linkedTag2.setTag(tag2);
		linkedTag2.setAddedAt(Instant.parse("2025-04-18T12:57:23.671Z"));
		var linkedTag6 = new RecipientTag().weight(0.84);
		linkedTag6.setTag(tag6);
		linkedTag6.setAddedAt(Instant.parse("2025-04-18T12:57:24.384Z"));
		recipient.setTags(new TreeSet<>(List.of(linkedTag2, linkedTag6)));
		Mockito.when(recipientRepository.findById(1)).thenReturn(Optional.of(recipient));

		var tagMap = new HashMap<String, Double>();
		tagMap.put("tag1", 0.35);
		tagMap.put("tag2", 0.6);
		tagMap.put("tag3", 0.9);
		tagMap.put("tag4", 0.42);
		tagMap.put("tag5", 0.57);
		Mockito.when(bedrockService.getTagsFromPrompt(Mockito.anyString())).thenReturn(tagMap);

		var tag1 = new Tag().tagName("tag1").category("category1");
		Mockito.when(tagRepository.findById("tag1")).thenReturn(Optional.of(tag1));
		Mockito.when(tagRepository.findById("tag2")).thenReturn(Optional.of(tag2));
		var tag4 = new Tag().tagName("tag4").category("category4");
		Mockito.when(tagRepository.findById("tag4")).thenReturn(Optional.of(tag4));

		Mockito.when(tagRepository.findById("tag3")).thenReturn(Optional.empty());
		Mockito.when(tagRepository.findById("tag5")).thenReturn(Optional.empty());

		// Returned the saved object when tags or recipients are saved
		Mockito.when(tagRepository.save(Mockito.any(Tag.class))).thenAnswer(i -> {
			Tag tag = (Tag) i.getArguments()[0];
			tag.setCreatedAt(Instant.now());
			return tag;
		});

		Mockito.when(recipientRepository.save(Mockito.any(Recipient.class))).thenAnswer(i -> i.getArguments()[0]);

		var questions = List.of(new FormQuestion("question1", "answer1"), new FormQuestion("question2", "answer2"));
		var result = recipientService.generateRecipientTags(1, questions);

		// We didn't remove any previously-assigned tags, we only added new ones
		assertThat(result, hasSize(6));
		result.sort(null);

		var recipientTag1 = result.get(0);
		assertThat(recipientTag1.getRecipient(), is(sameInstance(recipient)));
		assertThat(recipientTag1.getTag(), is(sameInstance(tag1)));
		assertThat(recipientTag1.getWeight(), is(0.35));
		assertThat(recipientTag1.isSelected(), is(false));
		assertThat(recipientTag1.getAddedAt(), is(greaterThanOrEqualTo(now)));

		var recipientTag2 = result.get(1);
		assertThat(recipientTag2.getRecipient(), is(sameInstance(recipient)));
		assertThat(recipientTag2.getTag(), is(sameInstance(tag2)));
		assertThat("tag2 weight updated", recipientTag2.getWeight(), is(0.6));
		assertThat("selected flag not changed", recipientTag2.isSelected(), is(true));
		assertThat("added at date updated", recipientTag2.getAddedAt(), is(greaterThanOrEqualTo(now)));

		var recipientTag3 = result.get(2);
		assertThat(recipientTag3.getRecipient(), is(sameInstance(recipient)));
		assertThat(recipientTag3.getTag(), allOf(hasProperty("tagName", is("tag3")),
				hasProperty("category", is(nullValue())), hasProperty("createdAt", is(greaterThanOrEqualTo(now)))));
		assertThat(recipientTag3.getWeight(), is(0.9));
		assertThat(recipientTag3.isSelected(), is(false));
		assertThat(recipientTag3.getAddedAt(), is(greaterThanOrEqualTo(now)));

		var recipientTag4 = result.get(3);
		assertThat(recipientTag4.getRecipient(), is(sameInstance(recipient)));
		assertThat(recipientTag4.getTag(), is(sameInstance(tag4)));
		assertThat(recipientTag4.getWeight(), is(0.42));
		assertThat(recipientTag4.isSelected(), is(false));
		assertThat(recipientTag4.getAddedAt(), is(greaterThanOrEqualTo(now)));

		var recipientTag5 = result.get(4);
		assertThat(recipientTag5.getRecipient(), is(sameInstance(recipient)));
		assertThat(recipientTag5.getTag(), allOf(hasProperty("tagName", is("tag5")),
				hasProperty("category", is(nullValue())), hasProperty("createdAt", is(greaterThanOrEqualTo(now)))));
		assertThat(recipientTag5.getWeight(), is(0.57));
		assertThat(recipientTag5.isSelected(), is(false));
		assertThat(recipientTag5.getAddedAt(), is(greaterThanOrEqualTo(now)));

		var recipientTag6 = result.get(5);
		assertThat(recipientTag6.getRecipient(), is(sameInstance(recipient)));
		assertThat(recipientTag6.getTag(), is(sameInstance(tag6)));
		assertThat(recipientTag6.getWeight(), is(0.84));
		assertThat(recipientTag6.isSelected(), is(false));
		assertThat(recipientTag6.getAddedAt(), is(linkedTag6.getAddedAt()));
	}

}

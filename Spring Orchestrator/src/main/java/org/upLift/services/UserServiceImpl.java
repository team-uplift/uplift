package org.upLift.services;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.upLift.exceptions.BadRequestException;
import org.upLift.exceptions.EntityNotFoundException;
import org.upLift.exceptions.ModelException;
import org.upLift.model.Donor;
import org.upLift.model.Recipient;
import org.upLift.model.User;
import org.upLift.repositories.UserRepository;

import java.util.List;
import java.util.Optional;
import java.util.Random;

@Service
@Transactional
public class UserServiceImpl implements UserService {

	private static final Logger LOG = LogManager.getLogger();

	private final UserRepository userRepository;

	public UserServiceImpl(UserRepository userRepository) {
		this.userRepository = userRepository;
	}

	@Override
	public boolean userExists(Integer id) {
		return userRepository.existsById(id);
	}

	@Override
	public boolean donorExists(Integer id) {
		return userRepository.existsByIdAndRecipientAndDeletedIsFalse(id, false);
	}

	@Override
	public boolean recipientExists(Integer id) {
		return userRepository.existsByIdAndRecipientAndDeletedIsFalse(id, true);
	}

	@Override
	public Optional<User> getUserById(Integer id) {
		var result = userRepository.findById(id);
		return loadChildData(result);
	}

	@Override
	public Optional<User> getUserByCognitoId(String cognitoId) {
		var result = userRepository.findByCognitoId(cognitoId);
		return loadChildData(result);
	}

	@Override
	public User addUser(User user) {
		LOG.debug("Adding new user: {}", user);
		// Donor entries may not come with any associated donor data, in which case it
		// must be added manually
		if (user.isDonor()) {
			if (user.getDonorData() == null) {
				user.setDonorData(new Donor());
			}
			Donor donor = user.getDonorData();
			// Assign a random nickname to the donor
			if (donor.getNickname() == null || donor.getNickname().isEmpty()) {
				String nickname = generateRandomNickname();
				donor.setNickname(nickname);

			}

		}

		// Recipient entries must always include additional data
		if (user.isRecipient()) {
			if (user.getRecipientData() == null) {
				throw new ModelException("New recipient entry must include recipient data");
			}
			Recipient recipient = user.getRecipientData();
			// Assign a random nickname to the recipient
			if (recipient.getNickname() == null || recipient.getNickname().isEmpty()) {
				String nickname = generateRandomNickname();
				recipient.setNickname(nickname);
				// Generate an icon URL using the nickname as the seed
				String iconUrl = generateIconUrl(nickname);
				recipient.setImageUrl(iconUrl);
			}
			if (recipient.getImageUrl() == null || recipient.getImageUrl().isEmpty()) {
				String nickname = generateRandomNickname();
				String iconUrl = generateIconUrl(nickname);
				recipient.setImageUrl(iconUrl);
			}
		}

		return userRepository.save(user);
	}

	@Override
	public User updateUserProfile(User user) {
		LOG.debug("Updated user info: {}", user);
		var existingEntry = userRepository.findById(user.getId());
		if (existingEntry.isEmpty()) {
			throw new EntityNotFoundException(user.getId(), "User",
					"User with id " + user.getId() + " not found, can't update entry");
		}

		var existingUser = existingEntry.get();
		// Check that this method is only called to update existing user/donor/recipient
		// data,
		// not to switch user type
		if (user.isRecipient() != existingUser.isRecipient()) {
			throw new BadRequestException(
					"Can't switch user type with this method, please use the appropriate 'switch' endpoint");
		}

		existingUser.setCognitoId(user.getCognitoId());
		existingUser.setEmail(user.getEmail());

		// Only update data for the current user type
		if (existingUser.isDonor()) {
			var existingDonor = existingUser.getDonorData();
			var updatedDonor = user.getDonorData();
			// Only update the nickname if present
			if (updatedDonor.getNickname() != null && !updatedDonor.getNickname().isEmpty()) {
				existingDonor.setNickname(updatedDonor.getNickname());
			}
		}
		else {
			var existingRecipient = existingUser.getRecipientData();
			var updatedRecipient = user.getRecipientData();
			// Only update the profile data, not the values set by the back end like
			// last verification or donation date/times
			existingRecipient.setFirstName(updatedRecipient.getFirstName());
			existingRecipient.setLastName(updatedRecipient.getLastName());
			existingRecipient.setStreetAddress1(updatedRecipient.getStreetAddress1());
			existingRecipient.setStreetAddress2(updatedRecipient.getStreetAddress2());
			existingRecipient.setCity(updatedRecipient.getCity());
			existingRecipient.setState(updatedRecipient.getState());
			existingRecipient.setZipCode(updatedRecipient.getZipCode());
			existingRecipient.setLastAboutMe(updatedRecipient.getLastAboutMe());
			existingRecipient.setLastReasonForHelp(updatedRecipient.getLastReasonForHelp());
			// Only update the nickname and image URL if present
			if (updatedRecipient.getNickname() != null && !updatedRecipient.getNickname().isEmpty()) {
				existingRecipient.setNickname(updatedRecipient.getNickname());
			}
			if (updatedRecipient.getImageUrl() != null && !updatedRecipient.getImageUrl().isEmpty()) {
				existingRecipient.setImageUrl(updatedRecipient.getImageUrl());
			}
		}

		// No need to load child data, since it's already present
		return userRepository.save(existingUser);
	}

	@Override
	public User addDonor(int id, Donor donor) {
		LOG.debug("Adding donor: {}", donor);
		// Get existing user with provided id
		var userResult = userRepository.findById(id);
		if (userResult.isEmpty()) {
			throw new EntityNotFoundException(id, "User", "User with id " + id + " not found, can't switch to donor");
		}

		var user = userResult.get();
		if (!user.isRecipient()) {
			LOG.error("User {} is already a donor", id);
			throw new BadRequestException("User " + id + " is already a donor");
		}

		user.setRecipient(false);
		user.setDonorData(donor);

		// No need to load child data, since it's already present
		return userRepository.save(user);
	}

	@Override
	public User addRecipient(int id, Recipient recipient) {
		LOG.debug("Adding recipient: {}", recipient);
		// Get existing user with provided id
		var userResult = userRepository.findById(id);
		if (userResult.isEmpty()) {
			throw new EntityNotFoundException(id, "User",
					"User with id " + id + " not found, can't switch to recipient");
		}

		var user = userResult.get();
		if (user.isRecipient()) {
			LOG.error("User {} is already a recipient", id);
			throw new BadRequestException("User " + id + " is already a recipient");
		}

		if (recipient.getNickname() == null || recipient.getNickname().isEmpty()) {
			// If nickname isn't specified, use the donor nickname
			recipient.setNickname(user.getDonorData().getNickname());
			recipient.setImageUrl(generateIconUrl(recipient.getNickname()));
		}

		user.setRecipient(true);
		user.setRecipientData(recipient);

		// No need to load child data, since it's already present
		return userRepository.save(user);
	}

	@Override
	public void deleteUser(Integer id) {
		var result = userRepository.findById(id);
		if (result.isEmpty()) {
			throw new EntityNotFoundException(id, "User", "User with id " + id + " not found");
		}
		var user = result.get();
		user.setDeleted(true);
		userRepository.save(user);
	}

	User loadChildData(User user) {
		// TODO: Clear out the other child data object here? or leave that for controller?
		if (user.isRecipient()) {
			// If the user is created before the recipient this creates a null
			// exception.
			if (user.getRecipientData() != null) {
				user.getRecipientData().getCreatedAt();
			}
		}
		else {
			// If the user is created before the recipient this creates a null
			// exception.
			if (user.getDonorData() != null) {
				user.getDonorData().getCreatedAt();
			}
		}
		return user;
	}

	Optional<User> loadChildData(Optional<User> result) {
		if (result.isPresent()) {
			var user = result.get();
			return Optional.of(loadChildData(user));
		}
		else {
			return result;
		}
	}

	private String generateRandomNickname() {
		List<String> colors = List.of("Red", "Blue", "Green", "Yellow", "Purple", "Orange", "Pink", "Brown", "Black",
				"White", "Cyan", "Magenta", "Teal", "Lavender", "Maroon", "Navy", "Olive", "Silver", "Gold", "Beige",
				"Coral", "Turquoise", "Indigo", "Violet", "Amber", "Emerald", "Peach", "Mint", "Charcoal", "Ruby",
				"Sapphire", "Crimson", "Ivory", "Lilac", "Periwinkle", "Aquamarine", "Fuchsia", "Mustard", "Plum",
				"Tan");
		List<String> nicknames = List.of("alligator", "anteater", "armadillo", "auroch", "axolotl", "badger", "bat",
				"beaver", "buffalo", "camel", "chameleon", "cheetah", "chipmunk", "chinchilla", "chupacabra",
				"cormorant", "coyote", "crow", "dingo", "dinosaur", "dolphin", "duck", "dragon", "elephant", "ferret",
				"fox", "frog", "giraffe", "gopher", "grizzly", "hedgehog", "hippo", "hyena", "jackal", "ibex", "ifrit",
				"iguana", "koala", "kraken", "lemur", "leopard", "liger", "llama", "manatee", "mink", "monkey",
				"narwhal", "nyan cat", "orangutan", "otter", "panda", "penguin", "platypus", "python", "pumpkin",
				"quagga", "rabbit", "raccoon", "rhino", "sheep", "shrew", "skunk", "slow loris", "squirrel", "turtle",
				"walrus", "wolf", "wolverine", "wombat");
		Random random = new Random();
		String color = colors.get(random.nextInt(colors.size()));
		String nickname = nicknames.get(random.nextInt(nicknames.size()));
		return color + " " + nickname;
	}

	private String generateIconUrl(String seed) {
		return "https://api.dicebear.com/7.x/pixel-art/svg?seed=" + seed;
	}

}

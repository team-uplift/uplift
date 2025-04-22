package org.upLift.services;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.upLift.exceptions.ModelException;
import org.upLift.model.Donor;
import org.upLift.model.Recipient;
import org.upLift.model.User;
import org.upLift.repositories.UserRepository;

import java.util.Optional;
import java.util.Random;
import java.util.List;

@Service
@Transactional
public class UserServiceImpl implements UserService {

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
		return userRepository.existsByIdAndRecipient(id, false);
	}

	@Override
	public boolean recipientExists(Integer id) {
		return userRepository.existsByIdAndRecipient(id, true);
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
	public User updateUser(User user) {
		return userRepository.save(user);
	}

	@Override
	public void deleteUser(Integer id) {
		userRepository.deleteById(id);
	}

	Optional<User> loadChildData(Optional<User> result) {
		// TODO: Clear out the other child data object here? or leave that for controller?
		if (result.isPresent()) {
			var user = result.get();
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
			return Optional.of(user);
		}
		else {
			return result;
		}
	}

	private String generateRandomNickname() {
		List<String> nicknames = List.of("alligator", "anteater", "armadillo", "auroch", "axolotl", "badger", "bat",
				"beaver", "buffalo", "camel", "chameleon", "cheetah", "chipmunk", "chinchilla", "chupacabra",
				"cormorant", "coyote", "crow", "dingo", "dinosaur", "dolphin", "duck", "dragon", "elephant", "ferret",
				"fox", "frog", "giraffe", "gopher", "grizzly", "hedgehog", "hippo", "hyena", "jackal", "ibex", "ifrit",
				"iguana", "koala", "kraken", "lemur", "leopard", "liger", "llama", "manatee", "mink", "monkey",
				"narwhal", "nyan cat", "orangutan", "otter", "panda", "penguin", "platypus", "python", "pumpkin",
				"quagga", "rabbit", "raccoon", "rhino", "sheep", "shrew", "skunk", "slow loris", "squirrel", "turtle",
				"walrus", "wolf", "wolverine", "wombat");
		Random random = new Random();
		return nicknames.get(random.nextInt(nicknames.size()));
	}

	private String generateIconUrl(String seed) {
		return "https://api.dicebear.com/7.x/pixel-art/svg?seed=" + seed;
	}

}

package org.upLift.services;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import org.springframework.validation.annotation.Validated;
import org.upLift.model.Donor;
import org.upLift.model.Recipient;
import org.upLift.model.User;

import java.util.Optional;

@Validated
public interface UserService {

	/**
	 * Checks if a user with the specified id exists.
	 * @param id persistence index of the user to check for
	 * @return true if there's a user entry with the specified id, false if not
	 */
	boolean userExists(@NotNull Integer id);

	/**
	 * Checks if a user with the specified id that's marked as being a donor exists. Note
	 * that if there's a user with the specified id that's a recipient, the method will
	 * return false.
	 * @param id persistence index of the donor user to check for
	 * @return true if there's a user entry marked as being a donor with the specified id,
	 * false if not
	 */
	boolean donorExists(@NotNull Integer id);

	/**
	 * Checks if a user with the specified id that's marked as being a recipient exists.
	 * Note that if there's a user with the specified id that's a donor, the method will
	 * return false.
	 * @param id persistence index of the recipient user to check for
	 * @return true if there's a user entry marked as being a recipient with the specified
	 * id, false if not
	 */
	boolean recipientExists(@NotNull Integer id);

	/**
	 * Loads the user entry with the specified uplift id, if present.
	 * @param id uplift persistence index of the user to load
	 * @return Optional containing the user entry with the specified id or an empty
	 * Optional if there's no such user
	 */
	@NotNull
	Optional<User> getUserById(@NotNull Integer id);

	/**
	 * Loads the user entry with the specified Cognito UUID, if present.
	 * @param cognitoId Cognito UUID of the user to load
	 * @return Optional containing the user entry with the specified Cognito UUID or an
	 * empty Optional if there's no such user
	 */
	@NotNull
	Optional<User> getUserByCognitoId(@NotNull String cognitoId);

	/**
	 * Adds the specified new user to the uplift system. If the new user is a donor, the
	 * child donorData may or may not be present. If the new user is a recipient, the
	 * child recipientData MUST be present.
	 * @param user new user data to be stored
	 * @return saved new user entry with associated child donor or recipient data
	 */
	@NotNull
	User addUser(@NotNull @Valid User user);

	/**
	 * Updates the user with the specified new values. Note that only user-editable values
	 * will be modified - automated/server-set values will not be updated, even if values
	 * are included in the provided User argument.
	 * @param user User object containing new values to use to update, must include id
	 * @return updated user entry
	 * @throws org.upLift.exceptions.EntityNotFoundException if the id specified in the
	 * User doesn't match an existing entry
	 * @throws org.upLift.exceptions.BadRequestException if the recipient flag in the
	 * provided User object doesn't match the saved recipient flag for that user
	 */
	@NotNull
	User updateUserProfile(@NotNull @Valid User user);

	/**
	 * Switches the user with the specified id from a recipient to a donor, adding the
	 * specified child donor data.
	 * @param id persistence index of the user entry to switch from recipient to donor
	 * @param donor new donor data to be added, linked to the user with the specified id
	 * @return updated user entry, now marked as donor and including the new donor data
	 * @throws org.upLift.exceptions.EntityNotFoundException if the specified id doesn't
	 * match an existing entry
	 * @throws org.upLift.exceptions.BadRequestException if the user with the specified id
	 * is already a donor
	 */
	@NotNull
	User addDonor(int id, @NotNull @Valid Donor donor);

	/**
	 * Switches the user with the specified id from a donor to a recipient, adding the
	 * specified child recipient data.
	 * @param id persistence index of the user entry to switch from donor to recipient
	 * @param recipient new recipient data to be added, linked to the user with the
	 * specified id
	 * @return updated user entry, now marked as recipient and including the new recipient
	 * data
	 * @throws org.upLift.exceptions.EntityNotFoundException if the specified id doesn't
	 * match an existing entry
	 * @throws org.upLift.exceptions.BadRequestException if the user with the specified id
	 * is already a recipient
	 */
	@NotNull
	User addRecipient(int id, @NotNull @Valid Recipient recipient);

	void deleteUser(Integer id);

}

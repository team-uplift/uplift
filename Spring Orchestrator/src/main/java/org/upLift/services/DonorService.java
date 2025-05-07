package org.upLift.services;

import org.upLift.model.Donor;

/**
 * Service interface for managing donors.
 */
public interface DonorService {

	/**
	 * Saves a donor to the database.
	 * @param donor the donor to save
	 * @return the saved donor
	 */
	Donor saveDonor(Donor donor);

	/**
	 * Retrieves a donor by their ID.
	 * @param id the ID of the donor to retrieve
	 * @return the donor with the specified ID
	 * @throws EntityNotFoundException if the donor is not found
	 */
	Donor getDonorById(Integer id);

}

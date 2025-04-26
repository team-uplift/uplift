package org.upLift.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.upLift.model.Donation;

import java.util.List;
import java.util.Optional;

public interface DonationRepository extends JpaRepository<Donation, Integer> {

	/**
	 * Finds the donation with the specified id (if any), eagerly loading both donor and
	 * recipient associated with the donation.
	 * @param donationId persistence index of the donation to load
	 * @return Optional containing the donation with the specified id with both donor and
	 * recipient eagerly loaded, or an empty Optional if there's no such donation
	 */
	@Query("""
				SELECT donation FROM Donation donation JOIN FETCH donation.donor
							JOIN FETCH donation.recipient
							WHERE donation.id = :donationId
			""")
	Optional<Donation> findForPublicById(int donationId);

	/**
	 * Finds all donations made by the specified donor, eagerly loading the recipients
	 * associated with each donation.
	 * @param donorId persistence index of the donor who gave the donations to load
	 * @return List of all donations given by the specified donor with recipients eagerly
	 * loaded, or an empty List if the donor hasn't donated anything or there's no such
	 * donor
	 */
	@Query("""
				SELECT donation FROM Donation donation JOIN FETCH donation.recipient
							 WHERE donation.donor.id = :donorId
			""")
	List<Donation> findByDonorId(@Param("donorId") Integer donorId);

	/**
	 * Finds all donations received by the specified recipient, eagerly loading the donors
	 * associated with each donation.
	 * @param recipientId persistence index of the recipient whose received donations
	 * should be loaded
	 * @return List of all donations received by the specified recipient with donors
	 * eagerly loaded, or an empty List if the recipient hasn't received any donations or
	 * there's no such recipient
	 */
	@Query("""
				SELECT donation FROM Donation donation JOIN FETCH donation.donor
							WHERE donation.recipient.id = :recipientId
			""")
	List<Donation> findByRecipientId(@Param("recipientId") Integer recipientId);

}

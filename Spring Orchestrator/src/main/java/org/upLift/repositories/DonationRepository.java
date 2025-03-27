package org.upLift.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.upLift.model.Donation;

import java.util.List;

public interface DonationRepository extends JpaRepository<Donation, Long> {

	/**
	 * Finds all donations made by the specified donor.
	 * @param donorId
	 * @return
	 */
	List<Donation> findByDonor_Id(Integer donorId);

	/**
	 * Finds all donations received by the specified recipient.
	 * @param recipientId
	 * @return
	 */
	List<Donation> findByRecipient_Id(Integer recipientId);

}

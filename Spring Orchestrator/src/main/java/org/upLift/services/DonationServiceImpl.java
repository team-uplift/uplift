package org.upLift.services;

import org.springframework.stereotype.Service;
import org.upLift.model.Donation;
import org.upLift.repositories.DonationRepository;
import java.util.List;

@Service
public class DonationServiceImpl implements DonationService {

	private final DonationRepository donationRepository;

	public DonationServiceImpl(DonationRepository donationRepository) {
		this.donationRepository = donationRepository;
	}

	@Override
	public Donation saveDonation(Donation donation) {
		return donationRepository.save(donation);
	}

	@Override
	public List<Donation> getAllDonations() {
		return donationRepository.findAll();
	}

	@Override
	public List<Donation> getDonationsByDonorId(Integer donorId) {
		return donationRepository.findAll().stream().filter(donation -> donation.getDonorId().equals(donorId)).toList();
	}

	@Override
	public List<Donation> getDonationsByRecipientId(Integer recipientId) {
		return donationRepository.findAll()
			.stream()
			.filter(donation -> donation.getRecipientId().equals(recipientId))
			.toList();
	}

}

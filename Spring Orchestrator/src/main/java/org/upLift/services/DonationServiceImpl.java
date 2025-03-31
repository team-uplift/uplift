package org.upLift.services;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.upLift.model.Donation;
import org.upLift.repositories.DonationRepository;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class DonationServiceImpl implements DonationService {

	private final DonationRepository donationRepository;

	public DonationServiceImpl(DonationRepository donationRepository) {
		this.donationRepository = donationRepository;
	}

	@Override
	public Optional<Donation> getDonationById(int id) {
		return donationRepository.findById(id);
	}

	@Override
	public List<Donation> getAllDonations() {
		return donationRepository.findAll();
	}

	@Override
	public List<Donation> getDonationsByDonorId(Integer donorId) {
		return donationRepository.findByDonorId(donorId);
	}

	@Override
	public List<Donation> getDonationsByRecipientId(Integer recipientId) {
		return donationRepository.findByRecipientId(recipientId);
	}

	@Override
	public Donation saveDonation(Donation donation) {
		return donationRepository.save(donation);
	}

}

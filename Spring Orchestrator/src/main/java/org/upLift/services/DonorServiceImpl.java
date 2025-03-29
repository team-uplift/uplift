package org.upLift.services;

import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.upLift.model.Donor;
import org.upLift.repositories.DonorRepository;

import java.util.Optional;

@Service
@Transactional
public class DonorServiceImpl implements DonorService {

	private final DonorRepository donorRepository;

	public DonorServiceImpl(DonorRepository donorRepository) {
		this.donorRepository = donorRepository;
	}

	@Override
	public Donor saveDonor(Donor donor) {
		return donorRepository.save(donor);
	}

	@Override
	public Donor getDonorById(Integer id) {
		Optional<Donor> donor = donorRepository.findById(id);
		return donor.orElse(null);
	}

}

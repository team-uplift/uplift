package org.upLift.services;

import org.upLift.model.Donor;

public interface DonorService {

	Donor saveDonor(Donor donor);

	Donor getDonorById(Integer id);

}

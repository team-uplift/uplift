package org.upLift.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.upLift.model.Donation;

import java.util.List;

public interface DonationRepository extends JpaRepository<Donation, Integer> {

}

package org.upLift.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.upLift.model.Donor;

public interface DonorRepository extends JpaRepository<Donor, Integer> {

}
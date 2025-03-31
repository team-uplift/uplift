package org.upLift.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.upLift.model.Recipient;

public interface RecipientRepository extends JpaRepository<Recipient, Integer> {

}

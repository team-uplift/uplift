package org.upLift.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.upLift.model.Message;

import java.util.List;

public interface MessageRepository extends JpaRepository<Message, Integer> {

	List<Message> findAllByDonation_Donor_Id(int donorId);
}

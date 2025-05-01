package org.upLift.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.upLift.model.User;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Integer> {

	boolean existsByIdAndRecipientAndDeletedIsFalse(Integer id, boolean recipient);

	Optional<User> findByCognitoId(String cognitoId);

}

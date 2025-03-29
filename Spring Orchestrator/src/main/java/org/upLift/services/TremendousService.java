package org.upLift.services;

import org.upLift.model.*;

public interface TremendousService {

	/***
	 * This is the public interface method for the method that will donate to the
	 * @param recipient
	 * @param donor
	 * @param donationAmount
	 * @return
	 */
	public TremendousOrderResponse submitDonationOrder(User recipient, User donor, int donationAmount);

}

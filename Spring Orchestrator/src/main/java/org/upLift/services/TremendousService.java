package org.upLift.services;

import org.springframework.validation.annotation.Validated;
import org.upLift.model.Donation;
import org.upLift.model.Donor;
import org.upLift.model.Recipient;
import org.upLift.model.User;

import java.math.BigDecimal;
import java.net.http.HttpResponse;

@Validated
public interface TremendousService {
    /***
     * This is the public interface method for the method that will donate to the
     * @param recipient
     * @param donor
     * @param donationAmount
     * @return
     */
    public String submitDonationOrder(User recipient, User donor, int donationAmount);
}

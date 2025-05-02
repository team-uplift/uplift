package org.upLift.services;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.upLift.model.Donation;
import org.upLift.repositories.DonationRepository;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class DonationServiceImplTest {

    @Mock
    private DonationRepository donationRepository;

    @InjectMocks
    private DonationServiceImpl donationService;

    @Test
    void getDonationById_found() {
        Donation donation = mock(Donation.class);
        when(donationRepository.findForPublicById(1)).thenReturn(Optional.of(donation));

        Optional<Donation> result = donationService.getDonationById(1);

        assertTrue(result.isPresent());
        assertSame(donation, result.get());
        verify(donationRepository).findForPublicById(1);
    }

    @Test
    void getDonationById_notFound() {
        when(donationRepository.findForPublicById(2)).thenReturn(Optional.empty());

        Optional<Donation> result = donationService.getDonationById(2);

        assertFalse(result.isPresent());
        verify(donationRepository).findForPublicById(2);
    }

    @Test
    void getDonationsByDonorId_returnsDonations() {
        Donation d1 = mock(Donation.class);
        Donation d2 = mock(Donation.class);
        when(donationRepository.findByDonorId(10)).thenReturn(Arrays.asList(d1, d2));

        List<Donation> result = donationService.getDonationsByDonorId(10);

        assertEquals(2, result.size());
        assertEquals(Arrays.asList(d1, d2), result);
        verify(donationRepository).findByDonorId(10);
    }

    @Test
    void getDonationsByDonorId_emptyList() {
        when(donationRepository.findByDonorId(20)).thenReturn(Collections.emptyList());

        List<Donation> result = donationService.getDonationsByDonorId(20);

        assertTrue(result.isEmpty());
        verify(donationRepository).findByDonorId(20);
    }

    @Test
    void getDonationsByRecipientId_returnsDonations() {
        Donation d1 = mock(Donation.class);
        when(donationRepository.findByRecipientId(30)).thenReturn(Collections.singletonList(d1));

        List<Donation> result = donationService.getDonationsByRecipientId(30);

        assertEquals(1, result.size());
        assertEquals(Collections.singletonList(d1), result);
        verify(donationRepository).findByRecipientId(30);
    }

    @Test
    void getDonationsByRecipientId_emptyList() {
        when(donationRepository.findByRecipientId(40)).thenReturn(Collections.emptyList());

        List<Donation> result = donationService.getDonationsByRecipientId(40);

        assertTrue(result.isEmpty());
        verify(donationRepository).findByRecipientId(40);
    }

    @Test
    void saveDonation_invokesSaveAndReturns() {
        Donation donation = mock(Donation.class);
        when(donationRepository.save(donation)).thenReturn(donation);

        Donation result = donationService.saveDonation(donation);

        assertSame(donation, result);
        verify(donationRepository).save(donation);
    }
}

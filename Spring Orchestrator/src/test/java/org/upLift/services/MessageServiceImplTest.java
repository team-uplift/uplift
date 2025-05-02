package org.upLift.services;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.upLift.exceptions.EntityNotFoundException;
import org.upLift.exceptions.ModelException;
import org.upLift.model.Message;
import org.upLift.repositories.DonationRepository;
import org.upLift.repositories.MessageRepository;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MessageServiceImplTest {

    @Mock
    private DonationRepository donationRepository;

    @Mock
    private MessageRepository messageRepository;

    @InjectMocks
    private MessageServiceImpl messageService;

    @BeforeEach
    void setUp() {
        // MockitoAnnotations.openMocks(this);  // Not needed with @ExtendWith
    }

    @Test
    void getMessageById_whenFound_returnsOptionalWithMessage() {
        Message msg = new Message();
        when(messageRepository.findById(100)).thenReturn(Optional.of(msg));

        Optional<Message> result = messageService.getMessageById(100);

        assertTrue(result.isPresent());
        assertSame(msg, result.get());
        verify(messageRepository).findById(100);
    }

    @Test
    void getMessageById_whenNotFound_returnsEmptyOptional() {
        when(messageRepository.findById(101)).thenReturn(Optional.empty());

        Optional<Message> result = messageService.getMessageById(101);

        assertFalse(result.isPresent());
        verify(messageRepository).findById(101);
    }

    @Test
    void getMessagesByDonorId_returnsListFromRepository() {
        Message m1 = new Message();
        Message m2 = new Message();
        when(messageRepository.findAllByDonation_Donor_Id(50)).thenReturn(List.of(m1, m2));

        List<Message> result = messageService.getMessagesByDonorId(50);

        assertEquals(2, result.size());
        assertEquals(List.of(m1, m2), result);
        verify(messageRepository).findAllByDonation_Donor_Id(50);
    }

    @Test
    void sendNewMessage_whenDonationIdNull_throwsModelException() {
        Message msg = new Message();
        msg.setDonationId(null);

        ModelException ex = assertThrows(ModelException.class,
                () -> messageService.sendNewMessage(msg));

        assertTrue(ex.getMessage().contains("no donation id"));
        verifyNoInteractions(donationRepository);
        verifyNoInteractions(messageRepository);
    }

    @Test
    void sendNewMessage_whenDonationNotExists_throwsEntityNotFoundException() {
        Message msg = new Message();
        msg.setDonationId(1);
        when(donationRepository.existsById(1)).thenReturn(false);

        EntityNotFoundException ex = assertThrows(EntityNotFoundException.class,
                () -> messageService.sendNewMessage(msg));

        assertTrue(ex.getMessage().contains("No donation found"));
        verify(donationRepository).existsById(1);
        verify(messageRepository, never()).save(any());
    }

    @Test
    void sendNewMessage_whenMessageAlreadyExists_throwsModelException() {
        Message msg = new Message();
        msg.setDonationId(2);
        when(donationRepository.existsById(2)).thenReturn(true);
        when(messageRepository.existsByDonation_Id(2)).thenReturn(true);

        ModelException ex = assertThrows(ModelException.class,
                () -> messageService.sendNewMessage(msg));

        assertTrue(ex.getMessage().contains("thank you message already exists"));
        verify(donationRepository).existsById(2);
        verify(messageRepository).existsByDonation_Id(2);
        verify(messageRepository, never()).save(any());
    }

    @Test
    void sendNewMessage_success_savesAndReturnsMessage() {
        Message msg = new Message();
        msg.setDonationId(3);
        when(donationRepository.existsById(3)).thenReturn(true);
        when(messageRepository.existsByDonation_Id(3)).thenReturn(false);
        when(messageRepository.save(msg)).thenReturn(msg);

        Message result = messageService.sendNewMessage(msg);

        assertSame(msg, result);
        verify(donationRepository).existsById(3);
        verify(messageRepository).existsByDonation_Id(3);
        verify(messageRepository).save(msg);
    }

    @Test
    void markMessageRead_whenMessageExists_marksReadAndSaves() {
        int messageId = 42;
        Message msg = new Message();
        msg.setDonorRead(false);
        when(messageRepository.findById(messageId)).thenReturn(Optional.of(msg));
        when(messageRepository.save(msg)).thenAnswer(inv -> inv.getArgument(0));

        Message result = messageService.markMessageRead(messageId);

        assertTrue(result.isDonorRead());
        verify(messageRepository).findById(messageId);
        verify(messageRepository).save(msg);
    }

    @Test
    void markMessageRead_whenMessageNotFound_throwsEntityNotFoundException() {
        when(messageRepository.findById(99)).thenReturn(Optional.empty());

        EntityNotFoundException ex = assertThrows(EntityNotFoundException.class,
                () -> messageService.markMessageRead(99));

        assertTrue(ex.getMessage().contains("No message found"));
        verify(messageRepository).findById(99);
        verify(messageRepository, never()).save(any());
    }
}

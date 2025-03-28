package org.upLift.model;

import java.time.Instant;
import java.util.List;

public class TremendousOrderResponse {
    private Order order;

    public Order getOrder() { return order; }
    public void setOrder(Order order) { this.order = order; }

    public static class Order {
        private String id;
        private String externalId;
        private String campaignId;
        private Instant createdAt;
        private String channel;
        private String status;
        private Payment payment;
        private List<Reward> rewards;

        public String getId() { return id; }
        public void setId(String id) { this.id = id; }

        public String getExternalId() { return externalId; }
        public void setExternalId(String externalId) { this.externalId = externalId; }

        public String getCampaignId() { return campaignId; }
        public void setCampaignId(String campaignId) { this.campaignId = campaignId; }

        public Instant getCreatedAt() { return createdAt; }
        public void setCreatedAt(Instant createdAt) { this.createdAt = createdAt; }

        public String getChannel() { return channel; }
        public void setChannel(String channel) { this.channel = channel; }

        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }

        public Payment getPayment() { return payment; }
        public void setPayment(Payment payment) { this.payment = payment; }

        public List<Reward> getRewards() { return rewards; }
        public void setRewards(List<Reward> rewards) { this.rewards = rewards; }
    }

    public static class Payment {
        private double subtotal;
        private double total;
        private double fees;
        private double discount;

        public double getSubtotal() { return subtotal; }
        public void setSubtotal(double subtotal) { this.subtotal = subtotal; }

        public double getTotal() { return total; }
        public void setTotal(double total) { this.total = total; }

        public double getFees() { return fees; }
        public void setFees(double fees) { this.fees = fees; }

        public double getDiscount() { return discount; }
        public void setDiscount(double discount) { this.discount = discount; }
    }

    public static class Reward {
        private String id;
        private String orderId;
        private Instant createdAt;
        private Value value;
        private Delivery delivery;
        private Recipient recipient;

        public String getId() { return id; }
        public void setId(String id) { this.id = id; }

        public String getOrderId() { return orderId; }
        public void setOrderId(String orderId) { this.orderId = orderId; }

        public Instant getCreatedAt() { return createdAt; }
        public void setCreatedAt(Instant createdAt) { this.createdAt = createdAt; }

        public Value getValue() { return value; }
        public void setValue(Value value) { this.value = value; }

        public Delivery getDelivery() { return delivery; }
        public void setDelivery(Delivery delivery) { this.delivery = delivery; }

        public Recipient getRecipient() { return recipient; }
        public void setRecipient(Recipient recipient) { this.recipient = recipient; }
    }

    public static class Value {
        private double denomination;
        private String currencyCode;

        public double getDenomination() { return denomination; }
        public void setDenomination(double denomination) { this.denomination = denomination; }

        public String getCurrencyCode() { return currencyCode; }
        public void setCurrencyCode(String currencyCode) { this.currencyCode = currencyCode; }
    }

    public static class Delivery {
        private String method;
        private String status;

        public String getMethod() { return method; }
        public void setMethod(String method) { this.method = method; }

        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
    }

    public static class Recipient {
        private String email;
        private String name;
        private String phone;

        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }

        public String getName() { return name; }
        public void setName(String name) { this.name = name; }

        public String getPhone() { return phone; }
        public void setPhone(String phone) { this.phone = phone; }
    }
}

package com.giftbank.database;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Account {
    private int accountId;
    private int userId;
    private String accountNumber;
    private String holderName;
    private String phone;
    private String address;
    private BigDecimal balance;
    private String accountStatus;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public Account() {}

    public Account(String accountNumber, String holderName, String phone, String address, BigDecimal balance) {
        this.accountNumber = accountNumber;
        this.holderName = holderName;
        this.phone = phone;
        this.address = address;
        this.balance = balance;
        this.accountStatus = "active";
    }

    // Getters and Setters
    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getAccountNumber() {
        return accountNumber;
    }

    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }

    public String getHolderName() {
        return holderName;
    }

    public void setHolderName(String holderName) {
        this.holderName = holderName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public BigDecimal getBalance() {
        return balance;
    }

    public void setBalance(BigDecimal balance) {
        this.balance = balance;
    }

    public String getAccountStatus() {
        return accountStatus;
    }

    public void setAccountStatus(String accountStatus) {
        this.accountStatus = accountStatus;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}

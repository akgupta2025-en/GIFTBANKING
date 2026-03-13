package com.giftbank.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Account {
    private int accountId;
    private String accountNumber;
    private String holderName;
    private String phone;
    private String address;
    private BigDecimal balance;
    private int userId;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    public Account() {}
    
    public Account(String accountNumber, String holderName, String phone, String address, BigDecimal balance, int userId) {
        this.accountNumber = accountNumber;
        this.holderName = holderName;
        this.phone = phone;
        this.address = address;
        this.balance = balance;
        this.userId = userId;
    }
    
    public int getAccountId() {
        return accountId;
    }
    
    public void setAccountId(int accountId) {
        this.accountId = accountId;
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
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}

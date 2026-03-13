package com.giftbank.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Transaction {
    private int transactionId;
    private String accountNumber;
    private String type;
    private BigDecimal amount;
    private BigDecimal balanceAfter;
    private String description;
    private Timestamp date;
    
    public Transaction() {}
    
    public Transaction(String accountNumber, String type, BigDecimal amount, BigDecimal balanceAfter, String description) {
        this.accountNumber = accountNumber;
        this.type = type;
        this.amount = amount;
        this.balanceAfter = balanceAfter;
        this.description = description;
    }
    
    public int getTransactionId() {
        return transactionId;
    }
    
    public void setTransactionId(int transactionId) {
        this.transactionId = transactionId;
    }
    
    public String getAccountNumber() {
        return accountNumber;
    }
    
    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }
    
    public String getType() {
        return type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public BigDecimal getBalanceAfter() {
        return balanceAfter;
    }
    
    public void setBalanceAfter(BigDecimal balanceAfter) {
        this.balanceAfter = balanceAfter;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Timestamp getDate() {
        return date;
    }
    
    public void setDate(Timestamp date) {
        this.date = date;
    }
}

package com.giftbank.dao;

import com.giftbank.model.Transaction;
import com.giftbank.util.DatabaseUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TransactionDAO {
    
    public boolean createTransaction(Transaction transaction) {
        String sql = "INSERT INTO transactions (account_number, type, amount, balance_after, description) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, transaction.getAccountNumber());
            pstmt.setString(2, transaction.getType());
            pstmt.setBigDecimal(3, transaction.getAmount());
            pstmt.setBigDecimal(4, transaction.getBalanceAfter());
            pstmt.setString(5, transaction.getDescription());
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Transaction> getTransactionsByAccount(String accountNumber) {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM transactions WHERE account_number = ? ORDER BY date DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, accountNumber);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Transaction transaction = new Transaction();
                transaction.setTransactionId(rs.getInt("transaction_id"));
                transaction.setAccountNumber(rs.getString("account_number"));
                transaction.setType(rs.getString("type"));
                transaction.setAmount(rs.getBigDecimal("amount"));
                transaction.setBalanceAfter(rs.getBigDecimal("balance_after"));
                transaction.setDescription(rs.getString("description"));
                transaction.setDate(rs.getTimestamp("date"));
                transactions.add(transaction);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return transactions;
    }
    
    public List<Transaction> getTransactionsByAccountWithPagination(String accountNumber, int page, int pageSize) {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM transactions WHERE account_number = ? ORDER BY date DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, accountNumber);
            pstmt.setInt(2, pageSize);
            pstmt.setInt(3, (page - 1) * pageSize);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Transaction transaction = new Transaction();
                transaction.setTransactionId(rs.getInt("transaction_id"));
                transaction.setAccountNumber(rs.getString("account_number"));
                transaction.setType(rs.getString("type"));
                transaction.setAmount(rs.getBigDecimal("amount"));
                transaction.setBalanceAfter(rs.getBigDecimal("balance_after"));
                transaction.setDescription(rs.getString("description"));
                transaction.setDate(rs.getTimestamp("date"));
                transactions.add(transaction);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return transactions;
    }
    
    public int getTransactionCount(String accountNumber) {
        String sql = "SELECT COUNT(*) FROM transactions WHERE account_number = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, accountNumber);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    public List<Transaction> getAllTransactions() {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM transactions ORDER BY date DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Transaction transaction = new Transaction();
                transaction.setTransactionId(rs.getInt("transaction_id"));
                transaction.setAccountNumber(rs.getString("account_number"));
                transaction.setType(rs.getString("type"));
                transaction.setAmount(rs.getBigDecimal("amount"));
                transaction.setBalanceAfter(rs.getBigDecimal("balance_after"));
                transaction.setDescription(rs.getString("description"));
                transaction.setDate(rs.getTimestamp("date"));
                transactions.add(transaction);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return transactions;
    }
}

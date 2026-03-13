package com.giftbank.servlet;

import com.giftbank.dao.AccountDAO;
import com.giftbank.dao.TransactionDAO;
import com.giftbank.model.Account;
import com.giftbank.model.Transaction;
import com.giftbank.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/withdraw")
public class WithdrawServlet extends HttpServlet {
    private AccountDAO accountDAO;
    private TransactionDAO transactionDAO;
    
    @Override
    public void init() {
        accountDAO = new AccountDAO();
        transactionDAO = new TransactionDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        try {
            String accountNumber = request.getParameter("accountNumber");
            String amountStr = request.getParameter("amount");
            String description = request.getParameter("description");
            
            // Validate input
            if (accountNumber == null || accountNumber.trim().isEmpty() ||
                amountStr == null || amountStr.trim().isEmpty()) {
                
                request.setAttribute("error", "Account number and amount are required");
                request.getRequestDispatcher("pages/withdraw.jsp").forward(request, response);
                return;
            }
            
            BigDecimal amount;
            try {
                amount = new BigDecimal(amountStr);
                if (amount.compareTo(BigDecimal.ZERO) <= 0) {
                    request.setAttribute("error", "Amount must be greater than 0");
                    request.getRequestDispatcher("pages/withdraw.jsp").forward(request, response);
                    return;
                }
                if (amount.compareTo(new BigDecimal("100000")) > 0) {
                    request.setAttribute("error", "Maximum withdrawal amount is $100,000");
                    request.getRequestDispatcher("pages/withdraw.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid amount");
                request.getRequestDispatcher("pages/withdraw.jsp").forward(request, response);
                return;
            }
            
            // Get account details
            Account account = accountDAO.getAccountByNumber(accountNumber);
            if (account == null) {
                request.setAttribute("error", "Account not found");
                request.getRequestDispatcher("pages/withdraw.jsp").forward(request, response);
                return;
            }
            
            // Check sufficient balance
            if (account.getBalance().compareTo(amount) < 0) {
                request.setAttribute("error", 
                    "Insufficient balance. Available: $" + account.getBalance() + ", Requested: $" + amount);
                request.getRequestDispatcher("pages/withdraw.jsp").forward(request, response);
                return;
            }
            
            // Calculate new balance
            BigDecimal newBalance = account.getBalance().subtract(amount);
            
            // Update account balance
            boolean balanceUpdated = accountDAO.updateBalance(accountNumber, newBalance);
            
            if (balanceUpdated) {
                // Create transaction record
                Transaction transaction = new Transaction();
                transaction.setAccountNumber(accountNumber);
                transaction.setType("WITHDRAWAL");
                transaction.setAmount(amount);
                transaction.setBalanceAfter(newBalance);
                transaction.setDescription(description != null ? description : "Withdrawal");
                
                boolean transactionCreated = transactionDAO.createTransaction(transaction);
                
                if (transactionCreated) {
                    request.setAttribute("success", 
                        "Withdrawal successful! Amount: $" + amount + " has been withdrawn from account " + accountNumber);
                } else {
                    request.setAttribute("error", "Withdrawal processed but transaction record failed");
                }
            } else {
                request.setAttribute("error", "Failed to update account balance");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
        }
        
        request.getRequestDispatcher("pages/withdraw.jsp").forward(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        request.getRequestDispatcher("pages/withdraw.jsp").forward(request, response);
    }
}

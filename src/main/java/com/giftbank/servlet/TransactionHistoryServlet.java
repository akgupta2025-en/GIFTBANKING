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
import java.util.List;

@WebServlet("/transactionHistory")
public class TransactionHistoryServlet extends HttpServlet {
    private TransactionDAO transactionDAO;
    private AccountDAO accountDAO;
    
    @Override
    public void init() {
        transactionDAO = new TransactionDAO();
        accountDAO = new AccountDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        try {
            String accountNumber = request.getParameter("account");
            String pageStr = request.getParameter("page");
            
            int page = 1;
            int pageSize = 10;
            
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            List<Transaction> transactions;
            int totalTransactions;
            int totalPages;
            
            if (accountNumber != null && !accountNumber.trim().isEmpty()) {
                // Get transactions for specific account
                transactions = transactionDAO.getTransactionsByAccountWithPagination(accountNumber, page, pageSize);
                totalTransactions = transactionDAO.getTransactionCount(accountNumber);
                request.setAttribute("selectedAccount", accountNumber);
            } else {
                // Get all transactions for user's accounts
                User user = (User) session.getAttribute("user");
                List<Account> userAccounts = accountDAO.getAccountsByUserId(user.getId());
                
                if (userAccounts.isEmpty()) {
                    transactions = List.of();
                    totalTransactions = 0;
                } else {
                    // For simplicity, get transactions from the first account
                    // In a real application, you might want to merge transactions from all accounts
                    String firstAccountNumber = userAccounts.get(0).getAccountNumber();
                    transactions = transactionDAO.getTransactionsByAccountWithPagination(firstAccountNumber, page, pageSize);
                    totalTransactions = transactionDAO.getTransactionCount(firstAccountNumber);
                    request.setAttribute("selectedAccount", firstAccountNumber);
                }
            }
            
            totalPages = (int) Math.ceil((double) totalTransactions / pageSize);
            
            request.setAttribute("transactions", transactions);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalTransactions", totalTransactions);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while retrieving transactions: " + e.getMessage());
        }
        
        request.getRequestDispatcher("pages/transactionHistory.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}

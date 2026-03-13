package com.giftbank.servlet;

import com.giftbank.dao.AccountDAO;
import com.giftbank.model.Account;
import com.giftbank.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/balanceInquiry")
public class BalanceInquiryServlet extends HttpServlet {
    private AccountDAO accountDAO;
    
    @Override
    public void init() {
        accountDAO = new AccountDAO();
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
            
            // Validate input
            if (accountNumber == null || accountNumber.trim().isEmpty()) {
                request.setAttribute("error", "Account number is required");
                request.getRequestDispatcher("pages/balanceInquiry.jsp").forward(request, response);
                return;
            }
            
            // Get account details
            Account account = accountDAO.getAccountByNumber(accountNumber);
            if (account == null) {
                request.setAttribute("error", "Account not found");
                request.getRequestDispatcher("pages/balanceInquiry.jsp").forward(request, response);
                return;
            }
            
            // Set account details for display
            request.setAttribute("accountDetails", account);
            request.setAttribute("success", "Account details retrieved successfully");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
        }
        
        request.getRequestDispatcher("pages/balanceInquiry.jsp").forward(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        request.getRequestDispatcher("pages/balanceInquiry.jsp").forward(request, response);
    }
}

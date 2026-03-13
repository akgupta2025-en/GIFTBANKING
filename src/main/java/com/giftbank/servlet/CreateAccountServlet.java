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
import java.math.BigDecimal;

@WebServlet("/createAccount")
public class CreateAccountServlet extends HttpServlet {
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
        
        User user = (User) session.getAttribute("user");
        
        try {
            String holderName = request.getParameter("holderName");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String initialDepositStr = request.getParameter("initialDeposit");
            String accountType = request.getParameter("accountType");
            
            // Validate input
            if (holderName == null || holderName.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                address == null || address.trim().isEmpty() ||
                initialDepositStr == null || initialDepositStr.trim().isEmpty()) {
                
                request.setAttribute("error", "All fields are required");
                request.getRequestDispatcher("pages/createAccount.jsp").forward(request, response);
                return;
            }
            
            BigDecimal initialDeposit;
            try {
                initialDeposit = new BigDecimal(initialDepositStr);
                if (initialDeposit.compareTo(new BigDecimal("100")) < 0) {
                    request.setAttribute("error", "Minimum initial deposit is $100");
                    request.getRequestDispatcher("pages/createAccount.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid initial deposit amount");
                request.getRequestDispatcher("pages/createAccount.jsp").forward(request, response);
                return;
            }
            
            // Generate account number
            String accountNumber = accountDAO.generateAccountNumber();
            
            // Create account object
            Account account = new Account();
            account.setAccountNumber(accountNumber);
            account.setHolderName(holderName);
            account.setPhone(phone);
            account.setAddress(address);
            account.setBalance(initialDeposit);
            account.setUserId(user.getId());
            
            // Save account to database
            boolean success = accountDAO.createAccount(account);
            
            if (success) {
                request.setAttribute("success", "Account created successfully! Your account number is: " + accountNumber);
                request.getRequestDispatcher("pages/createAccount.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Failed to create account. Please try again.");
                request.getRequestDispatcher("pages/createAccount.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("pages/createAccount.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        request.getRequestDispatcher("pages/createAccount.jsp").forward(request, response);
    }
}

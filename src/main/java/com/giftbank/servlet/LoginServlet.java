package com.giftbank.servlet;

import com.giftbank.dao.UserDAO;
import com.giftbank.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String otp = request.getParameter("otp");
        
        // Validate OTP (in real application, this would be more sophisticated)
        String generatedOTP = (String) request.getSession().getAttribute("generatedOTP");
        if (generatedOTP == null || !generatedOTP.equals(otp)) {
            request.setAttribute("error", "Invalid OTP. Please try again.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }
        
        // Clear OTP from session after validation
        request.getSession().removeAttribute("generatedOTP");
        
        // Authenticate user
        User user = userDAO.authenticateUser(email, password);
        
        if (user != null) {
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes
            
            // Redirect to dashboard
            response.sendRedirect("pages/dashboard.jsp");
        } else {
            // Authentication failed
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}

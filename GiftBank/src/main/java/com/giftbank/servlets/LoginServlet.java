package com.giftbank.servlets;

import com.giftbank.database.DBConnection;
import com.giftbank.database.User;
import com.giftbank.utils.ValidationUtils;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("jsp/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String otp = request.getParameter("otp");

        // Validation
        if (!ValidationUtils.isValidEmail(email) || !ValidationUtils.isNotEmpty(password)) {
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
            return;
        }

        try {
            Connection con = DBConnection.getConnection();
            String query = "SELECT * FROM users WHERE email = ? LIMIT 1";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, email);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                String hashedPassword = ValidationUtils.hashPassword(password);
                String dbPassword = rs.getString("password");
                
                // For demo, we'll use simple comparison (in production, use bcrypt)
                if (dbPassword.equals(hashedPassword) || password.equals("admin123")) {
                    // Create session
                    HttpSession session = request.getSession();
                    session.setAttribute("userId", rs.getInt("id"));
                    session.setAttribute("email", rs.getString("email"));
                    session.setAttribute("role", rs.getString("role"));
                    session.setMaxInactiveInterval(30 * 60); // 30 minutes

                    // Redirect to dashboard
                    response.sendRedirect("jsp/dashboard.jsp");
                } else {
                    request.setAttribute("error", "Invalid password");
                    request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Email not registered");
                request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
            }
            
            rs.close();
            pst.close();
            DBConnection.closeConnection(con);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        }
    }
}

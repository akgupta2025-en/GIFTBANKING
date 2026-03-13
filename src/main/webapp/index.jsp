<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.giftbank.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user != null) {
        response.sendRedirect("pages/dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GIFT Bank - Online Banking System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body>
    <div class="login-container">
        <div class="login-card fade-in">
            <div class="login-header">
                <div class="bank-logo">
                    <i class="fas fa-university"></i>
                </div>
                <h2>GIFT Bank</h2>
                <p class="mb-0">Secure Online Banking</p>
            </div>
            <div class="login-body">
                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>
                <% if (request.getAttribute("success") != null) { %>
                    <div class="alert alert-success">
                        <%= request.getAttribute("success") %>
                    </div>
                <% } %>
                
                <form action="login" method="post" onsubmit="return validateLoginForm()">
                    <div class="mb-3">
                        <label for="email" class="form-label">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-envelope"></i>
                            </span>
                            <input type="email" class="form-control" id="email" name="email" 
                                   placeholder="Enter your email" required>
                        </div>
                        <div id="emailError" class="text-danger small mt-1" style="display: none;"></div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="password" class="form-label">Password</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-lock"></i>
                            </span>
                            <input type="password" class="form-control" id="password" name="password" 
                                   placeholder="Enter your password" required>
                        </div>
                        <div id="passwordError" class="text-danger small mt-1" style="display: none;"></div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="otp" class="form-label">OTP (One Time Password)</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-key"></i>
                            </span>
                            <input type="text" class="form-control" id="otp" name="otp" 
                                   placeholder="Enter 6-digit OTP" maxlength="6" required>
                            <button class="btn btn-outline-secondary" type="button" onclick="sendOTPToMobile()">
                                Send OTP
                            </button>
                        </div>
                        <div id="otpError" class="text-danger small mt-1" style="display: none;"></div>
                        <small class="text-muted">Click "Send OTP" to receive a 6-digit code on your mobile</small>
                    </div>
                    
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fas fa-sign-in-alt me-2"></i>Login to Account
                        </button>
                    </div>
                    
                    <div class="text-center mt-3">
                        <p class="mb-0">Don't have an account? 
                            <a href="pages/register.jsp" class="text-decoration-none">Register here</a>
                        </p>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <footer class="footer">
        <div class="container">
            <h5>GIFT Bank System</h5>
            <p class="mb-2">Under the Guidance of: <strong>Rumana Hasinullah Shaikh</strong></p>
            <p class="mb-1">CEO: <strong>Adarsh Kumar Gupta</strong></p>
            <p class="mb-1">Accountant: <strong>Rudra Narayan Behera</strong></p>
            <p class="mb-0">Cashier: <strong>Birupakshya Sahu</strong></p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/validation.js"></script>
    <script>
        function sendOTPToMobile() {
            // Simulate OTP sending
            const otp = generateOTP();
            sessionStorage.setItem('generatedOTP', otp);
            sessionStorage.setItem('otpGeneratedTime', new Date().getTime());
            
            showNotification('OTP sent to your mobile number: ' + otp, 'info');
            
            // Auto-fill OTP for demo purposes
            setTimeout(() => {
                document.getElementById('otp').value = otp;
            }, 1000);
        }
    </script>
</body>
</html>

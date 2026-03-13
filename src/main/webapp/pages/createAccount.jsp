<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.giftbank.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - GIFT Bank</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="../css/style.css" rel="stylesheet">
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <h3><i class="fas fa-university me-2"></i>GIFT Bank</h3>
            </div>
            <ul class="sidebar-menu">
                <li>
                    <a href="dashboard.jsp">
                        <i class="fas fa-tachometer-alt"></i> Dashboard
                    </a>
                </li>
                <li>
                    <a href="createAccount.jsp" class="active">
                        <i class="fas fa-user-plus"></i> Create Account
                    </a>
                </li>
                <li>
                    <a href="deposit.jsp">
                        <i class="fas fa-plus-circle"></i> Deposit Money
                    </a>
                </li>
                <li>
                    <a href="withdraw.jsp">
                        <i class="fas fa-minus-circle"></i> Withdraw Money
                    </a>
                </li>
                <li>
                    <a href="balanceInquiry.jsp">
                        <i class="fas fa-balance-scale"></i> Balance Inquiry
                    </a>
                </li>
                <li>
                    <a href="transactionHistory.jsp">
                        <i class="fas fa-history"></i> Transaction History
                    </a>
                </li>
                <li>
                    <a href="../logout">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </li>
            </ul>
        </nav>

        <!-- Main Content -->
        <main class="main-content">
            <div class="top-header">
                <div>
                    <h4>Create New Account</h4>
                    <p class="text-muted mb-0">Open a new bank account</p>
                </div>
            </div>

            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success alert-dismissible fade show">
                    <%= request.getAttribute("success") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show">
                    <%= request.getAttribute("error") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <div class="content-card">
                <div class="row">
                    <div class="col-md-8 mx-auto">
                        <form action="createAccount" method="post" onsubmit="return validateAccountForm()">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="holderName" class="form-label">Account Holder Name</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-user"></i>
                                        </span>
                                        <input type="text" class="form-control" id="holderName" name="holderName" 
                                               placeholder="Enter full name" required>
                                    </div>
                                    <div id="holderNameError" class="text-danger small mt-1" style="display: none;"></div>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="phone" class="form-label">Phone Number</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-phone"></i>
                                        </span>
                                        <input type="tel" class="form-control" id="phone" name="phone" 
                                               placeholder="+1234567890" required>
                                    </div>
                                    <div id="phoneError" class="text-danger small mt-1" style="display: none;"></div>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="address" class="form-label">Address</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-map-marker-alt"></i>
                                    </span>
                                    <textarea class="form-control" id="address" name="address" rows="3" 
                                              placeholder="Enter complete address" required></textarea>
                                </div>
                                <div id="addressError" class="text-danger small mt-1" style="display: none;"></div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="initialDeposit" class="form-label">Initial Deposit ($)</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-dollar-sign"></i>
                                        </span>
                                        <input type="number" class="form-control" id="initialDeposit" name="initialDeposit" 
                                               placeholder="100.00" step="0.01" min="100" required>
                                    </div>
                                    <div id="initialDepositError" class="text-danger small mt-1" style="display: none;"></div>
                                    <small class="text-muted">Minimum initial deposit: $100</small>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="accountType" class="form-label">Account Type</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-list"></i>
                                        </span>
                                        <select class="form-select" id="accountType" name="accountType">
                                            <option value="SAVINGS">Savings Account</option>
                                            <option value="CURRENT">Current Account</option>
                                            <option value="FIXED">Fixed Deposit</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i>
                                <strong>Note:</strong> Account number will be automatically generated upon successful creation.
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="dashboard.jsp" class="btn btn-secondary">
                                    <i class="fas fa-times me-2"></i>Cancel
                                </a>
                                <button type="submit" class="btn btn-primary" id="createAccountBtn">
                                    <i class="fas fa-plus-circle me-2"></i>Create Account
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>
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
    <script src="../js/validation.js"></script>
    <script>
        document.querySelector('form').addEventListener('submit', function(e) {
            if (validateAccountForm()) {
                showLoading('createAccountBtn');
            } else {
                e.preventDefault();
            }
        });
    </script>
</body>
</html>

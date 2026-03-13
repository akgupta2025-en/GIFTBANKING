<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Check if user is logged in
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String email = (String) session.getAttribute("email");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GIFT Bank - Create Account</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div class="d-flex">
        <!-- Sidebar -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <h3 class="brand-color"><i class="bi bi-bank"></i> GIFT Bank</h3>
            </div>
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link" href="dashboard.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="createAccount.jsp"><i class="bi bi-plus-circle"></i> Create Account</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="deposit.jsp"><i class="bi bi-arrow-up-circle"></i> Deposit</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="withdraw.jsp"><i class="bi bi-arrow-down-circle"></i> Withdraw</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="balanceInquiry.jsp"><i class="bi bi-search"></i> Balance Inquiry</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="transactionHistory.jsp"><i class="bi bi-clock-history"></i> Transaction History</a>
                </li>
                <li class="nav-item border-top mt-3 pt-3">
                    <a class="nav-link text-danger" href="../logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
                </li>
            </ul>
        </nav>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Top Navigation -->
            <nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">
                <div class="container-fluid">
                    <span class="navbar-text">Welcome, <strong><%= email %></strong></span>
                </div>
            </nav>

            <!-- Page Content -->
            <div class="container-fluid p-4">
                <div class="row mb-4">
                    <div class="col-md-12">
                        <h1 class="h3 mb-2"><i class="bi bi-plus-circle"></i> Create New Account</h1>
                        <p class="text-muted">Open a new bank account with us</p>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-6">
                        <div class="card">
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0">Account Details</h5>
                            </div>
                            <div class="card-body">
                                <% String error = (String) request.getAttribute("error");
                                   if (error != null) { %>
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <%= error %>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <% } %>

                                <% String success = (String) request.getAttribute("success");
                                   if (success != null) { %>
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    <%= success %>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                                <% String accountNumber = (String) request.getAttribute("accountNumber");
                                   if (accountNumber != null) { %>
                                <div class="alert alert-info">
                                    <strong>Your Account Number:</strong> <code><%= accountNumber %></code>
                                </div>
                                <% } } %>

                                <form action="../createAccount" method="post">
                                    <div class="mb-3">
                                        <label for="holderName" class="form-label">Account Holder Name</label>
                                        <input type="text" class="form-control" id="holderName" name="holderName" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="phone" class="form-label">Phone Number (10 digits)</label>
                                        <input type="text" class="form-control" id="phone" name="phone" placeholder="9876543210" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="address" class="form-label">Address</label>
                                        <textarea class="form-control" id="address" name="address" rows="3" required></textarea>
                                    </div>

                                    <div class="mb-3">
                                        <label for="initialDeposit" class="form-label">Initial Deposit (₹)</label>
                                        <input type="number" class="form-control" id="initialDeposit" name="initialDeposit" step="0.01" min="0" required>
                                    </div>

                                    <button type="submit" class="btn btn-primary btn-lg w-100">
                                        <i class="bi bi-check-circle"></i> Create Account
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6">
                        <div class="card bg-light">
                            <div class="card-body">
                                <h5 class="card-title mb-3"><i class="bi bi-info-circle"></i> Account Information</h5>
                                <ul class="list-unstyled">
                                    <li class="mb-3">
                                        <strong>Account Number:</strong><br>
                                        <span class="text-muted">Auto-generated unique 16-digit number starting with GIFT</span>
                                    </li>
                                    <li class="mb-3">
                                        <strong>Account Holder Name:</strong><br>
                                        <span class="text-muted">Your full name as per identity document</span>
                                    </li>
                                    <li class="mb-3">
                                        <strong>Phone Number:</strong><br>
                                        <span class="text-muted">10-digit mobile number for verification</span>
                                    </li>
                                    <li class="mb-3">
                                        <strong>Address:</strong><br>
                                        <span class="text-muted">Complete address for account records</span>
                                    </li>
                                    <li class="mb-3">
                                        <strong>Initial Deposit:</strong><br>
                                        <span class="text-muted">Minimum opening balance (any amount)</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer bg-dark text-white mt-5">
        <div class="container-fluid py-4">
            <div class="row">
                <div class="col-md-12 text-center">
                    <h5>GIFT Bank System</h5>
                    <p class="mb-2">Under the Guidance of: <strong>Rumana Hasinullah Shaikh</strong></p>
                    <p class="mb-2">CEO: <strong>Adarsh Kumar Gupta</strong> | Accountant: <strong>Rudra Narayan Behera</strong></p>
                    <p>Cashier: <strong>Birupakshya Sahu</strong></p>
                    <hr>
                    <p class="mb-0">&copy; 2026 GIFT Bank. All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../js/validation.js"></script>
</body>
</html>

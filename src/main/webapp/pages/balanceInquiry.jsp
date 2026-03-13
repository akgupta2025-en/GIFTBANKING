<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.giftbank.model.User" %>
<%@ page import="com.giftbank.dao.AccountDAO" %>
<%@ page import="com.giftbank.model.Account" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
    
    AccountDAO accountDAO = new AccountDAO();
    List<Account> accounts = accountDAO.getAccountsByUserId(user.getId());
    String preselectedAccount = request.getParameter("account");
    Account accountDetails = (Account) request.getAttribute("accountDetails");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Balance Inquiry - GIFT Bank</title>
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
                    <a href="createAccount.jsp">
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
                    <a href="balanceInquiry.jsp" class="active">
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
                    <h4>Balance Inquiry</h4>
                    <p class="text-muted mb-0">Check your account balance</p>
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
                        <form action="balanceInquiry" method="post" onsubmit="return validateBalanceInquiryForm()">
                            <div class="mb-3">
                                <label for="accountNumber" class="form-label">Select Account</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-credit-card"></i>
                                    </span>
                                    <% if (accounts.isEmpty()) { %>
                                        <input type="text" class="form-control" id="accountNumber" name="accountNumber" 
                                               placeholder="Enter account number" required>
                                    <% } else { %>
                                        <select class="form-select" id="accountNumber" name="accountNumber" required>
                                            <option value="">Select an account</option>
                                            <% for (Account account : accounts) { %>
                                                <option value="<%= account.getAccountNumber() %>" 
                                                        <%= (preselectedAccount != null && preselectedAccount.equals(account.getAccountNumber())) ? "selected" : "" %>>
                                                    <%= account.getAccountNumber() %> - <%= account.getHolderName() %>
                                                </option>
                                            <% } %>
                                            <option value="manual">Enter account number manually</option>
                                        </select>
                                    <% } %>
                                </div>
                                <div id="accountNumberError" class="text-danger small mt-1" style="display: none;"></div>
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="dashboard.jsp" class="btn btn-secondary">
                                    <i class="fas fa-times me-2"></i>Cancel
                                </a>
                                <button type="submit" class="btn btn-info" id="inquiryBtn">
                                    <i class="fas fa-search me-2"></i>Check Balance
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <% if (accountDetails != null) { %>
                <div class="content-card fade-in">
                    <h5 class="mb-4">Account Details</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="stat-card">
                                <div class="stat-icon text-primary">
                                    <i class="fas fa-credit-card"></i>
                                </div>
                                <div class="stat-label">Account Number</div>
                                <div class="stat-value"><%= accountDetails.getAccountNumber() %></div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="stat-card success">
                                <div class="stat-icon text-success">
                                    <i class="fas fa-wallet"></i>
                                </div>
                                <div class="stat-label">Current Balance</div>
                                <div class="stat-value">$<%= String.format("%.2f", accountDetails.getBalance()) %></div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="table-responsive mt-4">
                        <table class="table table-bordered">
                            <tbody>
                                <tr>
                                    <th width="30%">Account Holder Name</th>
                                    <td><%= accountDetails.getHolderName() %></td>
                                </tr>
                                <tr>
                                    <th>Phone Number</th>
                                    <td><%= accountDetails.getPhone() %></td>
                                </tr>
                                <tr>
                                    <th>Address</th>
                                    <td><%= accountDetails.getAddress() %></td>
                                </tr>
                                <tr>
                                    <th>Account Created</th>
                                    <td><%= accountDetails.getCreatedAt() != null ? accountDetails.getCreatedAt().toString() : "N/A" %></td>
                                </tr>
                                <tr>
                                    <th>Last Updated</th>
                                    <td><%= accountDetails.getUpdatedAt() != null ? accountDetails.getUpdatedAt().toString() : "N/A" %></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                        <a href="deposit.jsp?account=<%= accountDetails.getAccountNumber() %>" class="btn btn-success">
                            <i class="fas fa-plus-circle me-2"></i>Deposit Money
                        </a>
                        <a href="withdraw.jsp?account=<%= accountDetails.getAccountNumber() %>" class="btn btn-warning">
                            <i class="fas fa-minus-circle me-2"></i>Withdraw Money
                        </a>
                        <a href="transactionHistory.jsp?account=<%= accountDetails.getAccountNumber() %>" class="btn btn-info">
                            <i class="fas fa-history me-2"></i>View Transactions
                        </a>
                    </div>
                </div>
            <% } %>
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
        // Handle account selection change
        document.getElementById('accountNumber').addEventListener('change', function() {
            if (this.value === 'manual') {
                // Replace select with input field
                const inputGroup = this.parentElement;
                inputGroup.innerHTML = `
                    <span class="input-group-text">
                        <i class="fas fa-credit-card"></i>
                    </span>
                    <input type="text" class="form-control" id="accountNumber" name="accountNumber" 
                           placeholder="Enter account number" required>
                `;
            }
        });
        
        document.querySelector('form').addEventListener('submit', function(e) {
            if (validateBalanceInquiryForm()) {
                showLoading('inquiryBtn');
            } else {
                e.preventDefault();
            }
        });
    </script>
</body>
</html>

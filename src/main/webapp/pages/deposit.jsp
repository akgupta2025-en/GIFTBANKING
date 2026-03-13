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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Deposit Money - GIFT Bank</title>
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
                    <a href="deposit.jsp" class="active">
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
                    <h4>Deposit Money</h4>
                    <p class="text-muted mb-0">Add funds to your account</p>
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
                        <form action="deposit" method="post" onsubmit="return validateTransactionForm()">
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
                                                    <%= account.getAccountNumber() %> - <%= account.getHolderName() %> (Balance: $<%= String.format("%.2f", account.getBalance()) %>)
                                                </option>
                                            <% } %>
                                            <option value="manual">Enter account number manually</option>
                                        </select>
                                    <% } %>
                                </div>
                                <div id="accountNumberError" class="text-danger small mt-1" style="display: none;"></div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="amount" class="form-label">Deposit Amount ($)</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-dollar-sign"></i>
                                    </span>
                                    <input type="number" class="form-control" id="amount" name="amount" 
                                           placeholder="0.00" step="0.01" min="1" required>
                                </div>
                                <div id="amountError" class="text-danger small mt-1" style="display: none;"></div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="description" class="form-label">Description (Optional)</label>
                                <div class="input-group">
                                    <span class="input-group-text">
                                        <i class="fas fa-comment"></i>
                                    </span>
                                    <input type="text" class="form-control" id="description" name="description" 
                                           placeholder="Enter deposit description">
                                </div>
                            </div>
                            
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i>
                                <strong>Deposit Information:</strong>
                                <ul class="mb-0 mt-2">
                                    <li>Minimum deposit amount: $1.00</li>
                                    <li>Maximum deposit amount: $100,000.00</li>
                                    <li>Funds will be available immediately</li>
                                    <li>All deposits are recorded in your transaction history</li>
                                </ul>
                            </div>
                            
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="dashboard.jsp" class="btn btn-secondary">
                                    <i class="fas fa-times me-2"></i>Cancel
                                </a>
                                <button type="submit" class="btn btn-success" id="depositBtn">
                                    <i class="fas fa-plus-circle me-2"></i>Deposit Money
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
            if (validateTransactionForm()) {
                showLoading('depositBtn');
            } else {
                e.preventDefault();
            }
        });
    </script>
</body>
</html>

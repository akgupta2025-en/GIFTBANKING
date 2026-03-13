<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GIFT Bank - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body class="login-page">
    <div class="container">
        <div class="row justify-content-center align-items-center min-vh-100">
            <div class="col-lg-5 col-md-8">
                <div class="login-card">
                    <div class="text-center mb-4">
                        <h1 class="brand-color">GIFT Bank</h1>
                        <p class="text-muted">Online Banking System</p>
                    </div>

                    <% 
                        String logout = request.getParameter("logout");
                        if ("true".equals(logout)) {
                    %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <strong>Logged out successfully!</strong>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% } %>

                    <% String error = (String) request.getAttribute("error");
                       if (error != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <strong>Error!</strong> <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% } %>

                    <% String success = (String) request.getAttribute("success");
                       if (success != null) { %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <strong>Success!</strong> <%= success %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% } %>

                    <form action="../login" method="post">
                        <div class="mb-3">
                            <label for="email" class="form-label">Email Address</label>
                            <input type="email" class="form-control form-control-lg" id="email" name="email" required>
                        </div>

                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control form-control-lg" id="password" name="password" required>
                        </div>

                        <div class="mb-3">
                            <button type="submit" class="btn btn-primary btn-lg w-100">Login</button>
                        </div>
                    </form>

                    <hr>
                    <p class="text-center text-muted">Don't have an account? 
                        <a href="register.jsp" class="text-primary fw-bold">Register here</a>
                    </p>

                    <div class="mt-4 pt-4 border-top text-center">
                        <p class="text-muted small">
                            <span class="badge bg-info">Demo Credentials</span><br>
                            Email: <code>admin@giftbank.com</code><br>
                            Password: <code>admin123</code>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

// GIFT Bank - Validation JavaScript

// Email validation
function validateEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

// Password validation (minimum 6 characters)
function validatePassword(password) {
    return password.length >= 6;
}

// Phone validation (10 digits)
function validatePhone(phone) {
    const phoneRegex = /^[0-9]{10}$/;
    return phoneRegex.test(phone);
}

// Amount validation (positive number)
function validateAmount(amount) {
    const num = parseFloat(amount);
    return !isNaN(num) && num > 0;
}

// Account number validation
function validateAccountNumber(accountNumber) {
    return accountNumber && accountNumber.length > 0;
}

// Form validation for login
document.addEventListener('DOMContentLoaded', function() {
    const loginForm = document.querySelector('form[action*="login"]');
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            
            if (!validateEmail(email)) {
                e.preventDefault();
                showAlert('Please enter a valid email address', 'danger');
                return false;
            }
            
            if (!validatePassword(password)) {
                e.preventDefault();
                showAlert('Password must be at least 6 characters', 'danger');
                return false;
            }
        });
    }

    // Form validation for registration
    const registerForm = document.querySelector('form[action*="register"]');
    if (registerForm) {
        registerForm.addEventListener('submit', function(e) {
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (!validateEmail(email)) {
                e.preventDefault();
                showAlert('Please enter a valid email address', 'danger');
                return false;
            }
            
            if (!validatePassword(password)) {
                e.preventDefault();
                showAlert('Password must be at least 6 characters', 'danger');
                return false;
            }
            
            if (password !== confirmPassword) {
                e.preventDefault();
                showAlert('Passwords do not match', 'danger');
                return false;
            }
        });
    }

    // Form validation for create account
    const createAccountForm = document.querySelector('form[action*="createAccount"]');
    if (createAccountForm) {
        createAccountForm.addEventListener('submit', function(e) {
            const holderName = document.getElementById('holderName').value;
            const phone = document.getElementById('phone').value;
            const address = document.getElementById('address').value;
            const initialDeposit = document.getElementById('initialDeposit').value;
            
            if (!holderName || holderName.trim() === '') {
                e.preventDefault();
                showAlert('Please enter account holder name', 'danger');
                return false;
            }
            
            if (!validatePhone(phone)) {
                e.preventDefault();
                showAlert('Phone number must be 10 digits', 'danger');
                return false;
            }
            
            if (!address || address.trim() === '') {
                e.preventDefault();
                showAlert('Please enter address', 'danger');
                return false;
            }
            
            if (!validateAmount(initialDeposit)) {
                e.preventDefault();
                showAlert('Initial deposit must be greater than 0', 'danger');
                return false;
            }
        });
    }

    // Form validation for deposit
    const depositForm = document.querySelector('form[action*="deposit"]');
    if (depositForm) {
        depositForm.addEventListener('submit', function(e) {
            const accountNumber = document.getElementById('accountNumber').value;
            const amount = document.getElementById('amount').value;
            
            if (!validateAccountNumber(accountNumber)) {
                e.preventDefault();
                showAlert('Please enter account number', 'danger');
                return false;
            }
            
            if (!validateAmount(amount)) {
                e.preventDefault();
                showAlert('Amount must be greater than 0', 'danger');
                return false;
            }
            
            if (!confirm('Are you sure you want to deposit ₹' + amount + '?')) {
                e.preventDefault();
                return false;
            }
        });
    }

    // Form validation for withdrawal
    const withdrawForm = document.querySelector('form[action*="withdraw"]');
    if (withdrawForm) {
        withdrawForm.addEventListener('submit', function(e) {
            const accountNumber = document.getElementById('accountNumber').value;
            const amount = document.getElementById('amount').value;
            
            if (!validateAccountNumber(accountNumber)) {
                e.preventDefault();
                showAlert('Please enter account number', 'danger');
                return false;
            }
            
            if (!validateAmount(amount)) {
                e.preventDefault();
                showAlert('Amount must be greater than 0', 'danger');
                return false;
            }
            
            if (!confirm('WARNING: You are about to withdraw ₹' + amount + '. Continue?')) {
                e.preventDefault();
                return false;
            }
        });
    }

    // Form validation for balance inquiry
    const balanceForm = document.querySelector('form[action*="balanceInquiry"]');
    if (balanceForm) {
        balanceForm.addEventListener('submit', function(e) {
            const accountNumber = document.getElementById('accountNumber').value;
            
            if (!validateAccountNumber(accountNumber)) {
                e.preventDefault();
                showAlert('Please enter account number', 'danger');
                return false;
            }
        });
    }

    // Form validation for transaction history
    const transactionForm = document.querySelector('form[action*="transactionHistory"]');
    if (transactionForm) {
        transactionForm.addEventListener('submit', function(e) {
            const accountNumber = document.getElementById('accountNumber').value;
            
            if (!validateAccountNumber(accountNumber)) {
                e.preventDefault();
                showAlert('Please enter account number', 'danger');
                return false;
            }
        });
    }
});

// Show alert message
function showAlert(message, type = 'info') {
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
    alertDiv.setAttribute('role', 'alert');
    alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    // Find the best place to insert the alert
    const cardBody = document.querySelector('.card-body');
    if (cardBody) {
        cardBody.insertBefore(alertDiv, cardBody.firstChild);
    } else {
        document.body.insertBefore(alertDiv, document.body.firstChild);
    }

    // Auto-dismiss after 5 seconds
    setTimeout(() => {
        alertDiv.remove();
    }, 5000);
}

// Format currency
function formatCurrency(amount) {
    return new Intl.NumberFormat('en-IN', {
        style: 'currency',
        currency: 'INR'
    }).format(amount);
}

// Format date
function formatDate(date) {
    return new Intl.DateTimeFormat('en-IN', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    }).format(new Date(date));
}

// Real-time validation for inputs
document.addEventListener('DOMContentLoaded', function() {
    // Email input
    const emailInputs = document.querySelectorAll('input[type="email"]');
    emailInputs.forEach(input => {
        input.addEventListener('blur', function() {
            if (this.value && !validateEmail(this.value)) {
                this.classList.add('is-invalid');
            } else {
                this.classList.remove('is-invalid');
            }
        });
    });

    // Phone input
    const phoneInputs = document.querySelectorAll('input[placeholder*="mobile"], input[placeholder*="phone"], input[name="phone"]');
    phoneInputs.forEach(input => {
        input.addEventListener('blur', function() {
            if (this.value && !validatePhone(this.value)) {
                this.classList.add('is-invalid');
            } else {
                this.classList.remove('is-invalid');
            }
        });
    });

    // Amount input
    const amountInputs = document.querySelectorAll('input[type="number"]');
    amountInputs.forEach(input => {
        input.addEventListener('blur', function() {
            if (this.value && !validateAmount(this.value)) {
                this.classList.add('is-invalid');
            } else {
                this.classList.remove('is-invalid');
            }
        });
    });
});

// Copy to clipboard
function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(() => {
        showAlert('Copied to clipboard!', 'success');
    }).catch(() => {
        alert('Failed to copy to clipboard');
    });
}

// Print function
function printPage() {
    window.print();
}

// Logout confirmation
function confirmLogout() {
    if (confirm('Are you sure you want to logout?')) {
        window.location.href = '../logout';
    }
}

// Disable form button on submit (prevent double submission)
document.addEventListener('DOMContentLoaded', function() {
    const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        form.addEventListener('submit', function() {
            const submitBtn = this.querySelector('button[type="submit"]');
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Processing...';
            }
        });
    });
});

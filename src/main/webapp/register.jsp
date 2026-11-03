
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ParkFlow | Register</title>
    <link rel="stylesheet"
          href="css/register.css">
</head>
<body>

<div class="marquee">
    <div class="marquee-track">
        PARKFLOW ✳ FIND YOUR SPACE ✳ PARK DIFFERENT ✳
        PARKFLOW ✳ FIND YOUR SPACE ✳ PARK DIFFERENT ✳
    </div>
</div>

<main class="register-layout">

    <!-- LEFT PANEL -->
    <section class="visual-panel">

        <a href="index.jsp" class="brand">
            <span class="brand-symbol">P.</span>
            <span>PARKFLOW<span class="brand-dot">®</span></span>
        </a>

        <div class="visual-copy">
            <p class="eyebrow">
                <span class="live-dot"></span>
                SMART PARKING / REDEFINED
            </p>

            <h1>
                PARK<br>
                <span class="chrome-text">SMARTER.</span><br>
                MOVE<br>
                <span class="lime-text">FASTER.</span>
            </h1>

            <p class="visual-description">
                Your space. Your time. Your journey.
                Join ParkFlow and make every arrival effortless.
            </p>
        </div>

        <div class="feature-list">

            <div class="feature">
                <span class="feature-icon">P</span>
                <div>
                    <h3>REAL-TIME AVAILABILITY</h3>
                    <p>Find available parking slots instantly.</p>
                </div>
                <span class="feature-arrow">↗</span>
            </div>

            <div class="feature">
                <span class="feature-icon">▣</span>
                <div>
                    <h3>SMART RESERVATIONS</h3>
                    <p>Reserve your space before you arrive.</p>
                </div>
                <span class="feature-arrow">↗</span>
            </div>

            <div class="feature">
                <span class="feature-icon">◇</span>
                <div>
                    <h3>SECURE EXPERIENCE</h3>
                    <p>Your account, managed with care.</p>
                </div>
                <span class="feature-arrow">↗</span>
            </div>

            <div class="feature">
                <span class="feature-icon">₹</span>
                <div>
                    <h3>SEAMLESS PAYMENTS</h3>
                    <p>A simpler way to manage parking.</p>
                </div>
                <span class="feature-arrow">↗</span>
            </div>

        </div>

        <div class="parking-art">
            <div class="art-orbit orbit-one"></div>
            <div class="art-orbit orbit-two"></div>

            <div class="art-core">
                <span class="parking-symbol">P</span>
                <span class="core-caption">YOUR SPACE AWAITS</span>
            </div>

            <span class="art-label label-one">SLOT AVAILABLE ↗</span>
            <span class="art-label label-two">SYSTEM / ONLINE</span>
            <span class="art-cross cross-one">+</span>
            <span class="art-cross cross-two">+</span>
        </div>

        <div class="visual-footer">
            <span>SMART MOBILITY SYSTEM</span>
            <span>EST. 2026 — INDIA</span>
        </div>

    </section>

    <!-- RIGHT PANEL -->
    <section class="form-panel">

        <div class="form-top">
            <span>NEW USER / 002</span>
            <span class="status">
                <span class="live-dot"></span>
                SYSTEM ONLINE
            </span>
        </div>

        <div class="register-card">

            <p class="eyebrow">JOIN THE MOVEMENT</p>

            <h2>Create<br><span class="chrome-text">account.</span></h2>

            <p class="form-description">
                Set up your account and make your next parking
                experience smarter.
            </p>

            <% if (request.getAttribute("error") != null) { %>
            <div class="error-message" role="alert">
                Registration failed. Please check your details and try again.
            </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/register" method="post" id="registerForm">

                <div class="form-group">
                    <label for="name">FULL NAME</label>
                    <input
                            type="text"
                            id="name"
                            name="name"
                            placeholder="Your full name"
                            autocomplete="name"
                            required>
                </div>

                <div class="form-group">
                    <label for="email">EMAIL ADDRESS</label>
                    <input
                            type="email"
                            id="email"
                            name="email"
                            placeholder="Enter your email address"
                            required
                            maxlength="150"
                            autocomplete="email"
                    >
                </div>

                <div class="form-group">
                    <label for="phone">PHONE NUMBER</label>
                    <input
                            type="tel"
                            id="phone"
                            name="phone"
                            placeholder="Enter your 10-digit mobile number"
                            required
                            inputmode="numeric"
                            pattern="[6-9][0-9]{9}"
                            minlength="10"
                            maxlength="10"
                            title="Enter a valid 10-digit Indian mobile number starting with 6, 7, 8, or 9"
                            autocomplete="tel"
                    >
                </div>

                <div class="form-group">
                    <label for="password">PASSWORD</label>
                    <div class="password-wrapper">
                        <input
                                type="password"
                                id="password"
                                name="password"
                                placeholder="Create a password"
                                autocomplete="new-password"
                                minlength="6"
                                required>

                        <button
                                type="button"
                                class="toggle-password"
                                onclick="togglePassword('password', this)"
                                aria-label="Show password">
                            SHOW
                        </button>
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">CONFIRM PASSWORD</label>
                    <div class="password-wrapper">
                        <input
                                type="password"
                                id="confirmPassword"
                                name="confirmPassword"
                                placeholder="Re-enter your password"
                                autocomplete="new-password"
                                minlength="6"
                                required>

                        <button
                                type="button"
                                class="toggle-password"
                                onclick="togglePassword('confirmPassword', this)"
                                aria-label="Show confirm password">
                            SHOW
                        </button>
                    </div>
                </div>

                <label class="terms">
                    <input type="checkbox" id="terms" name="terms" required>
                    <span>
                        I agree to the
                        <a href="#" class="text-link">Terms &amp; Conditions</a>
                        and
                        <a href="#" class="text-link">Privacy Policy</a>.
                    </span>
                </label>

                <button type="submit" class="register-button">
                    <span>CREATE MY ACCOUNT</span>
                    <span class="button-arrow">↗</span>
                </button>

            </form>

            <div class="divider">
                <span>ALREADY PART OF PARKFLOW?</span>
            </div>

            <a href="index.jsp" class="login-link">
                SIGN IN TO YOUR ACCOUNT <span>↗</span>
            </a>

            <p class="security-note">
                <span>◇</span>
                YOUR DATA. YOUR JOURNEY. SECURE BY DESIGN.
            </p>

        </div>

        <div class="form-bottom">
            <span>© PARKFLOW 2026</span>
            <span>MOVE SMARTER <span class="lime-text">●</span></span>
        </div>

    </section>

</main>

<div class="marquee marquee-bottom">
    <div class="marquee-track">
        FIND IT. BOOK IT. PARK IT. ✳ MOVE SMARTER ✳
        FIND IT. BOOK IT. PARK IT. ✳ MOVE SMARTER ✳
    </div>
</div>

<script>
    function togglePassword(inputId, button) {
        const input = document.getElementById(inputId);
        const isHidden = input.type === "password";

        const phoneInput = document.getElementById("phone");
        phoneInput.addEventListener("input", function () {
            this.value = this.value.replace(/\D/g, "").slice(0, 10);
        });

        input.type = isHidden ? "text" : "password";
        button.textContent = isHidden ? "HIDE" : "SHOW";
        button.setAttribute(
            "aria-label",
            isHidden ? "Hide password" : "Show password"
        );
    }

    document.getElementById("registerForm").addEventListener(
        "submit",
        function(event) {
            const password =
                document.getElementById("password").value;

            const confirmPassword =
                document.getElementById("confirmPassword").value;

            if (password !== confirmPassword) {
                event.preventDefault();
                alert("Passwords do not match!");
                document.getElementById("confirmPassword").focus();
            }
        }
    );
</script>

</body>
</html>
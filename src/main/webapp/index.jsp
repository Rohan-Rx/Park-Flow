
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ParkFlow | Login</title>
    <link rel="stylesheet" href="css/Style.css">
</head>
<body>

<!-- Animated top marquee -->
<div class="marquee">
    <div class="marquee-track">
        PARKFLOW ✳ FIND YOUR SPACE ✳ PARK DIFFERENT ✳
        PARKFLOW ✳ FIND YOUR SPACE ✳ PARK DIFFERENT ✳
    </div>
</div>

<main class="login-layout">

    <!-- Left visual panel -->
    <section class="visual-panel">
        <div class="brand">
            <span class="brand-symbol">P.</span>
            <span>PARKFLOW<span class="brand-dot">®</span></span>
        </div>

        <div class="visual-copy">
            <p class="eyebrow">
                <span class="live-dot"></span>
                SMART PARKING / REDEFINED
            </p>

            <h1>
                YOUR<br>
                SPACE.<br>
                <span class="chrome-text">YOUR</span><br>
                <span class="lime-text">RULES.</span>
            </h1>

            <p class="visual-description">
                Less searching. More moving.
                Your next parking spot is closer than you think.
            </p>
        </div>

        <div class="parking-art">
            <div class="art-orbit orbit-one"></div>
            <div class="art-orbit orbit-two"></div>

            <div class="art-core">
                <span class="parking-symbol">P</span>
                <span class="core-caption">SPACE DETECTED</span>
            </div>

            <div class="art-label label-one">LAT 20.29° N</div>
            <div class="art-label label-two">SLOT AVAILABLE ↗</div>
            <div class="art-cross cross-one">+</div>
            <div class="art-cross cross-two">+</div>
        </div>

        <div class="visual-footer">
            <span>SMART MOBILITY SYSTEM</span>
            <span>EST. 2026 — INDIA</span>
        </div>
    </section>

    <!-- Right login panel -->
    <section class="form-panel">

        <div class="form-top">
            <span class="form-index">ACCESS TERMINAL / 001</span>
            <span class="status">
                <span class="live-dot"></span>
                SYSTEM ONLINE
            </span>
        </div>

        <div class="login-card">
            <p class="eyebrow">WELCOME BACK, DRIVER</p>

            <h2>Sign <span class="chrome-text">in.</span></h2>

            <p class="form-description">
                Your parking journey starts here.
                Enter your credentials to continue.
            </p>

            <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/Login"
                  method="post"
                  class="login-form">

                <div class="input-group">
                    <label for="email">EMAIL ADDRESS</label>
                    <input
                            type="email"
                            id="email"
                            name="email"
                            placeholder="you@example.com"
                            autocomplete="email"
                            required>
                </div>

                <div class="input-group">
                    <div class="label-row">
                        <label for="password">PASSWORD</label>
                        <span class="field-tag">ENCRYPTED</span>
                    </div>

                    <div class="password-wrapper">
                        <input
                                type="password"
                                id="password"
                                name="password"
                                placeholder="Enter your password"
                                autocomplete="current-password"
                                required>

                        <button
                                type="button"
                                class="toggle-password"
                                id="togglePassword"
                                aria-label="Show password">
                            SHOW
                        </button>
                    </div>
                </div>

                <button type="submit" class="login-button">
                    <span>ENTER PARKFLOW</span>
                    <span class="button-arrow">↗</span>
                </button>
            </form>

            <div class="divider">
                <span>NEW TO THE SYSTEM?</span>
            </div>

            <a href="register.jsp" class="register-link">
                CREATE AN ACCOUNT <span>＋</span>
            </a>

            <p class="security-note">
                <span class="security-icon">◇</span>
                YOUR DATA. YOUR JOURNEY. SECURE BY DESIGN.
            </p>
        </div>

        <div class="form-bottom">
            <span>© PARKFLOW 2026</span>
            <span>MOVE SMARTER <span class="lime-text">●</span></span>
        </div>

    </section>
</main>

<!-- Bottom marquee -->
<div class="marquee marquee-bottom">
    <div class="marquee-track">
        FIND IT. BOOK IT. PARK IT. ✳ MOVE SMARTER ✳ FIND IT. BOOK IT. PARK IT. ✳ MOVE SMARTER ✳
    </div>
</div>

<script>
    const togglePassword = document.getElementById('togglePassword');
    const passwordInput = document.getElementById('password');

    togglePassword.addEventListener('click', function () {
        const isPassword = passwordInput.type === 'password';

        passwordInput.type = isPassword ? 'text' : 'password';
        this.textContent = isPassword ? 'HIDE' : 'SHOW';
        this.setAttribute(
            'aria-label',
            isPassword ? 'Hide password' : 'Show password'
        );
    });
</script>

</body>
</html>
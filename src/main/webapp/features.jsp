<%--
  Created by IntelliJ IDEA.
  User: ROHAN XD
  Date: 28-10-2026
  Time: 10:56 pm
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Object loggedInUser = session.getAttribute("user");
    String context = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Features | ParkFlow</title>
    <link rel="stylesheet" href="<%= context %>/css/features.css">
</head>
<body>

<header class="features-navbar">
    <a class="features-brand" href="<%= context %>/index.jsp">
        <span class="brand-icon">P</span>
        PARKFLOW<span class="brand-dot">.</span>
    </a>

    <nav>
        <a href="<%= context %>/index.jsp">Home</a>
        <a href="<%= context %>/features.jsp" class="active">Features</a>

        <% if (loggedInUser != null) { %>
        <a href="<%= context %>/dashboard.jsp" class="nav-button">
            Dashboard ↗
        </a>
        <% } else { %>
        <a href="<%= context %>/index.jsp" class="nav-button">
            Login ↗
        </a>
        <% } %>
    </nav>
</header>

<main>
    <!-- HERO -->
    <section class="features-hero">
        <p class="features-eyebrow">
            <span class="glow-dot"></span>
            THE PARKFLOW EXPERIENCE
        </p>

        <h1>
            EVERY JOURNEY<br>
            <span>STARTS HERE.</span>
        </h1>

        <p class="features-intro">
            Parking should be the easiest part of your journey.
            ParkFlow brings parking discovery, reservations, and
            booking management together in one simple platform.
        </p>

        <a class="features-primary-btn"
           href="<%= context %>/<%= loggedInUser != null ? "dashboard.jsp" : "login.jsp" %>">
            <%= loggedInUser != null ? "Go to Dashboard" : "Get Started" %> ↗
        </a>

        <div class="hero-index">PARKFLOW / FEATURES — 01</div>
    </section>

    <!-- FEATURE CARDS -->
    <section class="features-section">
        <div class="features-section-heading">
            <div>
                <p class="features-eyebrow">DESIGNED FOR CONVENIENCE</p>
                <h2>Everything you need.<br><span>Nothing you don't.</span></h2>
            </div>
            <p class="section-side-text">
                A simpler way to find, reserve, and manage your parking.
            </p>
        </div>

        <div class="features-grid">

            <article class="feature-card feature-card-large">
                <div class="feature-card-top">
                    <span class="feature-number">01 / DISCOVER</span>
                    <span class="feature-symbol">⌕</span>
                </div>
                <div class="feature-illustration parking-illustration">
                    <div class="parking-p-symbol">P</div>
                    <span class="illustration-line line-one"></span>
                    <span class="illustration-line line-two"></span>
                    <span class="illustration-line line-three"></span>
                </div>
                <h3>Parking Slot Discovery</h3>
                <p>
                    View parking spaces organized by zones and identify
                    slots marked available, occupied, or under maintenance.
                </p>
                <span class="feature-tag">VISUAL SLOT LAYOUT</span>
            </article>

            <article class="feature-card">
                <div class="feature-card-top">
                    <span class="feature-number">02 / RESERVE</span>
                    <span class="feature-symbol">↗</span>
                </div>
                <div class="feature-illustration">
                    <div class="booking-visual">
                        <span class="visual-label">YOUR RESERVATION</span>
                        <strong>A-101</strong>
                        <div class="visual-status">
                            <span class="glow-dot"></span>
                            BOOKING DETAILS
                        </div>
                    </div>
                </div>
                <h3>Easy Slot Booking</h3>
                <p>
                    Select a parking slot, choose your date and time,
                    and review your booking details before confirmation.
                </p>
                <span class="feature-tag">SIMPLE RESERVATIONS</span>
            </article>

            <article class="feature-card">
                <div class="feature-card-top">
                    <span class="feature-number">03 / TRANSPARENCY</span>
                    <span class="feature-symbol">₹</span>
                </div>
                <div class="feature-illustration">
                    <div class="rate-visual">
                        <span class="visual-label">HOURLY RATE</span>
                        <strong>₹ <span>20.00</span></strong>
                        <div class="rate-line"></div>
                        <span class="rate-caption">CLEAR PRICING</span>
                    </div>
                </div>
                <h3>Upfront Pricing</h3>
                <p>
                    Check the hourly rate and estimated parking cost
                    before proceeding with your reservation.
                </p>
                <span class="feature-tag">COST VISIBILITY</span>
            </article>

            <article class="feature-card">
                <div class="feature-card-top">
                    <span class="feature-number">04 / CONTROL</span>
                    <span class="feature-symbol">◈</span>
                </div>
                <div class="feature-illustration">
                    <div class="management-visual">
                        <div class="management-row">
                            <span>Slot status</span>
                            <strong>AVAILABLE</strong>
                        </div>
                        <div class="management-row">
                            <span>Zone</span>
                            <strong>A</strong>
                        </div>
                        <div class="management-row">
                            <span>Management</span>
                            <strong>ACTIVE</strong>
                        </div>
                    </div>
                </div>
                <h3>Booking Management</h3>
                <p>
                    Keep track of your reservations and review booking
                    information from your user dashboard.
                </p>
                <span class="feature-tag">BOOKING OVERVIEW</span>
            </article>

            <article class="feature-card feature-card-large">
                <div class="feature-card-top">
                    <span class="feature-number">05 / ADMINISTRATION</span>
                    <span class="feature-symbol">⌘</span>
                </div>
                <div class="feature-illustration admin-illustration">
                    <div class="admin-panel">
                        <div class="admin-panel-heading">
                            <span>ADMIN / SLOT CONTROL</span>
                            <span class="glow-dot"></span>
                        </div>
                        <div class="admin-slots">
                            <span class="slot available">A-101</span>
                            <span class="slot occupied">A-102</span>
                            <span class="slot available">A-103</span>
                            <span class="slot maintenance">A-104</span>
                        </div>
                    </div>
                </div>
                <h3>Parking Administration</h3>
                <p>
                    Administrators can add, edit, view, and safely remove
                    parking slots while managing slot status and hourly rates.
                </p>
                <span class="feature-tag">ADMIN SLOT MANAGEMENT</span>
            </article>

            <article class="feature-card">
                <div class="feature-card-top">
                    <span class="feature-number">06 / ACCOUNT</span>
                    <span class="feature-symbol">◎</span>
                </div>
                <div class="feature-illustration">
                    <div class="account-visual">
                        <div class="account-avatar">P</div>
                        <div>
                            <strong>YOUR ACCOUNT</strong>
                            <span>Personal dashboard</span>
                        </div>
                    </div>
                </div>
                <h3>Account Access</h3>
                <p>
                    Register and log in to access the features available
                    to your account and its assigned role.
                </p>
                <span class="feature-tag">PERSONAL ACCESS</span>
            </article>

        </div>
    </section>

    <!-- CALL TO ACTION -->
    <section class="features-cta">
        <p class="features-eyebrow">YOUR NEXT STOP IS CLOSER</p>
        <h2>Ready to find<br><span>your space?</span></h2>
        <p>
            Get started with ParkFlow and make parking a smoother
            part of your journey.
        </p>

        <a class="features-primary-btn"
           href="<%= context %>/<%= loggedInUser != null ? "dashboard.jsp" : "index.jsp" %>">
            <%= loggedInUser != null ? "Open Dashboard" : "Get Started Now" %> ↗
        </a>
    </section>
</main>

<footer class="features-footer">
    <a class="features-brand" href="<%= context %>/index.jsp">
        PARKFLOW<span class="brand-dot">.</span>
    </a>
    <span>SMART PARKING MANAGEMENT SYSTEM</span>
    <a href="<%= context %>/welcome.jsp">BACK TO HOME ↑</a>
</footer>

</body>
</html>

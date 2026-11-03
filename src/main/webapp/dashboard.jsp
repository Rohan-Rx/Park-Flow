
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="in.parkflow.model.User" %>
<%@ page import="in.parkflow.model.Booking" %>
<%@ page import="in.parkflow.model.ParkingSlot" %>
<%@ page import="in.parkflow.service.BookingService" %>
<%@ page import="in.parkflow.service.ParkingSlotService" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    ParkingSlotService parkingService = new ParkingSlotService();
    BookingService bookingService = new BookingService();

    List<ParkingSlot> slots = parkingService.getAllSlots();
    List<Booking> bookings = bookingService.getBookingHistory(user.getId());

    int availableSlots = 0;
    Map<String, Integer> availableByZone = new HashMap<>();

    for (ParkingSlot slot : slots) {
        if ("AVAILABLE".equalsIgnoreCase(slot.getStatus())) {
            availableSlots++;
            String zone = slot.getZoneName();
            availableByZone.put(
                    zone, availableByZone.getOrDefault(zone, 0) + 1
            );
        }
    }

    int myBookings = 0;
    int activeBookings = 0;

    LocalDate today = LocalDate.now();
    LocalTime now = LocalTime.now();

    for (Booking booking : bookings) {
        if ("CONFIRMED".equalsIgnoreCase(booking.getStatus())) {
            if (!booking.getBookingDate().isBefore(today)) {
                myBookings++;
            }

            if (booking.getBookingDate().equals(today)
                    && !now.isBefore(booking.getStartTime())
                    && now.isBefore(booking.getEndTime())) {
                activeBookings++;
            }
        }
    }

    int totalBookings = bookings.size();
    DateTimeFormatter dateFormat =
            DateTimeFormatter.ofPattern("dd MMM yyyy");
    DateTimeFormatter timeFormat =
            DateTimeFormatter.ofPattern("hh:mm a");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ParkFlow | Dashboard</title>
    <link rel="stylesheet" href="css/dashboard.css">
</head>

<body>

<!-- TOP KINETIC MARQUEE -->
<div class="marquee marquee-top" aria-hidden="true">
    <div class="marquee-track">
        <% for (int i = 0; i < 4; i++) { %>
        <span>✳ PARKFLOW</span><span>//</span>
        <span>SMART PARKING</span><span>//</span>
        <span>PARK SMARTER</span><span>//</span>
        <span>TRAVEL BETTER</span><span>✳</span>
        <% } %>
    </div>
</div>

<div class="app-shell">

    <!-- SIDEBAR -->
    <aside class="sidebar">

        <a href="dashboard.jsp" class="brand">
            <span class="brand-mark">P</span>
            <span class="brand-copy">
                <strong>Park<span>Flow</span></strong>
                <small>SMART PARKING</small>
            </span>
        </a>

        <div class="side-label">NAVIGATION //</div>

        <nav class="side-nav">
            <a href="dashboard.jsp" class="nav-link active">
                <span class="nav-icon">▦</span>
                <span>Dashboard</span>
            </a>

            <a href="my-bookings.jsp" class="nav-link">
                <span class="nav-icon">▣</span>
                <span>My Bookings</span>
            </a>

            <a href="#" class="nav-link">
                <span class="nav-icon">♙</span>
                <span>Profile</span>
            </a>

            <a href="<%= request.getContextPath() %>/logout"
               class="nav-link logout-link">
                <span class="nav-icon">⇥</span>
                <span>Logout</span>
            </a>
        </nav>

        <div class="sidebar-poster">
            <span class="poster-kicker">THE FUTURE IS</span>
            <span class="poster-heading">PARK<br>SMARTER.</span>
            <span class="poster-outline">DRIVE / ARRIVE / REPEAT</span>
        </div>

        <div class="sidebar-footer">
            <span class="status-dot"></span>
            SYSTEM ONLINE
            <span class="version">V.2099</span>
        </div>

    </aside>

    <!-- MAIN CONTENT -->
    <main class="main-content">

        <!-- WELCOME HERO -->
        <section class="hero">

            <div class="hero-copy">
                <span class="eyebrow">
                    <span class="status-dot"></span>
                    WELCOME BACK,
                </span>

                <h1 class="hero-name">
                    <%= user.getName() %><span class="hero-star">✳</span>
                </h1>

                <p class="user-email">
                    <span>✉</span>
                    <%= user.getEmail() %>
                </p>

                <p class="hero-description">
                    Find and manage your parking spaces easily.
                </p>
            </div>

            <div class="hero-art" aria-hidden="true">
                <div class="hero-orbit orbit-one"></div>
                <div class="hero-orbit orbit-two"></div>
                <div class="hero-parking-sign">P</div>
                <span class="hero-art-label">FUTURE MOBILITY / 001</span>
            </div>

            <a href="#parking" class="chrome-button">
                <span>＋</span> BOOK PARKING <span>↗</span>
            </a>

            <span class="hero-index">PF / 001</span>

        </section>

        <!-- STATISTICS -->
        <section class="stats-grid" aria-label="Parking statistics">

            <article class="stat-card lime-card">
                <div class="stat-top">
                    <span class="stat-icon">P</span>
                    <span class="stat-arrow">↗</span>
                </div>
                <p>AVAILABLE SLOTS</p>

                <strong class="stat-number"><%= availableSlots %></strong>

                <span class="stat-note">OPEN SPACES //</span>
            </article>

            <article class="stat-card pink-card">
                <div class="stat-top">
                    <span class="stat-icon">▣</span>
                    <span class="stat-arrow">↗</span>
                </div>
                <p>MY BOOKINGS</p>

                <strong class="stat-number"><%= myBookings %></strong>

                <span class="stat-note">RESERVATIONS //</span>
            </article>

            <article class="stat-card cyan-card">
                <div class="stat-top">
                    <span class="stat-icon">♧</span>
                    <span class="stat-arrow">↗</span>
                </div>
                <p>ACTIVE BOOKING</p>


                <strong class="stat-number"><%= activeBookings %></strong>


                <span class="stat-note">CURRENT SESSION //</span>
            </article>

            <article class="stat-card chrome-card">
                <div class="stat-top">
                    <span class="stat-icon">▥</span>
                    <span class="stat-arrow">↗</span>
                </div>
                <p>TOTAL BOOKINGS</p>


                <strong class="stat-number"><%= totalBookings %></strong>


                <span class="stat-note">ALL-TIME ACTIVITY //</span>
            </article>

        </section>

        <!-- PARKING ZONES -->
        <section class="content-section" id="parking">

            <div class="section-heading">
                <div>
                    <span class="section-kicker">01 / FIND YOUR SPACE</span>
                    <h2>AVAILABLE <span>PARKING</span><b>✳</b></h2>
                    <p>Choose a parking zone near you.</p>
                </div>

                <a href="#parking" class="view-all">VIEW ALL ↗</a>
            </div>

            <div class="parking-grid">

                <article class="parking-card zone-lime">
                    <div class="zone-photo photo-a">
                        <span class="photo-tag">ZONE / 001</span>
                        <span class="zone-letter">A</span>
                    </div>

                    <div class="zone-details">
                        <div>
                            <h3>ZONE A</h3>
                            <p>Main Parking Area</p>
                        </div>
                        <span class="zone-indicator">● LIVE</span>
                    </div>

                    <div class="zone-bottom">
                        <div class="slot-count">
                            <%= availableByZone.getOrDefault("A", 0) %>
                            <span>SLOTS AVAILABLE</span>
                        </div>
                        <a href="<%= request.getContextPath() %>/Bookings.jsp?zone_name=Zone%20A", class="zone-button">
                            VIEW SLOTS ↗
                        </a>
                    </div>
                </article>

                <article class="parking-card zone-pink">
                    <div class="zone-photo photo-b">
                        <span class="photo-tag">ZONE / 002</span>
                        <span class="zone-letter">B</span>
                    </div>

                    <div class="zone-details">
                        <div>
                            <h3>ZONE B</h3>
                            <p>Business District</p>
                        </div>
                        <span class="zone-indicator">● LIVE</span>
                    </div>

                    <div class="zone-bottom">
                        <div class="slot-count">
                            <%= availableByZone.getOrDefault("B", 0) %>
                            <span>SLOTS AVAILABLE</span>
                        </div>
                        <a href="<%= request.getContextPath() %>/Bookings.jsp?zone_name=Zone B" class="zone-button">
                            VIEW SLOTS ↗
                        </a>
                    </div>
                </article>

                <article class="parking-card zone-cyan">
                    <div class="zone-photo photo-c">
                        <span class="photo-tag">ZONE / 003</span>
                        <span class="zone-letter">C</span>
                    </div>

                    <div class="zone-details">
                        <div>
                            <h3>ZONE C</h3>
                            <p>Shopping Complex</p>
                        </div>
                        <span class="zone-indicator">● LIVE</span>
                    </div>

                    <div class="zone-bottom">
                        <div class="slot-count">
                            <%= availableByZone.getOrDefault("C", 0) %>
                            <span>SLOTS AVAILABLE</span>
                        </div>
                        <a href="<%= request.getContextPath() %>/Bookings.jsp?Zone_name=Zone C"
                           class="zone-button">
                            VIEW SLOTS ↗
                        </a>
                    </div>
                </article>

            </div>
        </section>

        <!-- RECENT BOOKINGS -->
        <section class="content-section bookings-section" id="bookings">

            <div class="section-heading">
                <div>
                    <span class="section-kicker">02 / YOUR ACTIVITY</span>
                    <h2>RECENT <span>BOOKINGS</span><b>✳</b></h2>
                    <p>Your latest parking activity.</p>
                </div>

                <a href="my-bookings.jsp" class="view-all">VIEW ALL ↗</a>
            </div>

            <div class="booking-table-wrap">
                <table class="booking-table">
                    <thead>
                    <tr>
                        <th>SLOT</th>
                        <th>LOCATION</th>
                        <th>DATE</th>
                        <th>TIME</th>
                        <th>STATUS</th>
                    </tr>
                    </thead>

                    <tbody>
                    <% if (bookings.isEmpty()) { %>
                    <tr>
                        <td colspan="5">No bookings yet. Book your first parking slot!</td>
                    </tr>
                    <% } else {
                        int displayed = 0;

                        for (Booking booking : bookings) {
                            if (displayed >= 3) {
                                break;
                            }

                            String statusClass =
                                    "CONFIRMED".equalsIgnoreCase(booking.getStatus())
                                            ? "active" : "completed";
                    %>
                    <tr>
                        <td>
                            <strong><%= booking.getParkingSlot().getSlotNumber() %></strong>
                        </td>
                        <td>
                            Zone <%= booking.getParkingSlot().getZoneName() %>
                        </td>
                        <td><%= booking.getBookingDate().format(dateFormat) %></td>
                        <td><%= booking.getStartTime().format(timeFormat) %></td>
                        <td>
                <span class="booking-status <%= statusClass %>">
                    <%= booking.getStatus() %>
                </span>
                        </td>
                    </tr>
                    <%
                                displayed++;
                            }
                        } %>
                    </tbody>
                </table>
            </div>

            <div class="table-footer">
                <span>END OF DISPLAYED RECORDS //</span>
                <span>SECURE PARKING / PARKFLOW</span>
            </div>

        </section>

    </main>
</div>

<!-- BOTTOM KINETIC MARQUEE -->
<div class="marquee marquee-bottom" aria-hidden="true">
    <div class="marquee-track reverse">
        <% for (int i = 0; i < 4; i++) { %>
        <span>✳ PARKFLOW</span><span>//</span>
        <span>SMART PARKING</span><span>//</span>
        <span>PARK SMARTER</span><span>//</span>
        <span>TRAVEL BETTER</span><span>✳</span>
        <% } %>
    </div>
</div>

<script>
    function showZone(zone) {
        alert("You selected Zone " + zone +
            ". Slot selection will be available when the booking feature is connected.");
    }
</script>

</body>
</html>
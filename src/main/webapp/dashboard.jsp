<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="in.parkflow.model.User" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect("index.html");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>ParkFlow | Dashboard</title>

    <link rel="stylesheet"
          href="css/dashboard.css">

</head>

<body>

<!-- ================= NAVBAR ================= -->

<header class="navbar">

    <div class="logo">

        <div class="logo-icon">
            P
        </div>

        <div>
            <h2>Park<span>Flow</span></h2>
            <small>Smart Parking</small>
        </div>

    </div>


    <nav>

        <a href="dashboard.jsp"
           class="active">
            Dashboard
        </a>

        <a href="#">
            My Bookings
        </a>

        <a href="#">
            Profile
        </a>

        <a href="logout"
           class="logout">
            Logout
        </a>

    </nav>

</header>


<!-- ================= MAIN ================= -->

<main class="dashboard-container">


    <!-- Welcome -->

    <section class="welcome">

        <div>

           <h1>
               Welcome back, <%= user.getName() %> 👋
           </h1>

           <p>
               <%= user.getEmail() %>
           </p>

            <p>
                Find and manage your parking spaces easily.
            </p>

        </div>

        <button class="primary-btn">
            + Book Parking
        </button>

    </section>



    <!-- ================= STAT CARDS ================= -->

    <section class="stats">


        <div class="stat-card">

            <div class="stat-icon">
                🅿
            </div>

            <div>

                <p>Available Slots</p>

                <h2>24</h2>

            </div>

        </div>


        <div class="stat-card">

            <div class="stat-icon">
                📅
            </div>

            <div>

                <p>My Bookings</p>

                <h2>4</h2>

            </div>

        </div>


        <div class="stat-card">

            <div class="stat-icon">
                🚗
            </div>

            <div>

                <p>Active Booking</p>

                <h2>1</h2>

            </div>

        </div>


        <div class="stat-card">

            <div class="stat-icon">
                📊
            </div>

            <div>

                <p>Total Bookings</p>

                <h2>8</h2>

            </div>

        </div>


    </section>



    <!-- ================= PARKING AREAS ================= -->

    <section class="section">

        <div class="section-header">

            <div>

                <h2>
                    Available Parking
                </h2>

                <p>
                    Choose a parking zone near you
                </p>

            </div>

            <a href="#">
                View All
            </a>

        </div>


        <div class="parking-grid">


            <div class="parking-card">

                <div class="parking-info">

                    <div class="zone-icon">
                        A
                    </div>

                    <div>

                        <h3>Zone A</h3>

                        <p>
                            Main Parking Area
                        </p>

                    </div>

                </div>

                <div class="availability">

                    <strong>12</strong>

                    <span>
                        Slots Available
                    </span>

                </div>

                <button>
                    View Slots
                </button>

            </div>



            <div class="parking-card">

                <div class="parking-info">

                    <div class="zone-icon">
                        B
                    </div>

                    <div>

                        <h3>Zone B</h3>

                        <p>
                            Business District
                        </p>

                    </div>

                </div>

                <div class="availability">

                    <strong>7</strong>

                    <span>
                        Slots Available
                    </span>

                </div>

                <button>
                    View Slots
                </button>

            </div>



            <div class="parking-card">

                <div class="parking-info">

                    <div class="zone-icon">
                        C
                    </div>

                    <div>

                        <h3>Zone C</h3>

                        <p>
                            Shopping Complex
                        </p>

                    </div>

                </div>

                <div class="availability">

                    <strong>5</strong>

                    <span>
                        Slots Available
                    </span>

                </div>

                <button>
                    View Slots
                </button>

            </div>


        </div>

    </section>



    <!-- ================= RECENT BOOKINGS ================= -->

    <section class="section">

        <div class="section-header">

            <div>

                <h2>
                    Recent Bookings
                </h2>

                <p>
                    Your latest parking activity
                </p>

            </div>

            <a href="#">
                View All
            </a>

        </div>


        <div class="table-container">

            <table>

                <thead>

                <tr>

                    <th>Slot</th>

                    <th>Location</th>

                    <th>Date</th>

                    <th>Time</th>

                    <th>Status</th>

                </tr>

                </thead>


                <tbody>

                <tr>

                    <td>
                        <strong>A-102</strong>
                    </td>

                    <td>
                        Zone A
                    </td>

                    <td>
                        01 Sep 2026
                    </td>

                    <td>
                        10:00 AM
                    </td>

                    <td>
                        <span class="status active">
                            Active
                        </span>
                    </td>

                </tr>


                <tr>

                    <td>
                        <strong>B-205</strong>
                    </td>

                    <td>
                        Zone B
                    </td>

                    <td>
                        29 Aug 2026
                    </td>

                    <td>
                        02:30 PM
                    </td>

                    <td>
                        <span class="status completed">
                            Completed
                        </span>
                    </td>

                </tr>


                <tr>

                    <td>
                        <strong>C-108</strong>
                    </td>

                    <td>
                        Zone C
                    </td>

                    <td>
                        25 Aug 2026
                    </td>

                    <td>
                        11:00 AM
                    </td>

                    <td>
                        <span class="status completed">
                            Completed
                        </span>
                    </td>

                </tr>

                </tbody>

            </table>

        </div>

    </section>


</main>


</body>

</html>
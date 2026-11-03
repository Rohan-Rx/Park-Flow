<%--
  Created by IntelliJ IDEA.
  User: ROHAN XD
  Date: 15-10-2026
  Time: 03:01 pm
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="in.parkflow.model.ParkingSlot" %>

<%
    List<ParkingSlot> slots =
            (List<ParkingSlot>) request.getAttribute("slots");

    if (slots == null) {
        slots = new java.util.ArrayList<>();
    }

    Map<String, List<ParkingSlot>> zones = new LinkedHashMap<>();

    int availableCount = 0;
    int occupiedCount = 0;
    int maintenanceCount = 0;

    for (ParkingSlot slot : slots) {
        String zone = slot.getZoneName();

        zones.computeIfAbsent(
                zone == null ? "Other" : zone,
                key -> new java.util.ArrayList<>()
        ).add(slot);

        String status = slot.getStatus();

        if ("AVAILABLE".equalsIgnoreCase(status)) {
            availableCount++;
        } else if ("OCCUPIED".equalsIgnoreCase(status)) {
            occupiedCount++;
        } else if ("MAINTENANCE".equalsIgnoreCase(status)) {
            maintenanceCount++;
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>ParkFlow | Visual Parking Management</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/admin.css">
</head>

<body>

<div class="admin-layout">

    <!-- SIDEBAR -->
    <aside class="sidebar">

        <a href="<%= request.getContextPath() %>/Admin/dashboard.jsp"
           class="brand">
            Park<span>Flow</span>
        </a>

        <p class="sidebar-label">ADMIN PANEL</p>

        <a class="nav-item"
           href="<%= request.getContextPath() %>/Admin/dashboard.jsp">
            Dashboard
        </a>

        <a class="nav-item active"
           href="<%= request.getContextPath() %>/Admin/add-slots">
            Manage Parking Slots
        </a>

        <a class="nav-item"
           href="<%= request.getContextPath() %>/Admin/bookings">
            All Bookings
        </a>

        <a class="nav-item"
           href="<%= request.getContextPath() %>/dashboard.jsp">
            User Dashboard
        </a>

        <form action="<%= request.getContextPath() %>/LogoutServlet"
              method="post">
            <button class="logout-btn" type="submit">Logout</button>
        </form>

    </aside>


    <!-- MAIN CONTENT -->
    <main class="main-content">

        <header class="topbar">

            <div>
                <p class="eyebrow">ADMIN PANEL</p>
                <h1>Manage Parking Slots</h1>

                <p class="page-description">
                    Visualize parking spaces and manage their availability.
                </p>
            </div>

            <a href="#addSlotPanel" class="add-slot-btn top-add-btn">
                + Add New Slot
            </a>

        </header>


        <!-- STATUS LEGEND AND COUNTS -->
        <section class="parking-overview">

            <div class="status-legend">

                <span class="legend-item">
                    <span class="legend-dot available-dot"></span>
                    Available
                </span>

                <span class="legend-item">
                    <span class="legend-dot occupied-dot"></span>
                    Occupied
                </span>

                <span class="legend-item">
                    <span class="legend-dot maintenance-dot"></span>
                    Maintenance
                </span>

            </div>

            <div class="overview-counts">

                <div class="overview-stat">
                    <span class="stat-label">Total Slots</span>
                    <strong><%= slots.size() %></strong>
                </div>

                <div class="overview-stat">
                    <span class="stat-label">Available</span>
                    <strong class="available-text">
                        <%= availableCount %>
                    </strong>
                </div>

                <div class="overview-stat">
                    <span class="stat-label">Occupied</span>
                    <strong class="occupied-text">
                        <%= occupiedCount %>
                    </strong>
                </div>

                <div class="overview-stat">
                    <span class="stat-label">Maintenance</span>
                    <strong class="maintenance-text">
                        <%= maintenanceCount %>
                    </strong>
                </div>

            </div>

        </section>



        <!-- SUCCESS AND ERROR MESSAGES -->

        <% if ("added".equals(request.getParameter("success"))) { %>

        <p class="form-message success-message">
            Parking slot added successfully.
        </p>

        <% } else if ("updated".equals(request.getParameter("success"))) { %>

        <p class="form-message success-message">
            Parking slot updated successfully.
        </p>

        <% } else if ("deleted".equals(request.getParameter("success"))) { %>

        <p class="form-message success-message">
            Parking slot deleted successfully.
        </p>

        <% } else if ("duplicate".equals(request.getParameter("error"))) { %>

        <p class="form-message error-message">
            This slot number already exists.
        </p>

        <% } else if ("rate".equals(request.getParameter("error"))) { %>

        <p class="form-message error-message">
            Enter a valid positive hourly rate with up to two decimal places.
        </p>

        <% } else if ("missing".equals(request.getParameter("error"))) { %>

        <p class="form-message error-message">
            Please fill in all fields.
        </p>

        <% } else if ("hasbookings".equals(request.getParameter("error"))) { %>

        <p class="form-message error-message">
            This slot cannot be deleted because booking records exist.
        </p>

        <% } else if ("notfound".equals(request.getParameter("error"))) { %>

        <p class="form-message error-message">
            Parking slot not found.
        </p>

        <% } %>



        <!-- VISUAL PARKING ZONES -->
        <section class="parking-zones">

            <% if (zones.isEmpty()) { %>

            <div class="empty-parking">
                <h2>No Parking Slots Yet</h2>
                <p>Add your first parking slot to see it here.</p>
            </div>

            <% } else {
                for (Map.Entry<String, List<ParkingSlot>> zoneEntry
                        : zones.entrySet()) {

                    List<ParkingSlot> zoneSlots = zoneEntry.getValue();
            %>

            <section class="zone-panel">

                <header class="zone-header">

                    <div class="zone-heading">
                        <span class="zone-accent"></span>

                        <div>
                            <h2><%= zoneEntry.getKey() %></h2>

                            <p>
                                <%= zoneSlots.size() %> parking spaces
                            </p>
                        </div>
                    </div>

                    <span class="zone-location">
                            PARKING AREA
                        </span>

                </header>


                <div class="parking-grid">

                    <% for (ParkingSlot slot : zoneSlots) {

                        String status = slot.getStatus() == null
                                ? "UNKNOWN"
                                : slot.getStatus().toUpperCase();

                        String statusClass;

                        if ("AVAILABLE".equals(status)) {
                            statusClass = "available";
                        } else if ("OCCUPIED".equals(status)) {
                            statusClass = "occupied";
                        } else if ("MAINTENANCE".equals(status)) {
                            statusClass = "maintenance";
                        } else {
                            statusClass = "unknown";
                        }
                    %>

                    <button type="button"
                            class="parking-tile <%= statusClass %>"
                            data-id="<%= slot.getId() %>"
                            data-slot="<%= slot.getSlotNumber() %>"
                            data-zone="<%= slot.getZoneName() %>"
                            data-location="<%= slot.getLocation() %>"
                            data-rate="<%= slot.getHourlyRate() %>"
                            data-status="<%= status %>"
                            aria-label="Parking slot <%= slot.getSlotNumber() %>, <%= status %>"
                            title="Click to view slot details">

                        <svg class="car-icon"
                             viewBox="0 0 24 24"
                             fill="none"
                             stroke="currentColor"
                             stroke-width="1.8"
                             stroke-linecap="round"
                             stroke-linejoin="round"
                             aria-hidden="true">

                            <path d="M5 11l1.5-5h11L19 11"/>
                            <path d="M3 11h18v7H3z"/>
                            <path d="M5 18v2M19 18v2"/>
                            <circle cx="7" cy="15" r="1"/>
                            <circle cx="17" cy="15" r="1"/>

                        </svg>

                        <span class="tile-number">
                                    <%= slot.getSlotNumber() %>
                                </span>

                        <span class="tile-status">
                                    <%= status %>
                                </span>


                    </button>

                    <% } %>

                </div>

            </section>

            <%     }
            }
            %>

        </section>


        <!-- ADD PARKING SLOT FORM -->
        <section class="add-slot-panel" id="addSlotPanel">

            <div class="section-heading">
                <div>
                    <p class="eyebrow">NEW PARKING SPACE</p>
                    <h2>Add Parking Slot</h2>
                </div>
            </div>

            <form action="<%= request.getContextPath() %>/Admin/add-slot"
                  method="post"
                  class="add-slot-form">

                <div class="form-field">
                    <label for="slotNumber">Slot Number</label>

                    <input type="text"
                           id="slotNumber"
                           name="slotNumber"
                           maxlength="20"
                           placeholder="e.g. A-105"
                           required>
                </div>

                <div class="form-field">
                    <label for="zoneName">Zone Name</label>

                    <input type="text"
                           id="zoneName"
                           name="zoneName"
                           maxlength="50"
                           placeholder="e.g. Zone A"
                           required>
                </div>

                <div class="form-field">
                    <label for="location">Location</label>

                    <input type="text"
                           id="location"
                           name="location"
                           maxlength="150"
                           placeholder="e.g. Main Parking Area"
                           required>
                </div>

                <div class="form-field">
                    <label for="hourlyRate">Hourly Rate (₹)</label>

                    <input type="number"
                           id="hourlyRate"
                           name="hourlyRate"
                           min="0.01"
                           max="999999.99"
                           step="0.01"
                           value="20.00"
                           required>
                </div>

                <button type="submit" class="add-slot-btn">
                    + Add Parking Slot
                </button>

            </form>

        </section>


        <footer class="footer">
            ParkFlow · Smart Parking Management System
        </footer>

    </main>

</div>


<!-- SLOT DETAILS POPUP -->
<div class="slot-modal" id="slotModal" aria-hidden="true">

    <div class="slot-modal-backdrop" id="modalBackdrop"></div>

    <section class="slot-modal-card"
             role="dialog"
             aria-modal="true"
             aria-labelledby="modalSlotNumber">

        <button type="button"
                class="modal-close"
                id="closeModal"
                aria-label="Close dialog">
            &times;
        </button>

        <p class="eyebrow">PARKING SPACE DETAILS</p>

        <h2 id="modalSlotNumber">Slot Details</h2>

        <div class="modal-status" id="modalStatus"></div>

        <div class="modal-details">

            <div class="modal-detail-row">
                <span>Slot ID</span>
                <strong id="modalId"></strong>
            </div>

            <div class="modal-detail-row">
                <span>Zone</span>
                <strong id="modalZone"></strong>
            </div>

            <div class="modal-detail-row">
                <span>Location</span>
                <strong id="modalLocation"></strong>
            </div>

            <div class="modal-detail-row">
                <span>Hourly Rate</span>
                <strong id="modalRate"></strong>
            </div>

        </div>

        <form action="<%= request.getContextPath() %>/Admin/edit-slot"
              method="post"
              id="editSlotForm">

            <input type="hidden" name="id" id="editSlotId">

            <label for="editSlotNumber">Slot Number</label>
            <input type="text" name="slotNumber" id="editSlotNumber"
                   maxlength="20" required>

            <label for="editZoneName">Zone</label>
            <input type="text" name="zoneName" id="editZoneName"
                   maxlength="50" required>

            <label for="editLocation">Location</label>
            <input type="text" name="location" id="editLocation"
                   maxlength="150" required>

            <label for="editHourlyRate">Hourly Rate (₹)</label>
            <input type="number" name="hourlyRate" id="editHourlyRate"
                   min="0.01" step="0.01" required>

            <label for="editSlotStatus">Status</label>
            <select name="status" id="editSlotStatus" required>
                <option value="AVAILABLE">Available</option>
                <option value="OCCUPIED">Occupied</option>
                <option value="MAINTENANCE">Maintenance</option>
            </select>

            <button type="submit">Save Changes</button>
        </form>

        <form action="<%= request.getContextPath() %>/Admin/delete-slot"
              method="post"
              id="deleteSlotForm"
              onsubmit="return confirm('Are you sure you want to delete this parking slot? This action cannot be undone.');">

            <input type="hidden" name="id" id="deleteSlotId">

            <button type="submit" id="deleteSlotButton">
                Delete Slot
            </button>
        </form>



        <button type="button"
                class="add-slot-btn modal-done"
                id="modalDone">
            Close
        </button>

    </section>

</div>


<script>
    const slotModal = document.getElementById("slotModal");

    function openSlotModal(tile) {
        document.getElementById("modalSlotNumber").textContent =
            tile.dataset.slot;

        document.getElementById("modalId").textContent =
            tile.dataset.id;

        document.getElementById("modalZone").textContent =
            tile.dataset.zone;

        document.getElementById("modalLocation").textContent =
            tile.dataset.location;

        document.getElementById("modalRate").textContent =
            "₹" + tile.dataset.rate;

        document.getElementById("editSlotId").value = tile.dataset.id;
        document.getElementById("editSlotNumber").value = tile.dataset.slot;
        document.getElementById("editZoneName").value = tile.dataset.zone;
        document.getElementById("editLocation").value = tile.dataset.location;
        document.getElementById("editHourlyRate").value = tile.dataset.rate;
        document.getElementById("editSlotStatus").value =
            tile.dataset.status.toUpperCase();
        document.getElementById("deleteSlotId").value = tile.dataset.id;


        const statusElement = document.getElementById("modalStatus");
        const status = tile.dataset.status;

        statusElement.textContent = status;
        statusElement.className =
            "modal-status " + status.toLowerCase();

        slotModal.classList.add("open");
        slotModal.setAttribute("aria-hidden", "false");
    }

    function closeSlotModal() {
        slotModal.classList.remove("open");
        slotModal.setAttribute("aria-hidden", "true");
    }

    document.querySelectorAll(".parking-tile").forEach(function (tile) {
        tile.addEventListener("click", function () {
            openSlotModal(tile);
        });
    });

    document.getElementById("closeModal")
        .addEventListener("click", closeSlotModal);

    document.getElementById("modalDone")
        .addEventListener("click", closeSlotModal);

    document.getElementById("modalBackdrop")
        .addEventListener("click", closeSlotModal);

    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape") {
            closeSlotModal();
        }
    });
</script>

</body>
</html>


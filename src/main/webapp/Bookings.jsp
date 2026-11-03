<%--
  Created by IntelliJ IDEA.
  User: ROHAN XD
  Date: 12-10-2026
  Time: 10:46 am
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="in.parkflow.model.ParkingSlot" %>
<%@ page import="in.parkflow.service.ParkingSlotService" %>
<%@ page import="in.parkflow.model.User" %>
<%
  String success = request.getParameter("success");
  String bookingId = request.getParameter("id");
%>

<% if ("1".equals(success) && bookingId != null) { %>
<div class="booking-success">
  <div class="success-icon">&#10003;</div>
  <h2>Booking Confirmed!</h2>
  <p>Your parking reservation has been created successfully.</p>
  <div class="success-booking-id">
    Booking ID: <strong><%= bookingId %></strong>
  </div>
</div>
<% } %>

<%
  User loggedInUser = (User) session.getAttribute("user");

  if (loggedInUser == null) {
    response.sendRedirect(request.getContextPath() + "/index.jsp");
    return;
  }

  ParkingSlotService parkingService = new ParkingSlotService();

  // Get the selected zone from the URL
  String selectedZone = request.getParameter("zone");

  // Load all parking slots
  List<ParkingSlot> allSlots = parkingService.getAllSlots();
  List<ParkingSlot> slots = new java.util.ArrayList<>();

  // Filter slots according to the selected zone
  if (selectedZone == null || selectedZone.trim().isEmpty()) {
    slots.addAll(allSlots);
  } else {
    selectedZone = selectedZone.trim().toUpperCase();

    String expectedZone = selectedZone.startsWith("ZONE ")
            ? selectedZone
            : "ZONE " + selectedZone;

    for (ParkingSlot slot : allSlots) {
      if (slot.getZoneName() != null
              && slot.getZoneName().trim()
              .equalsIgnoreCase(expectedZone)) {
        slots.add(slot);
      }
    }
  }

  success = request.getParameter("success");
  String error = request.getParameter("error");
  String today = LocalDate.now().toString();
  selectedZone = request.getParameter("zone_name");

  Map<String, List<ParkingSlot>> parkingZones = new LinkedHashMap<>();

  for (ParkingSlot slot : slots) {

    String zone = slot.getZoneName() == null
            ? "Other"
            : slot.getZoneName().trim();

    // Normalize zone names: "A" and "Zone A" both become "A"
    String normalizedZone = zone.toUpperCase();
    if (normalizedZone.startsWith("ZONE ")) {
      normalizedZone = normalizedZone.substring(5).trim();
    }

    // If a zone was selected, skip every other zone
    if (selectedZone != null && !selectedZone.trim().isEmpty()) {

      String requestedZone = selectedZone.trim().toUpperCase();

      if (requestedZone.startsWith("ZONE ")) {
        requestedZone = requestedZone.substring(5).trim();
      }

      if (!normalizedZone.equals(requestedZone)) {
        continue;
      }
    }

    parkingZones.computeIfAbsent(
            zone,
            key -> new java.util.ArrayList<>()
    ).add(slot);
  }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ParkFlow | Book Parking</title>

  <style>
    * {
      box-sizing: border-box;
    }

    body {
      margin: 0;
      padding: 30px 16px;
      background: #101114;
      color: #f5f5f5;
      font-family: Arial, sans-serif;
    }

    .container {
      max-width: 650px;
      margin: 20px auto;
      padding: 30px;
      background: #1b1c21;
      border: 1px solid #303137;
      border-radius: 16px;
    }

    h1 {
      margin-top: 0;
      font-size: 28px;
    }

    .subtitle {
      color: #a4a5ae;
      margin-bottom: 28px;
    }

    label {
      display: block;
      margin: 18px 0 8px;
      font-size: 14px;
      color: #d7d7dd;
    }

    input, select {
      width: 100%;
      padding: 13px;
      border: 1px solid #3a3b43;
      border-radius: 8px;
      background: #121318;
      color: white;
      font-size: 15px;
    }

    input:focus, select:focus {
      outline: 1px solid #a3ff12;
      border-color: #a3ff12;
    }

    button {
      width: 100%;
      margin-top: 26px;
      padding: 14px;
      border: none;
      border-radius: 8px;
      background: #a3ff12;
      color: #111;
      font-size: 16px;
      font-weight: bold;
      cursor: pointer;
    }

    button:hover {
      background: #8ee000;
    }

    .message {
      padding: 12px;
      margin: 15px 0;
      border-radius: 8px;
      font-size: 14px;
    }

    .success {
      background: #173b25;
      color: #8ef0a9;
    }

    .error {
      background: #431f22;
      color: #ffb2b2;
    }

    .back {
      display: inline-block;
      margin-top: 22px;
      color: #a3ff12;
      text-decoration: none;
    }

    .price-estimate {
      margin: 20px 0;
      padding: 18px 20px;
      border: 1px solid #b7ff5a;
      border-radius: 10px;
      background: rgba(183, 255, 90, 0.06);
    }

    .price-estimate span {
      display: block;
      color: #b7ff5a;
      font-size: 14px;
      margin-bottom: 8px;
    }

    .price-estimate strong {
      display: block;
      color: #ffffff;
      font-size: 30px;
      font-weight: 700;
    }

    .price-estimate p {
      margin: 8px 0 0;
      color: #a4ada4;
      font-size: 13px;
    }
       .booking-success {
         margin-bottom: 24px;
         padding: 24px;
         text-align: center;
         background: rgba(183, 255, 90, 0.07);
         border: 1px solid rgba(183, 255, 90, 0.4);
         border-radius: 16px;
       }

    .success-icon {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 46px;
      height: 46px;
      border-radius: 50%;
      background: #b7ff5a;
      color: #111;
      font-size: 25px;
      font-weight: 700;
    }

    .booking-success h2 {
      margin: 14px 0 8px;
      color: #b7ff5a;
    }

    .booking-success p {
      color: #c4c8c5;
    }

    .success-booking-id {
      display: inline-block;
      margin-top: 12px;
      padding: 10px 16px;
      color: #eee;
      background: rgba(255, 255, 255, 0.05);
      border-radius: 8px;
    }

    .success-booking-id strong {
      color: #b7ff5a;
    }
    /* Booking Summary */
    .booking-summary {
      margin-top: 24px;
      padding: 24px;
      background: rgba(18, 22, 20, 0.95);
      border: 1px solid rgba(183, 255, 90, 0.25);
      border-radius: 16px;
      box-shadow: 0 0 24px rgba(183, 255, 90, 0.04);
      color: #f2f2f2;
    }

    .booking-summary h3 {
      margin: 0 0 20px;
      color: #b7ff5a;
      font-size: 20px;
      font-weight: 600;
      letter-spacing: 0.3px;
    }

    .summary-row {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      gap: 16px;
      padding: 13px 0;
      border-bottom: 1px solid rgba(255, 255, 255, 0.08);
    }

    .summary-row span {
      color: #a5aaa6;
      font-size: 14px;
    }

    .summary-row strong {
      color: #f5f5f5;
      font-size: 14px;
      font-weight: 500;
      text-align: right;
      overflow-wrap: anywhere;
    }

    .summary-total {
      margin-top: 8px;
      padding-top: 18px;
      border-bottom: none;
    }

    .summary-total span {
      color: #f5f5f5;
      font-size: 15px;
      font-weight: 600;
    }

    .summary-total strong {
      color: #b7ff5a;
      font-size: 23px;
      font-weight: 700;
    }

    /* Mobile layout */
    @media (max-width: 480px) {
      .booking-summary {
        padding: 18px;
      }

      .summary-row {
        gap: 10px;
      }

      .summary-total strong {
        font-size: 20px;
      }
    }


    .hint {
      margin-top: 8px;
      color: #a4a5ae;
      font-size: 12px;
    }

    @media (max-width: 480px) {
      .container {
        padding: 22px 18px;
      }
    }
    /* =========================================
   VISUAL PARKING SLOT BOOKING
========================================= */

    .visually-hidden {
      position: absolute !important;
      width: 1px !important;
      height: 1px !important;
      padding: 0 !important;
      margin: -1px !important;
      overflow: hidden !important;
      clip: rect(0, 0, 0, 0) !important;
      white-space: nowrap !important;
      border: 0 !important;
    }

    .visual-parking {
      margin: 28px 0;
      padding: 22px;
      background:
              radial-gradient(
                      ellipse at top right,
                      rgba(163, 255, 18, 0.07),
                      transparent 55%
              ),
              #131a15;
      border: 1px solid #303d30;
      border-radius: 15px;
    }

    .parking-eyebrow {
      margin: 0 0 8px;
      color: #b7ff5a;
      font-size: 10px;
      font-weight: 800;
      letter-spacing: 1.8px;
    }

    .parking-heading h2 {
      margin: 0;
      font-size: 22px;
    }

    .parking-description {
      margin: 9px 0 0;
      color: #a4ada4;
      font-size: 12px;
      line-height: 1.6;
    }

    .parking-legend {
      display: flex;
      flex-wrap: wrap;
      gap: 14px;
      margin: 24px 0;
      padding-bottom: 20px;
      border-bottom: 1px solid #303a30;
    }

    .parking-legend > span {
      display: inline-flex;
      align-items: center;
      gap: 7px;
      color: #d0d8d0;
      font-size: 11px;
    }

    .legend-circle {
      width: 9px;
      height: 9px;
      border-radius: 50%;
    }

    .available-circle {
      background: #63e875;
    }

    .occupied-circle {
      background: #ff4962;
    }

    .maintenance-circle {
      background: #ffc247;
    }

    .selected-circle {
      background: #b7ff5a;
      box-shadow: 0 0 10px #b7ff5a;
    }

    .parking-zone-list {
      display: flex;
      flex-direction: column;
      gap: 24px;
    }

    .user-zone {
      padding: 17px;
      background: rgba(5, 12, 7, 0.55);
      border: 1px solid #29392b;
      border-radius: 11px;
    }

    .user-zone-heading {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 12px;
      margin-bottom: 20px;
    }

    .user-zone-heading h3 {
      margin: 0;
      color: #f3f7f0;
      font-size: 16px;
    }

    .user-zone-heading p {
      margin: 6px 0 0;
      color: #93a093;
      font-size: 11px;
    }

    .zone-indicator {
      color: #9ba99a;
      font-size: 9px;
      letter-spacing: 1px;
      text-align: right;
    }

    .user-parking-grid {
      display: grid;
      grid-template-columns: repeat(
        auto-fill,
        minmax(78px, 1fr)
    );
      gap: 10px;
    }

    .user-parking-tile {
      position: relative;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      gap: 7px;
      min-width: 0;
      min-height: 88px;
      padding: 10px 4px;
      border: 1px solid;
      border-radius: 9px;
      color: white;
      background: #0b140d;
      font-family: inherit;
      cursor: pointer;
      transition:
              transform 0.2s ease,
              border-color 0.2s ease,
              box-shadow 0.2s ease,
              background 0.2s ease;
    }

    .user-car-icon {
      width: 25px;
      height: 25px;
    }

    .user-parking-tile > strong {
      max-width: 100%;
      overflow-wrap: anywhere;
      font-size: 11px;
    }

    .user-tile-status {
      font-size: 8px;
      font-weight: 800;
      letter-spacing: 0.4px;
    }

    .user-parking-tile.available {
      color: #9df5a3;
      background: linear-gradient(
              145deg,
              #183b20,
              #0b160e
      );
      border-color: #418c4b;
    }

    .user-parking-tile.available:hover {
      transform: translateY(-3px);
      border-color: #80ff89;
      box-shadow: 0 0 17px rgba(99, 232, 117, 0.18);
    }

    .user-parking-tile.occupied {
      color: #ff8997;
      background: linear-gradient(
              145deg,
              #451b24,
              #1b1013
      );
      border-color: #9c3545;
      cursor: not-allowed;
      opacity: 0.8;
    }

    .user-parking-tile.maintenance {
      color: #ffd16b;
      background: linear-gradient(
              145deg,
              #453517,
              #1b160c
      );
      border-color: #a77b24;
      cursor: not-allowed;
      opacity: 0.8;
    }

    .user-parking-tile.unknown {
      color: #c1c8c1;
      background: #222722;
      border-color: #555d55;
      cursor: not-allowed;
      opacity: 0.7;
    }

    /* Availability for the selected date and time */
    .user-parking-tile.checking {
      color: #ffe08a;
      background: #292315;
      border-color: #8a7131;
      cursor: wait;
    }

    .user-parking-tile.time-unavailable {
      color: #ff8997;
      background: linear-gradient(145deg, #451b24, #1b1013);
      border-color: #9c3545;
      cursor: not-allowed;
      opacity: 0.8;
    }

    .user-parking-tile.available-time {
      color: #9df5a3;
      background: linear-gradient(145deg, #183b20, #0b160e);
      border-color: #418c4b;
      cursor: pointer;
    }

    .user-parking-tile.available-time:hover {
      transform: translateY(-3px);
      border-color: #80ff89;
      box-shadow: 0 0 17px rgba(99, 232, 117, 0.18);
    }

    .user-parking-tile:disabled {
      cursor: not-allowed;
    }


    .user-parking-tile.selected {
      color: #caff8d;
      background: linear-gradient(
              145deg,
              #29451b,
              #14210e
      );
      border: 2px solid #b7ff5a;
      box-shadow:
              0 0 0 2px rgba(183, 255, 90, 0.12),
              0 0 20px rgba(183, 255, 90, 0.17);
      transform: translateY(-2px);
    }

    .selected-check {
      display: none;
      position: absolute;
      top: 5px;
      right: 6px;
      font-size: 10px;
      font-weight: 900;
    }

    .user-parking-tile.selected .selected-check {
      display: block;
    }

    .selection-hint {
      margin: 20px 0 0;
      color: #b7ff5a;
      font-size: 12px;
      line-height: 1.6;
    }

    @media (max-width: 480px) {
      .visual-parking {
        padding: 16px 12px;
      }

      .user-zone {
        padding: 12px 9px;
      }

      .user-parking-grid {
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 8px;
      }

      .user-parking-tile {
        min-height: 80px;
      }

      .parking-legend {
        gap: 12px;
      }
    }
  </style>
</head>

<body>
<div class="container">

  <h1>Book a Parking Slot</h1>
  <p class="subtitle">
    Welcome, <%= loggedInUser.getName() %>.
    Select your parking slot and booking time.
  </p>

  <% if ("1".equals(success)) { %>
  <div class="message success">
    Booking created successfully!
    Booking ID: <%= request.getParameter("id") %>
  </div>
  <% } %>


  <% if ("unavailable".equals(error)) { %>
  <div class="message error">
    This parking slot has just been booked by another user
    or is no longer available for your selected time.
    Please select another available slot.
  </div>
  <% } else if ("invalid".equals(error)) { %>
  <div class="message error">
    Invalid booking details. Please check your date and time
    and try again.
  </div>
  <% } else if ("failed".equals(error)) { %>
  <div class="message error">
    We couldn't complete your booking. Please try again.
  </div>
  <% } %>

  <!-- VISUAL PARKING SLOT SELECTOR -->
  <section class="visual-parking">

    <div class="parking-heading">
      <div>
        <p class="parking-eyebrow">SELECT YOUR SPACE</p>
        <h2>Choose a Parking Slot</h2>
        <p class="parking-description">
          Select an available space for your reservation.
        </p>
      </div>
    </div>

    <div class="parking-legend">
      <span><i class="legend-circle available-circle"></i> Available</span>
      <span><i class="legend-circle occupied-circle"></i> Occupied</span>
      <span><i class="legend-circle maintenance-circle"></i> Maintenance</span>
      <span><i class="legend-circle selected-circle"></i> Selected</span>
    </div>

    <div class="parking-zone-list">

      <% for (Map.Entry<String, List<ParkingSlot>> entry
              : parkingZones.entrySet()) { %>

      <section class="user-zone">

        <div class="user-zone-heading">
          <div>
            <h3><%= entry.getKey() %></h3>
            <p><%= entry.getValue().size() %> parking spaces</p>
          </div>

          <span class="zone-indicator">PARKING AREA</span>
        </div>

        <div class="user-parking-grid">

          <% for (ParkingSlot slot : entry.getValue()) {

            String status = slot.getStatus() == null
                    ? "UNKNOWN"
                    : slot.getStatus().toUpperCase();

            boolean available = "AVAILABLE".equals(status);

            String tileClass;

            if (available) {
              tileClass = "available";
            } else if ("OCCUPIED".equals(status)) {
              tileClass = "occupied";
            } else if ("MAINTENANCE".equals(status)) {
              tileClass = "maintenance";
            } else {
              tileClass = "unknown";
            }
          %>


          <button type="button"
                  class="user-parking-tile <%= tileClass %>"
                  data-slot-id="<%= slot.getId() %>"
                  data-slot-number="<%= slot.getSlotNumber() %>"
                  data-base-status="<%= status %>"
                  data-rate="<%= slot.getHourlyRate() %>"
                  <%= available ? "" : "disabled" %>
                  aria-pressed="false"
                  title="<%= available
                ? "Select date and time first"
                : status %>">


          <svg class="user-car-icon"
                 viewBox="0 0 24 24"
                 fill="none"
                 stroke="currentColor"
                 stroke-width="1.7"
                 stroke-linecap="round"
                 stroke-linejoin="round"
                 aria-hidden="true">
              <path d="M5 11l1.5-5h11L19 11"/>
              <path d="M3 11h18v7H3z"/>
              <path d="M5 18v2M19 18v2"/>
              <circle cx="7" cy="15" r="1"/>
              <circle cx="17" cy="15" r="1"/>
            </svg>

            <strong>
              <%= slot.getSlotNumber() %>
            </strong>

            <span class="user-tile-status">
    <%= available ? "SELECT TIME" : status %>
</span>

            <span class="selected-check">&#10003;</span>

          </button>

          <% } %>

        </div>

      </section>

      <% } %>

    </div>

    <p class="selection-hint" id="selectionHint">
      Choose a green tile to select your parking space.
    </p>

  </section>

  <form action="<%= request.getContextPath() %>/book"
        method="post">

    <label class="visually-hidden" for="slotId">
      Selected Parking Slot
    </label>

    <select id="slotId"
            name="slotId"
            class="visually-hidden"
            required>
      <option value="">Choose a slot</option>

      <% for (ParkingSlot slot : slots) {
        if ("AVAILABLE".equalsIgnoreCase(slot.getStatus())) { %>


      <option value="<%= slot.getId() %>"
              data-rate="<%= slot.getHourlyRate() %>">
        <%= slot.getSlotNumber() %> - Zone <%= slot.getZoneName() %> - Rs. <%= slot.getHourlyRate() %>/hour
      </option>


      <%  }
      } %>
    </select>

    <label for="bookingDate">Booking Date</label>
    <input type="date"
           id="bookingDate"
           name="bookingDate"
           min="<%= today %>"
           required>

    <label for="startTime">Start Time</label>
    <input type="time"
           id="startTime"
           name="startTime"
           required>

    <label for="endTime">End Time</label>
    <input type="time"
           id="endTime"
           name="endTime"
           required>

    <div id="availabilityMessage"
         style="margin: 12px 0; font-weight: bold;">
      Select a slot, date, and time to check availability.
    </div>



    <div class="price-estimate">
      <span>Estimated Booking Amount</span>
      <strong id="estimatedAmount">₹0.00</strong>
      <p id="priceBreakdown">
        Select a parking slot and booking time to calculate the price.
      </p>
    </div>
    <div class="booking-summary">
      <h3>Booking Summary</h3>

      <div class="summary-row">
        <span>Parking Slot</span>
        <strong id="summarySlot">Not selected</strong>
      </div>

      <div class="summary-row">
        <span>Date</span>
        <strong id="summaryDate">Not selected</strong>
      </div>

      <div class="summary-row">
        <span>Start Time</span>
        <strong id="summaryStart">--:--</strong>
      </div>

      <div class="summary-row">
        <span>End Time</span>
        <strong id="summaryEnd">--:--</strong>
      </div>

      <div class="summary-row">
        <span>Duration</span>
        <strong id="summaryDuration">0 minutes</strong>
      </div>

      <div class="summary-row summary-total">
        <span>Total Amount</span>
        <strong id="summaryAmount">Rs. 0.00</strong>
      </div>
    </div>



    <button type="submit" id="confirmBookingBtn" disabled>Confirm Booking</button>
  </form>

  <a class="back"
     href="<%= request.getContextPath() %>/dashboard.jsp">
    &larr; Back to Dashboard
  </a>

</div>

<script>

  const slotInput = document.getElementById("slotId");
  const dateInput = document.getElementById("bookingDate");
  const startInput = document.getElementById("startTime");
  const endInput = document.getElementById("endTime");

  const availabilityMessage =
          document.getElementById("availabilityMessage");
  const estimatedAmount = document.getElementById("estimatedAmount");
  const priceBreakdown = document.getElementById("priceBreakdown");
  const confirmBookingBtn =
          document.getElementById("confirmBookingBtn");

  const summarySlot = document.getElementById("summarySlot");
  const summaryDate = document.getElementById("summaryDate");
  const summaryStart = document.getElementById("summaryStart");
  const summaryEnd = document.getElementById("summaryEnd");
  const summaryDuration = document.getElementById("summaryDuration");
  const summaryAmount = document.getElementById("summaryAmount");

  const parkingTiles = [...document.querySelectorAll(".user-parking-tile")];
  const selectionHint = document.getElementById("selectionHint");
  const bookingForm = document.querySelector("form");

  let availabilityRequest = null;

  function hasValidTimeRange() {
    return dateInput.value &&
            startInput.value &&
            endInput.value &&
            endInput.value > startInput.value;
  }

  function getDurationMinutes() {
    if (!hasValidTimeRange()) {
      return 0;
    }

    const [sh, sm] = startInput.value.split(":").map(Number);
    const [eh, em] = endInput.value.split(":").map(Number);

    return (eh * 60 + em) - (sh * 60 + sm);
  }

  function updateTimeLimits() {
    const now = new Date();

    const currentDate =
            now.getFullYear() + "-" +
            String(now.getMonth() + 1).padStart(2, "0") + "-" +
            String(now.getDate()).padStart(2, "0");

    if (dateInput.value === currentDate) {
      startInput.min =
              String(now.getHours()).padStart(2, "0") + ":" +
              String(now.getMinutes()).padStart(2, "0");
    } else {
      startInput.removeAttribute("min");
    }

    endInput.min = startInput.value || "";
  }

  function setMessage(message, color = "#aaaaaa") {
    availabilityMessage.textContent = message;
    availabilityMessage.style.color = color;
  }

  function clearSelectedSlot() {
    slotInput.value = "";
    confirmBookingBtn.disabled = true;
    updateSelectedTile();
    updatePriceEstimate();
    updateBookingSummary();
  }

  function updateSelectedTile() {
    parkingTiles.forEach(tile => {
      const selected = tile.dataset.slotId === slotInput.value;

      tile.classList.toggle("selected", selected);
      tile.setAttribute("aria-pressed", String(selected));
    });

    const option = slotInput.options[slotInput.selectedIndex];

    selectionHint.textContent =
            slotInput.value && option
                    ? "Selected parking space: " + option.textContent.trim()
                    : "Select the date and time first, then choose an available tile.";
  }

  function updatePriceEstimate() {
    const option = slotInput.options[slotInput.selectedIndex];
    const rate = Number(option?.dataset.rate);
    const duration = getDurationMinutes();

    if (!slotInput.value ||
            !Number.isFinite(rate) ||
            duration <= 0) {

      estimatedAmount.textContent = "₹0.00";
      priceBreakdown.textContent =
              "Select an available parking slot and booking time.";
      return;
    }

    const total = rate * duration / 60;

    estimatedAmount.textContent = "₹" + total.toFixed(2);

    priceBreakdown.textContent =
            `₹${rate.toFixed(2)}/hour × ` +
            `${(duration / 60).toFixed(2)} hours`;
  }

  function updateBookingSummary() {
    const option = slotInput.options[slotInput.selectedIndex];

    summarySlot.textContent =
            slotInput.value && option
                    ? option.textContent.trim()
                    : "Not selected";

    summaryDate.textContent = dateInput.value || "Not selected";
    summaryStart.textContent = startInput.value || "--:--";
    summaryEnd.textContent = endInput.value || "--:--";

    const duration = getDurationMinutes();

    if (duration > 0) {
      const hours = Math.floor(duration / 60);
      const minutes = duration % 60;

      summaryDuration.textContent =
              (hours ? hours + " hour(s) " : "") +
              (minutes ? minutes + " minute(s)" : "");
    } else {
      summaryDuration.textContent = "0 minutes";
    }

    summaryAmount.textContent = estimatedAmount.textContent;
  }

  function resetAvailableTiles() {
    parkingTiles.forEach(tile => {
      const baseStatus = tile.dataset.baseStatus;
      const statusLabel = tile.querySelector(".user-tile-status");

      tile.dataset.timeAvailable = "false";
      tile.classList.remove(
              "checking",
              "time-unavailable",
              "available-time",
              "available",
              "occupied",
              "maintenance",
              "unknown"
      );

      if (baseStatus === "AVAILABLE") {
        tile.classList.add("available");
        tile.disabled = true;
        statusLabel.textContent = "SELECT TIME";
      } else {
        tile.classList.add(baseStatus.toLowerCase());
        tile.disabled = true;
        statusLabel.textContent = baseStatus;
      }
    });
  }

  async function checkAllSlotAvailability() {
    if (availabilityRequest) {
      availabilityRequest.abort();
    }

    availabilityRequest = new AbortController();
    const controller = availabilityRequest;

    clearSelectedSlot();
    resetAvailableTiles();

    if (!dateInput.value || !startInput.value || !endInput.value) {
      setMessage(
              "Choose a booking date, start time, and end time first."
      );
      return;
    }

    if (endInput.value <= startInput.value) {
      setMessage("End time must be after start time.", "#ff6262");
      return;
    }

    const now = new Date();
    const today =
            now.getFullYear() + "-" +
            String(now.getMonth() + 1).padStart(2, "0") + "-" +
            String(now.getDate()).padStart(2, "0");

    const currentTime =
            String(now.getHours()).padStart(2, "0") + ":" +
            String(now.getMinutes()).padStart(2, "0");

    if (dateInput.value < today ||
            (dateInput.value === today && startInput.value < currentTime)) {
      setMessage("Choose a future date and start time.", "#ff6262");
      return;
    }

    setMessage("Checking availability for all parking spaces...");

    const eligibleTiles = parkingTiles.filter(tile =>
            tile.dataset.baseStatus === "AVAILABLE"
    );

    if (eligibleTiles.length === 0) {
      setMessage("No parking spaces are currently available.", "#ff6262");
      return;
    }

    const checks = eligibleTiles.map(async tile => {
      const statusLabel = tile.querySelector(".user-tile-status");

      tile.disabled = true;
      tile.classList.remove("available");
      tile.classList.add("checking");
      statusLabel.textContent = "CHECKING";

      const params = new URLSearchParams({
        slotId: tile.dataset.slotId,
        date: dateInput.value,
        startTime: startInput.value,
        endTime: endInput.value
      });

      try {
        const response = await fetch(
                "<%= request.getContextPath() %>/check-availability?" +
                params.toString(),
                { signal: controller.signal }
        );

        const result = (await response.text()).trim();

        if (!response.ok ||
                (result !== "AVAILABLE" && result !== "UNAVAILABLE")) {
          throw new Error("Availability check failed");
        }

        if (controller !== availabilityRequest) {
          return;
        }

        tile.classList.remove("checking");

        if (result === "AVAILABLE") {
          tile.dataset.timeAvailable = "true";
          tile.classList.add("available-time");
          tile.disabled = false;
          statusLabel.textContent = "AVAILABLE";
          tile.title = "Available for the selected time";
        } else {
          tile.dataset.timeAvailable = "false";
          tile.classList.add("time-unavailable");
          tile.disabled = true;
          statusLabel.textContent = "UNAVAILABLE";
          tile.title = "Already booked for the selected time";
        }
      } catch (error) {
        if (error.name === "AbortError") {
          return;
        }

        if (controller !== availabilityRequest) {
          return;
        }

        tile.classList.remove("checking");
        tile.classList.add("time-unavailable");
        tile.dataset.timeAvailable = "false";
        tile.disabled = true;
        statusLabel.textContent = "CHECK ERROR";
        tile.title = "Could not verify availability. Change the time to retry.";
      }
    });

    await Promise.all(checks);

    if (controller !== availabilityRequest) {
      return;
    }

    const availableCount = eligibleTiles.filter(
            tile => tile.dataset.timeAvailable === "true"
    ).length;

    const failedCount = eligibleTiles.filter(
            tile => tile.querySelector(".user-tile-status").textContent ===
                    "CHECK ERROR"
    ).length;

    if (failedCount > 0) {
      setMessage(
              "Some spaces could not be checked. Please change the time or try again.",
              "#ff6262"
      );
    } else if (availableCount > 0) {
      setMessage(
              `${availableCount} space(s) available. Select a green tile to continue.`,
              "#b7ff5a"
      );
    } else {
      setMessage(
              "No spaces are available for this date and time.",
              "#ff6262"
      );
    }
  }

  parkingTiles.forEach(tile => {
    tile.addEventListener("click", () => {
      if (tile.disabled ||
              tile.dataset.timeAvailable !== "true") {
        return;
      }

      slotInput.value = tile.dataset.slotId;

      updateSelectedTile();
      updatePriceEstimate();
      updateBookingSummary();

      confirmBookingBtn.disabled = false;

      setMessage(
              "✓ This slot is available. You can confirm your booking.",
              "#b7ff5a"
      );
    });
  });

  [dateInput, startInput, endInput].forEach(input => {
    input.addEventListener("change", () => {
      updateTimeLimits();
      checkAllSlotAvailability();
    });
  });

  bookingForm.addEventListener("submit", event => {
    const selectedTile = parkingTiles.find(
            tile => tile.dataset.slotId === slotInput.value
    );

    if (!hasValidTimeRange()) {
      event.preventDefault();
      alert("Select a valid date, start time, and end time.");
      return;
    }

    if (!selectedTile ||
            selectedTile.dataset.timeAvailable !== "true" ||
            selectedTile.disabled) {
      event.preventDefault();
      alert("Please select a slot that is available for your chosen time.");
      return;
    }

    if (endInput.value <= startInput.value) {
      event.preventDefault();
      alert("End time must be later than start time.");
    }
  });

  updateTimeLimits();
  resetAvailableTiles();
  updateSelectedTile();
  updatePriceEstimate();
  updateBookingSummary();

</script>

</body>
</html>


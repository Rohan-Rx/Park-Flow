
package in.parkflow.servlet;

import in.parkflow.model.Booking;
import in.parkflow.model.User;
import in.parkflow.service.BookingService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;

@WebServlet("/book")
public class BookingServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();


    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        String contextPath = request.getContextPath();

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(contextPath + "/index.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (user.getId() == null) {
            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "User ID is missing. Please log in again.");
            return;
        }

        try {
            Long slotId = Long.parseLong(request.getParameter("slotId"));
            LocalDate bookingDate = LocalDate.parse(
                    request.getParameter("bookingDate"));
            LocalTime startTime = LocalTime.parse(
                    request.getParameter("startTime"));
            LocalTime endTime = LocalTime.parse(
                    request.getParameter("endTime"));

            Booking booking = bookingService.createBooking(
                    user.getId(),
                    slotId,
                    bookingDate,
                    startTime,
                    endTime);

            response.sendRedirect(contextPath
                    + "/booking-details.jsp?id=" + booking.getId());



        } catch (DateTimeParseException ex) {
            response.sendRedirect(contextPath
                    + "/bookings.jsp?error=invalid");

        } catch (IllegalArgumentException ex) {
            getServletContext().log("Booking rejected: " + ex.getMessage());

            response.sendRedirect(contextPath
                    + "/bookings.jsp?error=unavailable");

        } catch (Exception ex) {
            getServletContext().log("Failed to create parking booking", ex);

            response.sendRedirect(contextPath
                    + "/bookings.jsp?error=failed");
        }


    }
}

package in.parkflow.servlet;

import in.parkflow.model.Booking;
import in.parkflow.service.BookingService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/Admin/booking-details")
public class AdminBookingDetailsServlet extends HttpServlet {

    private final BookingService bookingService =
            new BookingService();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Booking ID is required."
            );
            return;
        }

        try {
            Long bookingId = Long.parseLong(idParam);

            if (bookingId <= 0) {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid booking ID."
                );
                return;
            }

            Booking booking =
                    bookingService.getBookingByIdForAdmin(bookingId);

            if (booking == null) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Booking not found."
                );
                return;
            }

            request.setAttribute("booking", booking);

            request.getRequestDispatcher(
                    "/Admin/booking-details.jsp"
            ).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid booking ID."
            );
        }
    }
}
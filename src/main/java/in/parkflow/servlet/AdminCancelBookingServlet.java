
package in.parkflow.servlet;

import in.parkflow.service.BookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/Admin/cancel-booking")
public class AdminCancelBookingServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

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

            boolean cancelled =
                    bookingService.cancelBookingByAdmin(bookingId);

            String result = cancelled ? "cancelled" : "cancel-failed";

            response.sendRedirect(
                    request.getContextPath()
                            + "/Admin/bookings?result=" + result
            );

        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid booking ID."
            );
        }
    }
}

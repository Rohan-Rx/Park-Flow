
package in.parkflow.servlet;

import in.parkflow.service.BookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;

@WebServlet("/check-availability")
public class AvailabilityServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();


    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain;charset=UTF-8");

        try {
            Long slotId = Long.parseLong(request.getParameter("slotId"));
            LocalDate date = LocalDate.parse(request.getParameter("date"));
            LocalTime start = LocalTime.parse(request.getParameter("startTime"));
            LocalTime end = LocalTime.parse(request.getParameter("endTime"));

            boolean available = bookingService.checkAvailability(
                    slotId, date, start, end);

            response.getWriter().write(
                    available ? "AVAILABLE" : "UNAVAILABLE");

        } catch (NumberFormatException | java.time.DateTimeException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("INVALID");

        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("INVALID");

        } catch (Exception e) {
            getServletContext().log("Availability check failed", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("ERROR");
        }
    }

}

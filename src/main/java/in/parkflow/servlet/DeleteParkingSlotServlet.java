
package in.parkflow.servlet;

import in.parkflow.service.ParkingSlotService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/Admin/delete-slot")
public class DeleteParkingSlotServlet extends HttpServlet {

    private final ParkingSlotService parkingSlotService =
            new ParkingSlotService();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String contextPath = request.getContextPath();
        String idValue = request.getParameter("id");

        if (idValue == null || idValue.isEmpty()) {
            response.sendRedirect(
                    contextPath + "/Admin/slots?error=missing"
            );
            return;
        }

        try {
            Long id = Long.parseLong(idValue);

            if (id <= 0) {
                response.sendRedirect(
                        contextPath + "/Admin/slots?error=notfound"
                );
                return;
            }

            if (parkingSlotService.hasBookings(id)) {
                response.sendRedirect(
                        contextPath + "/Admin/slots?error=hasbookings"
                );
                return;
            }

            parkingSlotService.deleteSlot(id);

            response.sendRedirect(
                    contextPath + "/Admin/slots?success=deleted"
            );

        } catch (NumberFormatException e) {
            response.sendRedirect(
                    contextPath + "/Admin/slots?error=notfound"
            );
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    contextPath + "/Admin/slots?error=notfound"
            );
        } catch (IllegalStateException e) {
            response.sendRedirect(
                    contextPath + "/Admin/slots?error=hasbookings"
            );
        }
    }
}

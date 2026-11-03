
package in.parkflow.servlet;

import in.parkflow.model.ParkingSlot;
import in.parkflow.service.ParkingSlotService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/Admin/edit-slot")
public class EditParkingSlotServlet extends HttpServlet {

    private final ParkingSlotService parkingSlotService =
            new ParkingSlotService();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response
    ) throws ServletException, IOException {

        String idValue = request.getParameter("id");
        String slotNumber = request.getParameter("slotNumber");
        String zoneName = request.getParameter("zoneName");
        String location = request.getParameter("location");
        String rateValue = request.getParameter("hourlyRate");
        String status = request.getParameter("status");

        String contextPath = request.getContextPath();

        try {
            if (idValue == null || slotNumber == null ||
                    zoneName == null || location == null ||
                    rateValue == null || status == null ||
                    idValue.trim().isEmpty() || slotNumber.trim().isEmpty() ||
                    zoneName.trim().isEmpty() || location.isEmpty() ||
                    rateValue.isEmpty() || status.isEmpty()) {

                response.sendRedirect(
                        contextPath + "/Admin/slots?error=missing"
                );
                return;
            }

            Long id = Long.parseLong(idValue);
            BigDecimal rate = new BigDecimal(rateValue.trim());

            if (id <= 0 || rate.compareTo(BigDecimal.ZERO) <= 0
                    || rate.scale() > 2) {
                response.sendRedirect(
                        contextPath + "/Admin/slots?error=rate"
                );
                return;
            }

            if (!status.equals("AVAILABLE")
                    && !status.equals("OCCUPIED")
                    && !status.equals("MAINTENANCE")) {
                response.sendRedirect(
                        contextPath + "/Admin/slots?error=missing"
                );
                return;
            }

            ParkingSlot slot = parkingSlotService.getSlotById(id);

            if (slot == null) {
                response.sendRedirect(
                        contextPath + "/Admin/slots?error=notfound"
                );
                return;
            }

            slot.setSlotNumber(slotNumber.trim());
            slot.setZoneName(zoneName.trim());
            slot.setLocation(location.trim());
            slot.setHourlyRate(rate);
            slot.setStatus(status);

            parkingSlotService.updateSlot(slot);

            response.sendRedirect(
                    contextPath + "/Admin/slots?success=updated"
            );

        } catch (NumberFormatException e) {
            response.sendRedirect(
                    contextPath + "/Admin/slots?error=rate"
            );
        } catch (IllegalArgumentException e) {
            response.sendRedirect(
                    contextPath + "/Admin/slots?error=notfound"
            );
        } catch (org.hibernate.exception.ConstraintViolationException e) {
            response.sendRedirect(
                    contextPath + "/Admin/slots?error=duplicate"
            );
        }
    }
}

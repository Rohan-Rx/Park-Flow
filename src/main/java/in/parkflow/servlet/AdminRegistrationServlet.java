package in.parkflow.servlet;

import in.parkflow.model.User;
import in.parkflow.service.RegistrationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/Admin/create-admin")
public class AdminRegistrationServlet extends HttpServlet {

    private final RegistrationService service =
            new RegistrationService();

    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp
    ) throws ServletException, IOException {

        req.getRequestDispatcher(
                "/Admin/admin-register.jsp"
        ).forward(req, resp);
    }

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp
    ) throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");
        String confirmPassword =
                req.getParameter("confirmPassword");

        if (isBlank(name) || isBlank(email)
                || isBlank(phone) || password == null
                || confirmPassword == null) {

            resp.sendRedirect(
                    req.getContextPath()
                            + "/Admin/create-admin?error=missing"
            );
            return;
        }

        if (!password.equals(confirmPassword)) {
            resp.sendRedirect(
                    req.getContextPath()
                            + "/Admin/create-admin?error=password"
            );
            return;
        }

        if (password.length() < 8) {
            resp.sendRedirect(
                    req.getContextPath()
                            + "/Admin/create-admin?error=weak"
            );
            return;
        }

        User admin = new User(
                name.trim(),
                email.trim(),
                phone.trim(),
                password
        );

        try {
            service.addAdminRegistration(admin);

            resp.sendRedirect(
                    req.getContextPath()
                            + "/Admin/create-admin?success=created"
            );

        } catch (SQLException e) {
            // SQLState class 23 covers integrity constraint violations,
            // including duplicate unique email/phone values.
            if (e.getSQLState() != null
                    && e.getSQLState().startsWith("23")) {

                resp.sendRedirect(
                        req.getContextPath()
                                + "/Admin/create-admin?error=duplicate"
                );
                return;
            }

            log("Failed to create admin account", e);

            resp.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to create admin account."
            );

        } catch (ClassNotFoundException e) {
            log("Database driver not found", e);

            resp.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Database configuration error."
            );
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
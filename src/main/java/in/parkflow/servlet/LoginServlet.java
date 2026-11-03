
package in.parkflow.servlet;

import in.parkflow.model.User;
import in.parkflow.service.LoginService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/Login")
public class LoginServlet extends HttpServlet {

    private final LoginService service = new LoginService();

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp
    ) throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        User user;

        try {
            // Authenticate only once
            user = service.login(email, password);

        } catch (SQLException e) {
            log("Error during login", e);

            resp.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Login failed due to a server error."
            );
            return;
        }

        if (user == null) {
            resp.sendRedirect(
                    req.getContextPath() + "/index.html?error=invalid"
            );
            return;
        }

        // Prevent session fixation after successful authentication
        HttpSession existingSession = req.getSession(false);

        if (existingSession != null) {
            existingSession.invalidate();
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("user", user);
        session.setAttribute("role", user.getRole());

        // Redirect according to the authenticated user's role
        if ("ADMIN".equalsIgnoreCase(user.getRole())) {

            resp.sendRedirect(
                    req.getContextPath() + "/Admin/dashboard.jsp"
            );

        } else if ("USER".equalsIgnoreCase(user.getRole())) {

            resp.sendRedirect(
                    req.getContextPath() + "/dashboard.jsp"
            );

        } else {
            session.invalidate();

            resp.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Your account has an invalid role."
            );
        }
    }
}

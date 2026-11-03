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

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {

    private final RegistrationService service =
            new RegistrationService();

    @Override
    protected void doPost(
            HttpServletRequest req,
            HttpServletResponse resp)
            throws ServletException, IOException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String phone = req.getParameter("phone");
        String confirmPassword =
                req.getParameter("confirmPassword");

        if (name == null || email == null || phone == null) {
            req.setAttribute("error", "Please fill in all required fields.");
            req.getRequestDispatcher("/register.jsp")
                    .forward(req, resp);
            return;
        }
        email = email.trim().toLowerCase(java.util.Locale.ROOT);
        phone = phone.trim();

        String emailRegex =
                "^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)+$";

        String phoneRegex = "^[6-9][0-9]{9}$";

        if (!email.matches(emailRegex)) {
            req.setAttribute("error", "Please enter a valid email address.");
            req.getRequestDispatcher("/register.jsp")
                    .forward(req, resp);
            return;
        }

        if (!phone.matches(phoneRegex)) {
            req.setAttribute("error",
                    "Enter a valid 10-digit Indian mobile number.");
            req.getRequestDispatcher("/register.jsp")
                    .forward(req, resp);
            return;
        }


        if (password == null ||
                !password.equals(confirmPassword)) {

            resp.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Passwords do not match"
            );

            return;
        }

        User user = new User(
                name,
                email,
                phone,
                password
        );



        try {

            service.addRegistration(user);

            resp.sendRedirect("index.jsp");

        } catch (SQLException |
                 ClassNotFoundException e) {

            e.printStackTrace();

            resp.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Registration failed"
            );
        }
    }
}
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



@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private final LoginService service = new LoginService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");

        String password = req.getParameter("password");


        User user;

        try {
            user = service.login(email, password);

        } catch (SQLException e) {
            e.printStackTrace();

            resp.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Login failed"
            );

            return;
        }


        if (user != null) {
            HttpSession session = req.getSession();

            session.setAttribute("user", user);

            // Go to dashboard
            resp.sendRedirect("dashboard.jsp");

        } else {

            // Invalid credentials
            resp.sendRedirect("index.html?error=invalid");
        }
    }
}
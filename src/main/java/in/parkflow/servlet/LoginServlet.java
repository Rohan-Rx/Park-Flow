package in.parkflow.servlet;

import in.parkflow.service.LoginService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private final LoginService service = new LoginService();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        boolean success = false;
        try {
            success = service.login(email,password);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        if(success){
            resp.sendRedirect("dashboard.jsp");
        }else{
            resp.sendRedirect("index.html?error=invalid");
        }

    }
}

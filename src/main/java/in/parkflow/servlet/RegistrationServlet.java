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
    RegistrationService service = new RegistrationService();
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name =req.getParameter("name");
        String email=req.getParameter("email");
        String password=req.getParameter("password");
        String phone=req.getParameter("phone");
        String confirm_pass=req.getParameter("confirmPassword");

        if (!password.equals(confirm_pass)){
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
        User user=new User(name,email,phone,password);
        try {
            service.addRegistration(user);
        } catch (SQLException | ClassNotFoundException e) {
            throw new RuntimeException(e);
        }


    }
}

package in.parkflow.filter;

import in.parkflow.model.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/Admin/*")
public class AdminFilter implements Filter {

    @Override
    public void doFilter(
            ServletRequest request,
            ServletResponse response,
            FilterChain chain
    ) throws IOException, ServletException {

        HttpServletRequest httpRequest =
                (HttpServletRequest) request;
        HttpServletResponse httpResponse =
                (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);

        System.out.println("ADMIN FILTER EXECUTED: "
                + httpRequest.getRequestURI());

        if (session == null ||
                session.getAttribute("user") == null) {

            httpResponse.sendRedirect(
                    httpRequest.getContextPath() + "/login.jsp"
            );
            return;
        }

        User user = (User) session.getAttribute("user");

        System.out.println("LOGGED-IN USER: " + user.getEmail());
        System.out.println("USER ROLE: " + user.getRole());

        if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
            httpResponse.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "You are not authorized to access this page."
            );
            return;
        }

        chain.doFilter(request, response);
    }
}
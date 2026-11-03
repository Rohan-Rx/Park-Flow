<%--
  Created by IntelliJ IDEA.
  User: ROHAN XD
  Date: 18-10-2026
  Time: 10:05 am
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="in.parkflow.model.User" %>

<%
  User loggedInUser =
          (User) session.getAttribute("user");

  if (loggedInUser == null
          || !"ADMIN".equalsIgnoreCase(loggedInUser.getRole())) {
    response.sendError(HttpServletResponse.SC_FORBIDDEN);
    return;
  }

  String error = request.getParameter("error");
  String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Create Admin | ParkFlow</title>

  <style>
    * {
      box-sizing: border-box;
    }

    body {
      margin: 0;
      padding: 32px 16px;
      min-height: 100vh;
      background: #0b0b0f;
      color: #f4f4f5;
      font-family: Arial, sans-serif;
    }

    .container {
      max-width: 540px;
      margin: 30px auto;
      padding: 30px;
      background: #17171d;
      border: 1px solid #30303a;
      border-radius: 16px;
    }

    h1 {
      margin-top: 0;
      font-size: 26px;
    }

    .subtitle {
      color: #a1a1aa;
      margin-bottom: 24px;
    }

    label {
      display: block;
      margin: 16px 0 7px;
      font-size: 14px;
    }

    input {
      width: 100%;
      padding: 12px;
      color: #fff;
      background: #101015;
      border: 1px solid #3f3f46;
      border-radius: 8px;
    }

    input:focus {
      outline: 2px solid #a3e635;
      border-color: transparent;
    }

    button, .back {
      display: inline-block;
      margin-top: 22px;
      padding: 12px 16px;
      border-radius: 8px;
      text-decoration: none;
      font-weight: bold;
    }

    button {
      width: 100%;
      border: none;
      background: #a3e635;
      color: #171717;
      cursor: pointer;
    }

    .back {
      color: #d4d4d8;
      border: 1px solid #3f3f46;
    }

    .message {
      padding: 12px;
      margin: 16px 0;
      border-radius: 8px;
      font-size: 14px;
    }

    .error {
      color: #fecaca;
      background: #451a1a;
    }

    .success {
      color: #d9f99d;
      background: #24320f;
    }
  </style>
</head>

<body>
<div class="container">

  <h1>Create Administrator</h1>
  <p class="subtitle">
    Register a new administrator for ParkFlow.
  </p>

  <% if ("missing".equals(error)) { %>
  <div class="message error">
    Please complete all fields.
  </div>
  <% } else if ("password".equals(error)) { %>
  <div class="message error">
    Passwords do not match.
  </div>
  <% } else if ("weak".equals(error)) { %>
  <div class="message error">
    Password must contain at least 8 characters.
  </div>
  <% } else if ("duplicate".equals(error)) { %>
  <div class="message error">
    The email or phone number is already registered.
  </div>
  <% } %>

  <% if ("created".equals(success)) { %>
  <div class="message success">
    Administrator account created successfully.
  </div>
  <% } %>

  <form action="<%= request.getContextPath() %>/Admin/create-admin"
        method="post">

    <label for="name">Full Name</label>
    <input type="text" id="name" name="name"
           maxlength="100" autocomplete="name" required>

    <label for="email">Email Address</label>
    <input type="email" id="email" name="email"
           maxlength="150" autocomplete="email" required>

    <label for="phone">Phone Number</label>
    <input type="tel" id="phone" name="phone"
           maxlength="15" autocomplete="tel" required>

    <label for="password">Password</label>
    <input type="password" id="password" name="password"
           minlength="8" autocomplete="new-password" required>

    <label for="confirmPassword">Confirm Password</label>
    <input type="password" id="confirmPassword"
           name="confirmPassword"
           minlength="8" autocomplete="new-password" required>

    <button type="submit">Create Admin Account</button>
  </form>

  <a class="back"
     href="<%= request.getContextPath() %>/Admin/dashboard.jsp">
    Back to Dashboard
  </a>

</div>
</body>
</html>

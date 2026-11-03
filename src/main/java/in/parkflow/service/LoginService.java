package in.parkflow.service;

import in.parkflow.database.DBConnection;
import in.parkflow.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LoginService {

    public User login(String email, String password)
            throws SQLException {

        String sql = "SELECT * FROM users WHERE email = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, email);

            try (ResultSet rs = statement.executeQuery()) {

                if (!rs.next()) {
                    return null;
                }

                String storedPassword = rs.getString("password");
                boolean authenticated;

                if (storedPassword != null
                        && (storedPassword.startsWith("$2a$")
                        || storedPassword.startsWith("$2b$")
                        || storedPassword.startsWith("$2y$"))) {

                    authenticated =
                            BCrypt.checkpw(password, storedPassword);

                } else {
                    // Temporary compatibility for existing accounts
                    authenticated = storedPassword != null
                            && storedPassword.equals(password);

                    if (authenticated) {
                        upgradePasswordHash(
                                connection,
                                rs.getLong("id"),
                                password
                        );
                    }
                }

                if (!authenticated) {
                    return null;
                }

                User user = new User();
                user.setId(rs.getLong("id"));
                user.setName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));

                // Don't store the password in the session's User object
                user.setPassword(null);

                return user;
            }

        } catch (ClassNotFoundException e) {
            throw new SQLException("Database driver not found", e);
        }
    }

    private void upgradePasswordHash(
            Connection connection,
            long userId,
            String password
    ) throws SQLException {

        String sql =
                "UPDATE users SET password = ? WHERE id = ?";

        String hashedPassword =
                BCrypt.hashpw(password, BCrypt.gensalt(12));

        try (PreparedStatement ps =
                     connection.prepareStatement(sql)) {

            ps.setString(1, hashedPassword);
            ps.setLong(2, userId);
            ps.executeUpdate();
        }
    }
}
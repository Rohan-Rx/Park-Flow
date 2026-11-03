package in.parkflow.service;

import in.parkflow.database.DBConnection;
import in.parkflow.model.User;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class RegistrationService {

    public void addRegistration(User user)
            throws SQLException, ClassNotFoundException {

        String sql = "Insert into users (full_name,email, phone, password, role)values(?,?,?,?,'USER')";

        insertUser(user, sql);
    }

    public void addAdminRegistration(User user)
            throws SQLException, ClassNotFoundException {

        String sql = " INSERT INTO users (full_name, email, phone, password, role) VALUES (?, ?, ?, ?, 'ADMIN') ";

        insertUser(user, sql);
    }

    private void insertUser(User user, String sql)
            throws SQLException, ClassNotFoundException {

        String hashedPassword =
                BCrypt.hashpw(user.getPassword(), BCrypt.gensalt(12));

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, hashedPassword);

            ps.executeUpdate();
        }
    }
}
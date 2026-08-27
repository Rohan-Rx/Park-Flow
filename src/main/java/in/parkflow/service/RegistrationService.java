package in.parkflow.service;


import in.parkflow.database.DBConnection;
import in.parkflow.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class RegistrationService {

    public void addRegistration(User user) throws SQLException, ClassNotFoundException {
        String sql="Insert into users(full_name,email,phone,password) values(?,?,?,?)";
        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, user.getName());
        ps.setString(2,user.getEmail());
        ps.setString(3,user.getPhone());
        ps.setString(4,user.getPassword());

        ps.executeUpdate();
    }

}

package dao;

import model.Room;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO implements IRoomDAO{
    private static final String URLDB = "jdbc:mysql://localhost:3306/RentalManagement";
    private static final String USERDB = "root";
    private static final String PASSWORD = "123456";

    private static final String SELECT_ALL_ROOM = "SELECT r.id, r.tenant_name, r.phone_number, r.start_date, p.method_name, r.notes FROM Room r JOIN PaymentMethod p ON r.payment_method_id = p.id ORDER BY r.id;";
    private static final String INSERT_ROOM_SQL = "INSERT INTO Room (tenant_name, phone_number, start_date, payment_method_id, notes) VALUES (?, ?, ?, ?, ?)";
    private static final String DELETE_ROOM_SQL = "DELETE FROM Room WHERE id = ?";



    private Connection getConnection(){
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(URLDB, USERDB, PASSWORD);
            return connection;
        } catch (SQLException | ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
    }

    public List<Room> getAllRooms() {

        Connection connection = getConnection();
        try {
            PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_ROOM);
            ResultSet resultSet = preparedStatement.executeQuery();
            List<Room> rooms = new ArrayList<>();
            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String tenant_name = resultSet.getString("tenant_name");
                String phone_number = resultSet.getString("phone_number");
                LocalDate start_date = resultSet.getDate("start_date").toLocalDate();
                String method_name = resultSet.getString("method_name");
                String notes = resultSet.getString("notes");
                Room room = new Room(id, tenant_name, phone_number, start_date, method_name, notes);
                rooms.add(room);
            }
            return rooms;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void insert(Room room) {
        System.out.println(INSERT_ROOM_SQL);
        try (Connection connection = getConnection(); PreparedStatement preparedStatement = connection.prepareStatement(INSERT_ROOM_SQL)) {
            preparedStatement.setString(1, room.getTenantName());
            preparedStatement.setString(2, room.getPhoneNumber());
            preparedStatement.setDate(3, Date.valueOf(room.getStartDate()));
            preparedStatement.setInt(4, room.getPaymentMethodId());
            preparedStatement.setString(5, room.getNotes());
            System.out.println(preparedStatement);
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            printSQLException(e);
        }
    }

    public boolean delete(int id) throws SQLException {
        boolean rowDeleted;
        try (Connection connection = getConnection(); PreparedStatement statement = connection.prepareStatement(DELETE_ROOM_SQL);) {
            statement.setInt(1, id);
            rowDeleted = statement.executeUpdate() > 0;
        }
        return rowDeleted;
    }

    private void printSQLException(SQLException ex) {
        for (Throwable e : ex) {
            if (e instanceof SQLException) {
                e.printStackTrace(System.err);
                System.err.println("SQLState: " + ((SQLException) e).getSQLState());
                System.err.println("Error Code: " + ((SQLException) e).getErrorCode());
                System.err.println("Message: " + e.getMessage());
                Throwable t = ex.getCause();
                while (t != null) {
                    System.out.println("Cause: " + t);
                    t = t.getCause();
                }
            }
        }
    }
}


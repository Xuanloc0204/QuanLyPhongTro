package dao;

import model.Room;

import java.sql.SQLException;
import java.util.List;

public interface IRoomDAO {
    List<Room> getAllRooms();
    void insert(Room room);
    boolean delete(int id) throws SQLException;
}

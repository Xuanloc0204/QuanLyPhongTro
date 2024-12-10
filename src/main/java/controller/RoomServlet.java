package controller;

import dao.IRoomDAO;
import dao.RoomDAO;
import model.Room;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "RoomServlet", urlPatterns = "/Room")
public class RoomServlet extends HttpServlet {
    private final IRoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) action = "list";

        switch (action) {
            case "list":
                listRooms(request, response);
                break;
            case "delete":
                try {
                    deleteRoom(request, response);
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
                break;
            default:
                listRooms(request, response);
                break;
        }
    }

    private void listRooms(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        List<Room> rooms = roomDAO.getAllRooms();
        request.setAttribute("rooms", rooms);
        RequestDispatcher dispatcher = request.getRequestDispatcher("room-list.jsp");
        dispatcher.forward(request, response);
    }

    private void deleteRoom(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        roomDAO.delete(id);
        response.sendRedirect("Room?action=list");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        switch (action) {
            case "create":
                create(request, response);
                break;
            case "delete":
                try {
                    delete(request, response);
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
                break;
            default:
                listRooms(request, response);
                break;
        }
    }
    private void create (HttpServletRequest request, HttpServletResponse response) throws IOException {
        String tenantName = request.getParameter("tenantName");
        String phoneNumber = request.getParameter("phoneNumber");
        LocalDate startDate = LocalDate.parse(request.getParameter("startDate"));
        int paymentMethodId = Integer.parseInt(request.getParameter("paymentMethod"));
        String notes = request.getParameter("notes");

        Room room = new Room();
        room.setTenantName(tenantName);
        room.setPhoneNumber(phoneNumber);
        room.setStartDate(startDate);
        room.setPaymentMethodId(paymentMethodId);
        room.setNotes(notes);

        roomDAO.insert(room);
        response.sendRedirect("Room?action=list");
    }
    private void delete (HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
            String[] selectedIds = request.getParameterValues("selectedIds");
            if (selectedIds != null) {
                for (String id : selectedIds) {
                    roomDAO.delete(Integer.parseInt(id));
                }
            }
            response.sendRedirect("Room?action=list");
    }
}


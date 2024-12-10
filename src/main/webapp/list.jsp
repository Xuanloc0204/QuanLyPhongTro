<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 12/11/2024
  Time: 02:39
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý thuê phòng trọ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            background-color: #f8f9fa;
        }

        .card-header {
            background-color: #28a745;
            color: white;
            text-align: center;
        }

        .table-container {
            margin-top: 20px;
        }

        .table th, .table td {
            vertical-align: middle;
        }

        .modal-header {
            background-color: #28a745;
            color: white;
        }

        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }

        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }

        .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
        }

        .btn-danger:hover {
            background-color: #c82333;
            border-color: #bd2130;
        }

        .form-control, .form-select, .btn {
            border-radius: 0.375rem;
        }

        .modal-content {
            border-radius: 0.375rem;
        }

        .mb-3 {
            margin-bottom: 1.5rem;
        }

        .fw-bold {
            font-weight: 700;
        }
    </style>
</head>
<body>

<div class="container table-container">
    <div class="card mb-3">
        <div class="card-header">
            <h1 class="fw-bold">Danh Sách Phòng Trọ</h1>
        </div>

        <!-- Nút Tạo Mới -->
        <button class="btn btn-success mb-3" data-bs-toggle="modal" data-bs-target="#createModal">Tạo mới</button>

        <form id="deleteForm" method="post" action="Room?action=delete">
            <table class="table table-bordered table-striped">
                <thead class="table-light">
                <tr>
                    <th>#</th>
                    <th>Tên người thuê</th>
                    <th>Số điện thoại</th>
                    <th>Ngày bắt đầu</th>
                    <th>Hình thức thanh toán</th>
                    <th>Ghi chú</th>
                    <th>
                        <input type="checkbox" id="selectAll" onclick="toggleSelectAll(this)">
                    </th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="room" items="${rooms}">
                    <tr>
                        <td>${room.id}</td>
                        <td>${room.tenantName}</td>
                        <td>${room.phoneNumber}</td>
                        <td>${room.startDate}</td>
                        <td>${room.paymentMethodName}</td> <!-- Hiển thị phương thức thanh toán -->
                        <td>${room.notes}</td>
                        <td>
                            <input type="checkbox" name="selectedIds" value="${room.id}">
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <div class="d-flex justify-content-end">
                <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#confirmDeleteModal">Xóa</button>
            </div>
        </form>

        <!-- Modal Xác nhận -->
        <div class="modal fade" id="confirmDeleteModal" tabindex="-1" aria-labelledby="confirmDeleteModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="confirmDeleteModalLabel">Xác nhận xóa</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p id="confirmMessage">Bạn có muốn xóa thông tin thuê trọ đã chọn không?</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-danger">Xóa</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Tạo Mới -->
    <div class="modal fade" id="createModal" tabindex="-1" aria-labelledby="createModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="createModalLabel">Tạo mới thông tin thuê trọ</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="createForm" method="post" action="Room?action=create">
                        <div class="mb-3">
                            <label for="tenantName" class="form-label">Tên người thuê</label>
                            <input type="text" class="form-control" id="tenantName" name="tenantName" required
                                   pattern="^[A-Za-zÀ-ÿ\s'-]{5,50}$"
                                   title="Chỉ cho phép ký tự chữ cái, khoảng trắng, từ 5 đến 50 ký tự">
                        </div>
                        <div class="mb-3">
                            <label for="phoneNumber" class="form-label">Số điện thoại</label>
                            <input type="text" class="form-control" id="phoneNumber" name="phoneNumber" required
                                   pattern="^\d{10}$" title="Số điện thoại phải là 10 chữ số">
                        </div>
                        <div class="mb-3">
                            <label for="startDate" class="form-label">Ngày bắt đầu thuê</label>
                            <input type="date" class="form-control" id="startDate" name="startDate" required
                                   min="<%= java.time.LocalDate.now() %>">
                        </div>
                        <div class="mb-3">
                            <label for="paymentMethod" class="form-label">Hình thức thanh toán</label>
                            <select class="form-select" id="paymentMethod" name="paymentMethod" required>
                                <option value="1">Theo tháng</option>
                                <option value="2">Theo quý</option>
                                <option value="3">Theo năm</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="notes" class="form-label">Ghi chú</label>
                            <textarea class="form-control" id="notes" name="notes" maxlength="200"></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">Tạo mới</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

</div>

<script>
    // Tự động kiểm tra tất cả checkbox
    function toggleSelectAll(selectAll) {
        const checkboxes = document.querySelectorAll('input[name="selectedIds"]');
        checkboxes.forEach(checkbox => checkbox.checked = selectAll.checked);
    }
</script>

</body>
</html>


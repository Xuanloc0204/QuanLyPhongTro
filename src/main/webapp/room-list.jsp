<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Quản lý thuê phòng trọ</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        /* Cải tiến bảng */
        .table th, .table td {
            vertical-align: middle;
            text-align: center;
        }

        .table tbody tr:hover {
            background-color: #f8f9fa;
        }

        /* Cải tiến modal */
        .modal-dialog {
            max-width: 800px;
        }

        /* Tăng cường khoảng cách cho các nút */
        .btn-space {
            margin-right: 10px;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <div class="card shadow-sm">
        <div class="card-header text-success text-center py-3">
            <h1 class="fw-bold">Danh Sách Phòng Trọ</h1>
        </div>

        <!-- Nút Tạo Mới -->
        <div class="card-body">
            <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#createModal">Tạo mới</button>
            <form id="deleteForm" method="post" action="Room?action=delete">
                <table class="table table-bordered table-striped">
                    <thead>
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
                            <td>${room.paymentMethodName}</td>
                            <td>${room.notes}</td>
                            <td>
                                <input type="checkbox" name="selectedIds" value="${room.id}">
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

                <div class="text-end">
                    <button type="button" class="btn btn-danger btn-space" data-bs-toggle="modal" data-bs-target="#confirmDeleteModal">Xóa</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal Xác nhận Xóa -->
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

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý sản phẩm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<div class="container">
    <div class="page-header">
        <h1 class="fs-3 fw-bold mb-0">Quản lý sản phẩm</h1>
    </div>
    <div class="category-toolbar">
        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/waiting">← Quay về trang chủ</a>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/product/add">+ Thêm sản phẩm</a>
    </div>
    <div class="card">
        <div class="table-wrapper">
            <table class="category-table">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Hình ảnh</th>
                        <th>Tên sản phẩm</th>
                        <th>Giá</th>
                        <th>Số lượng</th>
                        <th>Danh mục</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${productList}" var="product" varStatus="STT">
                        <tr>
                            <td>${STT.index+1}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty product.image}">
                                        <c:url value="/image" var="imgUrl">
                                            <c:param name="fname" value="${product.image}"/>
                                        </c:url>
                                        <img class="category-image" src="${imgUrl}" alt="${product.name}">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="image-placeholder">Không có ảnh</div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><strong>${product.name}</strong></td>
                            <td>
                                <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                            </td>
                            <td>${product.quantity}</td>
                            <td>${product.category.name}</td>
                            <td>
                                <div class="action-group">
                                    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/product/edit?id=${product.id}">Sửa</a>
                                    <a class="btn btn-danger" href="${pageContext.request.contextPath}/admin/product/delete?id=${product.id}" onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?');">Xóa</a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty productList}">
                        <tr>
                            <td colspan="7" class="empty-state">Chưa có sản phẩm nào.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
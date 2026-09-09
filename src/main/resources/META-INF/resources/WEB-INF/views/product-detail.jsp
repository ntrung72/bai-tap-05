<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<div class="container">
    <div class="page-header">
        <h1 class="fs-3 fw-bold mb-0">Chi tiết sản phẩm</h1>
        <p>Thông tin chi tiết của sản phẩm đã chọn.</p>
    </div>
    <div class="card category-form-card">
        <c:if test="${not empty product.image}">
            <c:url value="/image" var="imgUrl">
                <c:param name="fname" value="${product.image}"/>
            </c:url>
            <div class="current-image-box">
                <img class="category-edit-image" src="${imgUrl}" alt="${product.name}">
            </div>
        </c:if>
        <div class="profile-info">
            <div class="profile-label">Tên sản phẩm</div>
            <div class="profile-value">${product.name}</div>
            <div class="profile-label">Giá</div>
            <div class="profile-value">
                <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
            </div>
            <div class="profile-label">Số lượng</div>
            <div class="profile-value">${product.quantity}</div>
            <div class="profile-label">Danh mục</div>
            <div class="profile-value">${product.category.name}</div>
            <div class="profile-label">Mô tả</div>
            <div class="profile-value">${product.description}</div>
        </div>
        <div class="form-actions">
            <a href="${pageContext.request.contextPath}/product" class="btn btn-secondary">← Quay lại danh sách</a>
            <c:if test="${sessionScope.account != null}">
                <a href="${pageContext.request.contextPath}/waiting" class="btn btn-primary">Trang chủ</a>
            </c:if>
        </div>
    </div>
</div>
</body>
</html>
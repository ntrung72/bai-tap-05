<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sản phẩm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<div class="container">
    <div class="page-header">
        <h1 class="fs-3 fw-bold mb-0">Tất cả sản phẩm</h1>
    </div>
    <div class="category-toolbar">
        <c:if test="${sessionScope.account != null}">
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/waiting">← Quay về trang chủ</a>
        </c:if>
    </div>
    <div class="card">
        <div class="table-wrapper">
            <table class="category-table">
                <thead>
                    <tr>
                        <th>Hình ảnh</th>
                        <th>Tên sản phẩm</th>
                        <th>Giá</th>
                        <th>Số lượng</th>
                        <th>Danh mục</th>
                        <th>Mô tả</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${products}" var="product">
                        <tr>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty product.image}">
                                        <c:url value="/image" var="imgUrl">
                                            <c:param name="fname" value="${product.image}"/>
                                        </c:url>
                                        <a href="${pageContext.request.contextPath}/product/detail?id=${product.id}">
                                            <img class="category-image" src="${imgUrl}" alt="${product.name}">
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="image-placeholder">Không có ảnh</div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/product/detail?id=${product.id}">
                                    <strong>${product.name}</strong>
                                </a>
                            </td>
                            <td>
                                <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true" maxFractionDigits="0"/>đ
                            </td>
                            <td>${product.quantity}</td>
                            <td>${product.category.name}</td>
                            <td>${product.description}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty products}">
                        <tr>
                            <td colspan="6" class="empty-state">Chưa có sản phẩm nào.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
    <c:if test="${totalProducts > 0}">
        <div class="form-actions">
            <c:if test="${currentPage > 1}">
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/product?page=${currentPage-1}">← Trang trước</a>
            </c:if>
            <c:forEach begin="1" end="${totalPages}" var="pageNumber">
                <a class="btn ${pageNumber==currentPage?'btn-primary':'btn-secondary'}" href="${pageContext.request.contextPath}/product?page=${pageNumber}">${pageNumber}</a>
            </c:forEach>
            <c:if test="${currentPage < totalPages}">
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/product?page=${currentPage+1}">Trang sau →</a>
            </c:if>
        </div>
    </c:if>
</div>
</body>
</html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ</title>
</head>
<body>
<div class="dashboard-layout">
    <main class="dashboard-content home-content">
        <div class="page-header home-page-header">
            <h1>10 sản phẩm mới nhất</h1>
        </div>
        <div class="home-product-grid">
            <c:forEach items="${latestProducts}" var="product">
                <a class="home-product-card" href="${pageContext.request.contextPath}/product/detail?id=${product.id}">
                    <div class="home-product-image-wrap">
                        <c:choose>
                            <c:when test="${not empty product.image}">
                                <c:url value="/image" var="imgUrl">
                                    <c:param name="fname" value="${product.image}"/>
                                </c:url>
                                <img src="${imgUrl}" alt="${product.name}" class="home-product-image"/>
                            </c:when>
                            <c:otherwise>
                                <div class="home-product-placeholder">Không có ảnh</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="home-product-info">
                        <div class="home-product-name" title="${product.name}">
                            ${product.name}
                        </div>
                        <div class="home-product-category" title="${product.category.name}">
                            ${product.category.name}
                        </div>
                        <div class="home-product-category">
                            Còn ${product.quantity} sản phẩm
                        </div>
                        <div class="home-product-price">
                            <fmt:formatNumber value="${product.price}" type="number" groupingUsed="true" maxFractionDigits="0"/>
                            đ
                        </div>
                    </div>
                </a>
            </c:forEach>
            <c:if test="${empty latestProducts}">
                <div class="home-empty-state">
                    Chưa có sản phẩm nào.
                </div>
            </c:if>
        </div>
    </main>
</div>
</body>
</html>
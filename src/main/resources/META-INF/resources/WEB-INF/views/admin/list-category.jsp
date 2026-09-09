<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý danh mục</title>
    </head>
    <body>
        <div class="container">
            <div class="page-header">
                <h1 class="fs-3 fw-bold mb-0">Quản lý danh mục</h1>
            </div>
            <c:if test="${not empty sessionScope.categoryDeleteError}">
                <div class="alert alert-error">${sessionScope.categoryDeleteError}</div>
                <c:remove var="categoryDeleteError" scope="session"/>
            </c:if>
            <div class="category-toolbar">
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/waiting">← Trang chủ</a>
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/category/add">+ Thêm danh mục</a>
            </div>
            <form class="card p-3 mb-3" action="${pageContext.request.contextPath}/admin/category/searchpaginated" method="get">
                <div class="d-flex gap-2">
                    <input class="form-control" type="text" name="name" value="${name}" placeholder="Nhập tên danh mục cần tìm">
                    <input type="hidden" name="size" value="${categoryPage.size}">
                    <button class="btn btn-primary">Tìm kiếm</button>
                    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/category/list">Xóa lọc</a>
                </div>
            </form>
            <div class="card">
                <div class="table-wrapper">
                    <table class="category-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Hình ảnh</th>
                                <th>Tên danh mục</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${categoryPage.content}" var="cate" varStatus="st">
                                <tr>
                                    <td>${categoryPage.number*categoryPage.size+st.index+1}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty cate.icon}">
                                                <c:url value="/image" var="imgUrl">
                                                    <c:param name="fname" value="${cate.icon}"/>
                                                </c:url>
                                                <img class="category-image" src="${imgUrl}" alt="${cate.name}">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="image-placeholder">Không có ảnh</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <strong>${cate.name}</strong>
                                    </td>
                                    <td>
                                        <div class="action-group">
                                            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/category/edit?id=${cate.id}">Sửa</a>
                                            <a class="btn btn-danger" href="${pageContext.request.contextPath}/admin/category/delete?id=${cate.id}" onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục này?');">Xóa</a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${!categoryPage.hasContent()}">
                                <tr>
                                    <td colspan="4" class="empty-state">Không tìm thấy danh mục.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mt-3">
                <form method="get">
                    <input type="hidden" name="name" value="${name}">
                    <label>
                        Số dòng:
                        <select name="size" onchange="this.form.submit()">
                            <option value="3" ${categoryPage.size==3?'selected':''}>3</option>
                            <option value="5" ${categoryPage.size==5?'selected':''}>5</option>
                            <option value="10" ${categoryPage.size==10?'selected':''}>10</option>
                            <option value="15" ${categoryPage.size==15?'selected':''}>15</option>
                            <option value="20" ${categoryPage.size==20?'selected':''}>20</option>
                        </select>
                    </label>
                </form>
                <div class="form-actions">
                    <c:forEach items="${pageNumbers}" var="p">
                        <c:url value="/admin/category/searchpaginated" var="pageUrl">
                            <c:param name="name" value="${name}"/>
                            <c:param name="size" value="${categoryPage.size}"/>
                            <c:param name="page" value="${p}"/>
                        </c:url>
                        <a class="btn ${p==categoryPage.number+1?'btn-primary':'btn-secondary'}" href="${pageUrl}">${p}</a>
                    </c:forEach>
                </div>
            </div>
        </div>
    </body>
</html>

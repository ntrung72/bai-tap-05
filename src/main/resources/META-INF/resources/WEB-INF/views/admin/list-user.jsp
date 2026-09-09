<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý người dùng</title>
    </head>
    <body>
        <div class="container">
            <div class="page-header">
                <h1 class="fs-3 fw-bold mb-0">Quản lý người dùng</h1>
            </div>
            <c:if test="${not empty sessionScope.userDeleteError}">
                <div class="alert alert-error">${sessionScope.userDeleteError}</div>
                <c:remove var="userDeleteError" scope="session"/>
            </c:if>
            <div class="category-toolbar">
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/waiting">← Trang chủ</a>
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/user/add">+ Thêm người dùng</a>
            </div>
            <form class="card p-3 mb-3" action="${pageContext.request.contextPath}/admin/user/searchpaginated">
                <div class="d-flex gap-2">
                    <input class="form-control" name="keyword" value="${keyword}" placeholder="Tìm theo tài khoản, họ tên hoặc email">
                    <input type="hidden" name="size" value="${userPage.size}">
                    <button class="btn btn-primary">Tìm kiếm</button>
                    <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/user/list">Xóa lọc</a>
                </div>
            </form>
            <div class="card">
                <div class="table-wrapper">
                    <table class="category-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Tài khoản</th>
                                <th>Họ tên</th>
                                <th>Email</th>
                                <th>Điện thoại</th>
                                <th>Role</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${userPage.content}" var="u" varStatus="st">
                                <tr>
                                    <td>${userPage.number*userPage.size+st.index+1}</td>
                                    <td>${u.userName}</td>
                                    <td>${u.fullName}</td>
                                    <td>${u.email}</td>
                                    <td>${u.phone}</td>
                                    <td>${u.roleid}</td>
                                    <td>
                                        <div class="action-group">
                                            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/user/edit?id=${u.id}">Sửa</a>
                                            <a class="btn btn-danger" href="${pageContext.request.contextPath}/admin/user/delete?id=${u.id}" onclick="return confirm('Xóa người dùng này?')">Xóa</a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${!userPage.hasContent()}">
                                <tr>
                                    <td colspan="7" class="empty-state">Không tìm thấy người dùng.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="d-flex justify-content-between align-items-center mt-3">
                <form>
                    <input type="hidden" name="keyword" value="${keyword}">
                    <label>
                        Số dòng:
                        <select name="size" onchange="this.form.submit()">
                            <option value="3" ${userPage.size==3?'selected':''}>3</option>
                            <option value="5" ${userPage.size==5?'selected':''}>5</option>
                            <option value="10" ${userPage.size==10?'selected':''}>10</option>
                            <option value="15" ${userPage.size==15?'selected':''}>15</option>
                            <option value="20" ${userPage.size==20?'selected':''}>20</option>
                        </select>
                    </label>
                </form>
                <div class="form-actions">
                    <c:forEach items="${pageNumbers}" var="p">
                        <c:url value="/admin/user/searchpaginated" var="url">
                            <c:param name="keyword" value="${keyword}"/>
                            <c:param name="size" value="${userPage.size}"/>
                            <c:param name="page" value="${p}"/>
                        </c:url>
                        <a class="btn ${p==userPage.number+1?'btn-primary':'btn-secondary'}" href="${url}">${p}</a>
                    </c:forEach>
                </div>
            </div>
        </div>
    </body>
</html>

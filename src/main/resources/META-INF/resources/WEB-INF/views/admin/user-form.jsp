<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>${isEdit?'Sửa':'Thêm'} người dùng</title>
    </head>
    <body>
        <div class="container">
            <div class="page-header">
                <h1 class="fs-3 fw-bold mb-0">${isEdit?'Sửa':'Thêm'} người dùng</h1>
            </div>
            <div class="card category-form-card">
                <form class="needs-validation" action="${pageContext.request.contextPath}/admin/user/save" method="post" novalidate>
                    <input type="hidden" name="id" value="${user.id}">
                    <div class="form-group">
                        <label for="username">Tên đăng nhập</label>
                        <input class="${not empty errors.userName?'is-invalid-server':''}" id="username" name="username" value="${user.userName}" minlength="3" maxlength="50" pattern="[A-Za-z0-9._]+" required>
                        <c:if test="${not empty errors.userName}">
                            <span class="field-error">${errors.userName}</span>
                        </c:if>
                    </div>
                    <div class="form-group">
                        <label for="fullname">Họ tên</label>
                        <input class="${not empty errors.fullName?'is-invalid-server':''}" id="fullname" name="fullname" value="${user.fullName}" minlength="2" maxlength="100" required>
                        <c:if test="${not empty errors.fullName}">
                            <span class="field-error">${errors.fullName}</span>
                        </c:if>
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input class="${not empty errors.email?'is-invalid-server':''}" type="email" id="email" name="email" value="${user.email}" required>
                        <c:if test="${not empty errors.email}">
                            <span class="field-error">${errors.email}</span>
                        </c:if>
                    </div>
                    <div class="form-group">
                        <label for="phone">Số điện thoại</label>
                        <input class="${not empty errors.phone?'is-invalid-server':''}" id="phone" name="phone" value="${user.phone}" pattern="[0-9]{9,11}" required>
                        <c:if test="${not empty errors.phone}">
                            <span class="field-error">${errors.phone}</span>
                        </c:if>
                    </div>
                    <div class="form-group">
                        <label for="password">Mật khẩu ${isEdit?'(để trống nếu không đổi)':''}</label>
                        <input class="${not empty errors.passWord?'is-invalid-server':''}" type="password" id="password" name="password" minlength="6" maxlength="72" ${isEdit?'':'required'}>
                        <c:if test="${not empty errors.passWord}">
                            <span class="field-error">${errors.passWord}</span>
                        </c:if>
                    </div>
                    <div class="form-group">
                        <label for="roleid">Role</label>
                        <select id="roleid" name="roleid">
                            <option value="1" ${user.roleid==1?'selected':''}>1 - Admin</option>
                            <option value="2" ${user.roleid==2?'selected':''}>2 - Manager</option>
                            <option value="5" ${user.roleid==5?'selected':''}>5 - Member</option>
                        </select>
                    </div>
                    <div class="form-actions">
                        <button class="btn btn-primary">${isEdit?'Lưu thay đổi':'Thêm người dùng'}</button>
                        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/user/list">Hủy</a>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>

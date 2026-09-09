<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký</title>
</head>
<body>
<div class="auth-page">
    <div class="auth-card">
        <h2>Tạo tài khoản mới</h2>
        <p class="auth-description">Điền thông tin bên dưới để đăng ký tài khoản</p>
        <c:if test="${alert != null}">
            <div class="alert alert-error">${alert}</div>
        </c:if>
        <form class="needs-validation" action="${pageContext.request.contextPath}/register" method="post" novalidate>
            <div class="form-group">
                <label for="username">Tài khoản</label>
                <input class="${not empty errors.userName?'is-invalid-server':''}" type="text" id="username" placeholder="Nhập tài khoản" name="username" value="${param.username}" minlength="3" maxlength="50" pattern="[A-Za-z0-9._]+" required>
                <c:if test="${not empty errors.userName}">
                    <span class="field-error">${errors.userName}</span>
                </c:if>
            </div>
            <div class="form-group">
                <label for="fullname">Họ tên</label>
                <input class="${not empty errors.fullName?'is-invalid-server':''}" type="text" id="fullname" placeholder="Nhập họ tên" name="fullname" value="${param.fullname}" minlength="2" maxlength="100" required>
                <c:if test="${not empty errors.fullName}">
                    <span class="field-error">${errors.fullName}</span>
                </c:if>
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input class="${not empty errors.email?'is-invalid-server':''}" type="email" id="email" placeholder="Nhập email" name="email" value="${param.email}" maxlength="100" required>
                <c:if test="${not empty errors.email}">
                    <span class="field-error">${errors.email}</span>
                </c:if>
            </div>
            <div class="form-group">
                <label for="phone">Số điện thoại</label>
                <input class="${not empty errors.phone?'is-invalid-server':''}" type="text" id="phone" placeholder="Nhập số điện thoại" name="phone" value="${param.phone}" minlength="9" maxlength="11" inputmode="numeric" pattern="[0-9]{9,11}" required>
                <c:if test="${not empty errors.phone}">
                    <span class="field-error">${errors.phone}</span>
                </c:if>
            </div>
            <div class="form-group">
                <label for="password">Mật khẩu</label>
                <input class="${not empty errors.passWord?'is-invalid-server':''}" type="password" id="password" placeholder="Nhập mật khẩu" name="password" minlength="6" maxlength="72" required>
                <c:if test="${not empty errors.passWord}">
                    <span class="field-error">${errors.passWord}</span>
                </c:if>
            </div>
            <div class="form-group">
                <label for="repassword">Nhập lại mật khẩu</label>
                <input class="${not empty errors.repassword?'is-invalid-server':''}" type="password" id="repassword" placeholder="Nhập lại mật khẩu" name="repassword" minlength="6" maxlength="72" required>
                <c:if test="${not empty errors.repassword}">
                    <span class="field-error">${errors.repassword}</span>
                </c:if>
            </div>
            <button type="submit" class="btn btn-primary btn-block">Tạo tài khoản</button>
        </form>
        <div class="auth-footer">
            Đã có tài khoản?
            <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
        </div>
    </div>
</div>
</body>
</html>
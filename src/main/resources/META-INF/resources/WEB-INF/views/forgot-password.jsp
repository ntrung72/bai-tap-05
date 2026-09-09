<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu</title>
</head>
<body>
<div class="auth-page">
    <div class="auth-card">
        <h2>Quên mật khẩu</h2>
        <p class="auth-description">Nhập email đã đăng ký để nhận mã OTP</p>
        <c:if test="${not empty alert}">
            <div class="alert alert-error">${alert}</div>
        </c:if>
        <form class="needs-validation" action="${pageContext.request.contextPath}/forgot-password" method="post" novalidate>
            <div class="form-group">
                <label for="email">Email</label>
                <input class="${not empty errors.email?'is-invalid-server':''}" type="email" id="email" name="email" value="${param.email}" placeholder="Nhập email đã đăng ký" maxlength="100" required>
                <c:if test="${not empty errors.email}">
                    <span class="field-error">${errors.email}</span>
                </c:if>
            </div>
            <button type="submit" class="btn btn-primary btn-block">Gửi mã OTP</button>
        </form>
        <div class="auth-footer">
            <a href="${pageContext.request.contextPath}/login">Quay lại đăng nhập</a>
        </div>
    </div>
</div>
</body>
</html>
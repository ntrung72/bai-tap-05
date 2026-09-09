<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập</title>
</head>
<body>
<div class="auth-page">
    <div class="auth-card">
        <h2>Đăng nhập</h2>
        <p class="auth-description">Chào mừng bạn quay trở lại</p>
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success">${sessionScope.success}</div>
            <c:remove var="success" scope="session"/>
        </c:if>
        <c:if test="${not empty alert}">
            <div class="alert alert-error">${alert}</div>
        </c:if>
        <form class="needs-validation" action="${pageContext.request.contextPath}/login" method="post" novalidate>
            <div class="form-group">
                <label for="username">Tên đăng nhập</label>
                <input class="${not empty errors.userName?'is-invalid-server':''}" type="text" id="username" name="username" value="${rememberedUsername}" placeholder="Nhập tên đăng nhập" minlength="3" maxlength="50" pattern="[A-Za-z0-9._]+" required>
                <c:if test="${not empty errors.userName}">
                    <span class="field-error">${errors.userName}</span>
                </c:if>
            </div>
            <div class="form-group">
                <label for="password">Mật khẩu</label>
                <input class="${not empty errors.passWord?'is-invalid-server':''}" type="password" id="password" name="password" placeholder="Nhập mật khẩu" minlength="6" maxlength="72" required>
                <c:if test="${not empty errors.passWord}">
                    <span class="field-error">${errors.passWord}</span>
                </c:if>
            </div>
            <div class="remember-row">
                <label class="remember-box">
                    <input type="checkbox" name="remember" ${rememberChecked?'checked':''}>
                    <span>Nhớ tôi</span>
                </label>
                <a href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu?</a>
            </div>
            <button type="submit" class="btn btn-primary btn-block">Đăng nhập</button>
        </form>
        <div class="auth-footer">
            Chưa có tài khoản?
            <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
        </div>
    </div>
</div>
</body>
</html>
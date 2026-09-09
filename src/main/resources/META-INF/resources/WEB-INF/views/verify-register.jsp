<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác thực đăng ký</title>
</head>
<body>
<div class="auth-page">
    <div class="auth-card">
        <h2>Xác thực tài khoản</h2>
        <p class="auth-description">Mã OTP đã được gửi đến ${email}. Mã có hiệu lực trong 5 phút.</p>
        <c:if test="${not empty alert}">
            <div class="alert alert-error">${alert}</div>
        </c:if>
        <form class="needs-validation" action="${pageContext.request.contextPath}/verify-register" method="post" novalidate>
            <div class="form-group">
                <label for="otp">Mã OTP</label>
                <input class="${not empty errors.otp?'is-invalid-server':''}" type="text" id="otp" name="otp" value="${param.otp}" placeholder="Nhập 6 chữ số OTP" minlength="6" maxlength="6" inputmode="numeric" pattern="[0-9]{6}" autocomplete="one-time-code" required>
                <c:if test="${not empty errors.otp}">
                    <span class="field-error">${errors.otp}</span>
                </c:if>
            </div>
            <button type="submit" class="btn btn-primary btn-block">Kích hoạt tài khoản</button>
        </form>
        <div class="auth-footer">
            <a href="${pageContext.request.contextPath}/register">Quay lại đăng ký</a>
        </div>
    </div>
</div>
</body>
</html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile của tôi</title>
    <style>
        .profile-edit-layout{
            display:grid;
            grid-template-columns:220px 1fr;
            gap:30px;
            align-items:start;
        }
        .profile-avatar-box{
            text-align:center;
        }
        .profile-avatar-image{
            width:150px;
            height:150px;
            object-fit:cover;
            border-radius:50%;
            border:4px solid #dbeafe;
            background:#f8fafc;
        }
        .profile-avatar-fallback{
            width:150px;
            height:150px;
            margin:0 auto;
            display:flex;
            align-items:center;
            justify-content:center;
            border-radius:50%;
            background:#dbeafe;
            color:#2563eb;
            font-size:52px;
            font-weight:700;
        }
        .readonly-input{
            background:#f3f4f6 !important;
            color:#6b7280;
            cursor:not-allowed;
        }
        @media(max-width:700px){
            .profile-edit-layout{
                grid-template-columns:1fr;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="page-header">
        <h1 class="fs-3 fw-bold mb-2">Profile</h1>
        <p>Cập nhật họ tên, số điện thoại và ảnh đại diện.</p>
    </div>
    <c:if test="${not empty alert}">
        <div class="alert alert-error">${alert}</div>
    </c:if>
    <c:if test="${not empty errors.form}">
        <div class="alert alert-error">${errors.form}</div>
    </c:if>
    <c:if test="${not empty sessionScope.profileSuccess}">
        <div class="alert alert-success">${sessionScope.profileSuccess}</div>
        <c:remove var="profileSuccess" scope="session"/>
    </c:if>
    <div class="card profile-card">
        <form class="needs-validation" action="${pageContext.request.contextPath}/member/myaccount" method="post" enctype="multipart/form-data" novalidate>
            <div class="profile-edit-layout">
                <div class="profile-avatar-box">
                    <c:choose>
                        <c:when test="${not empty sessionScope.account.avatar}">
                            <c:url value="/image" var="avatarUrl">
                                <c:param name="fname" value="${sessionScope.account.avatar}"/>
                            </c:url>
                            <img id="avatarPreview" class="profile-avatar-image" src="${avatarUrl}" alt="Avatar của ${sessionScope.account.fullName}">
                            <div id="avatarFallback" class="profile-avatar-fallback" style="display:none;">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.account.fullName}">
                                        ${sessionScope.account.fullName.substring(0,1)}
                                    </c:when>
                                    <c:otherwise>U</c:otherwise>
                                </c:choose>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <img id="avatarPreview" class="profile-avatar-image" src="" alt="Avatar preview" style="display:none;">
                            <div id="avatarFallback" class="profile-avatar-fallback">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.account.fullName}">
                                        ${sessionScope.account.fullName.substring(0,1)}
                                    </c:when>
                                    <c:otherwise>U</c:otherwise>
                                </c:choose>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div class="form-group" style="margin-top:20px;text-align:left;">
                        <label for="image">Ảnh đại diện mới</label>
                        <input class="${not empty errors.image?'is-invalid-server':''}" type="file" id="image" name="image" accept="image/png,image/jpeg,image/gif,image/webp">
                        <div class="form-help">Tối đa 5MB. Hỗ trợ JPG, JPEG, PNG, GIF, WEBP.</div>
                        <c:if test="${not empty errors.image}">
                            <span class="field-error">${errors.image}</span>
                        </c:if>
                    </div>
                </div>
                <div>
                    <div class="form-group">
                        <label for="username">Username</label>
                        <input class="readonly-input" type="text" id="username" value="${sessionScope.account.userName}" readonly>
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input class="readonly-input" type="email" id="email" value="${sessionScope.account.email}" readonly>
                    </div>
                    <div class="form-group">
                        <label for="fullname">Họ tên</label>
                        <input class="${not empty errors.fullName?'is-invalid-server':''}" type="text" id="fullname" name="fullname" value="${hasFormData?formFullname:sessionScope.account.fullName}" minlength="2" maxlength="100" required>
                        <c:if test="${not empty errors.fullName}">
                            <span class="field-error">${errors.fullName}</span>
                        </c:if>
                    </div>
                    <div class="form-group">
                        <label for="phone">Số điện thoại</label>
                        <input class="${not empty errors.phone?'is-invalid-server':''}" type="text" id="phone" name="phone" value="${hasFormData?formPhone:sessionScope.account.phone}" minlength="9" maxlength="11" inputmode="numeric" pattern="[0-9]{9,11}" required>
                        <c:if test="${not empty errors.phone}">
                            <span class="field-error">${errors.phone}</span>
                        </c:if>
                    </div>
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                        <a href="${pageContext.request.contextPath}/waiting" class="btn btn-secondary">← Quay lại trang chủ</a>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>
<script>
    const imageInput=document.getElementById("image");
    const avatarPreview=document.getElementById("avatarPreview");
    const avatarFallback=document.getElementById("avatarFallback");
    imageInput.addEventListener("change", function(){
        const file=this.files[0];
        if (!file){
            return;
        }
        if (!file.type.startsWith("image/")){
            alert("Vui lòng chọn file hình ảnh.");
            this.value="";
            return;
        }
        if (file.size>5*1024*1024){
            alert("Ảnh không được vượt quá 5MB.");
            this.value="";
            return;
        }
        const reader=new FileReader();
        reader.onload=function(e){
            avatarPreview.src=e.target.result;
            avatarPreview.style.display="block";
            avatarFallback.style.display="none";
        };
        reader.readAsDataURL(file);
    });
</script>
</body>
</html>
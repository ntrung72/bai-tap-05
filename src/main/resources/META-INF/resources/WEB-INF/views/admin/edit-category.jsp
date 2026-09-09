<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa danh mục</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
</head>
<body>
<div class="container">
    <div class="page-header">
        <h1 class="fs-3 fw-bold mb-0">Sửa danh mục</h1>
        <p>Cập nhật thông tin danh mục.</p>
    </div>
    <div class="card category-form-card">
        <form class="needs-validation" action="${pageContext.request.contextPath}/admin/category/edit" method="post" enctype="multipart/form-data" novalidate>
            <input type="hidden" name="id" value="${category.id}">
            <div class="form-group">
                <label for="name">Tên danh mục</label>
                <input class="${not empty errors.name?'is-invalid-server':''}" type="text" id="name" name="name" value="${hasFormData?formName:category.name}" minlength="2" maxlength="100" required>
                <c:if test="${not empty errors.name}">
                    <span class="field-error">${errors.name}</span>
                </c:if>
            </div>
            <c:if test="${not empty category.icon}">
                <c:url value="/image" var="imgUrl">
                    <c:param name="fname" value="${category.icon}"/>
                </c:url>
                <div class="form-group">
                    <label>Ảnh hiện tại</label>
                    <div class="current-image-box">
                        <img class="category-edit-image" src="${imgUrl}" alt="${category.name}">
                    </div>
                </div>
            </c:if>
            <div class="form-group">
                <label for="icon">Chọn ảnh mới</label>
                <input class="${not empty errors.icon?'is-invalid-server':''}" type="file" id="icon" name="icon" accept="image/png,image/jpeg,image/gif,image/webp">
                <p class="form-help">Nếu không chọn ảnh mới, hệ thống sẽ giữ nguyên ảnh hiện tại.</p>
                <p class="form-help">Tối đa 5 MB. Hỗ trợ JPG, JPEG, PNG, GIF, WEBP.</p>
                <c:if test="${not empty errors.icon}">
                    <span class="field-error">${errors.icon}</span>
                </c:if>
                <div id="newImagePreviewContainer" style="display:none;margin-top:12px;">
                    <label>Ảnh mới xem trước</label>
                    <div class="current-image-box">
                        <img id="newImagePreview" class="category-edit-image" src="" alt="Ảnh mới xem trước">
                    </div>
                </div>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                <a href="${pageContext.request.contextPath}/admin/category/list" class="btn btn-secondary">Hủy</a>
            </div>
        </form>
    </div>
</div>
<script>
document.getElementById("icon").addEventListener("change",function(){
    const file=this.files[0];
    const previewContainer=document.getElementById("newImagePreviewContainer");
    const preview=document.getElementById("newImagePreview");
    if (!file){
        previewContainer.style.display="none";
        preview.src="";
        return;
    }
    if (!file.type.startsWith("image/")){
        previewContainer.style.display="none";
        preview.src="";
        return;
    }
    const reader=new FileReader();
    reader.onload=function(e){
        preview.src=e.target.result;
        previewContainer.style.display="block";
    };
    reader.readAsDataURL(file);
});
</script>
</body>
</html>
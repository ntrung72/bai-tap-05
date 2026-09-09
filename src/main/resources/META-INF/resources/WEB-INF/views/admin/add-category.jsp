<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm danh mục</title>
</head>
<body>
<div class="container">
    <div class="page-header">
        <h1 class="fs-3 fw-bold mb-0">Thêm danh mục</h1>
        <p>Tạo một danh mục mới trong hệ thống.</p>
    </div>
    <div class="card category-form-card">
        <form class="needs-validation" action="${pageContext.request.contextPath}/admin/category/add" method="post" enctype="multipart/form-data" novalidate>
            <div class="form-group">
                <label for="name">Tên danh mục</label>
                <input class="${not empty errors.name?'is-invalid-server':''}" type="text" id="name" name="name" value="${formName}" placeholder="Nhập tên danh mục" minlength="2" maxlength="100" required>
                <c:if test="${not empty errors.name}">
                    <span class="field-error">${errors.name}</span>
                </c:if>
            </div>
            <div class="form-group">
                <label for="icon">Ảnh đại diện</label>
                <input class="${not empty errors.icon?'is-invalid-server':''}" type="file" id="icon" name="icon" accept="image/png,image/jpeg,image/gif,image/webp">
                <div class="form-help">Tối đa 5 MB. Hỗ trợ JPG, JPEG, PNG, GIF, WEBP.</div>
                <c:if test="${not empty errors.icon}">
                    <span class="field-error">${errors.icon}</span>
                </c:if>
                <div id="imagePreviewContainer" style="display:none;margin-top:12px;">
                    <label>Xem trước ảnh</label>
                    <div class="current-image-box">
                        <img id="imagePreview" class="category-edit-image" src="" alt="Xem trước ảnh">
                    </div>
                </div>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Thêm danh mục</button>
                <a href="${pageContext.request.contextPath}/admin/category/list" class="btn btn-secondary">Hủy</a>
            </div>
        </form>
    </div>
</div>
<script>
document.getElementById("icon").addEventListener("change",function(){
    const file=this.files[0];
    const previewContainer=document.getElementById("imagePreviewContainer");
    const preview=document.getElementById("imagePreview");
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
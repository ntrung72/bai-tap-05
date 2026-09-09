<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm sản phẩm</title>
</head>
<body>
<div class="container">
    <div class="page-header">
        <h1 class="fs-3 fw-bold mb-0">Thêm sản phẩm</h1>
        <p>Tạo một sản phẩm mới trong hệ thống.</p>
    </div>
    <div class="card category-form-card">
        <form class="needs-validation" action="${pageContext.request.contextPath}/admin/product/add" method="post" enctype="multipart/form-data" novalidate>
            <div class="form-group">
                <label for="name">Tên sản phẩm</label>
                <input class="${not empty errors.name?'is-invalid-server':''}" type="text" id="name" name="name" value="${formName}" placeholder="Nhập tên sản phẩm" minlength="2" maxlength="255" required>
                <c:if test="${not empty errors.name}">
                    <span class="field-error">${errors.name}</span>
                </c:if>
            </div>
            <div class="form-group">
                <label for="price">Giá</label>
                <input class="${not empty errors.price?'is-invalid-server':''}" type="text" id="price" name="price" value="${formPrice}" inputmode="numeric" autocomplete="off" placeholder="Nhập giá sản phẩm" required>
                <c:if test="${not empty errors.price}">
                    <span class="field-error">${errors.price}</span>
                </c:if>
            </div>
            <div class="form-group">
                <label for="quantity">Số lượng</label>
                <input class="${not empty errors.quantity?'is-invalid-server':''}" type="number" id="quantity" name="quantity" value="${formQuantity}" min="0" step="1" placeholder="Nhập số lượng sản phẩm" required>
                <c:if test="${not empty errors.quantity}">
                    <span class="field-error">${errors.quantity}</span>
                </c:if>
            </div>
            <div class="form-group">
                <label for="categoryId">Danh mục</label>
                <select class="${not empty errors.category?'is-invalid-server':''}" id="categoryId" name="categoryId" required>
                    <option value="">-- Chọn danh mục --</option>
                    <c:forEach items="${cateList}" var="cate">
                        <option value="${cate.id}" ${formCategoryId==cate.id?'selected':''}>${cate.name}</option>
                    </c:forEach>
                </select>
                <c:if test="${not empty errors.category}">
                    <span class="field-error">${errors.category}</span>
                </c:if>
            </div>
            <div class="form-group">
                <label for="image">Hình ảnh</label>
                <input class="${not empty errors.image?'is-invalid-server':''}" type="file" id="image" name="image" accept="image/png,image/jpeg,image/gif,image/webp">
                <div class="form-help">Tối đa 10 MB. Hỗ trợ JPG, JPEG, PNG, GIF, WEBP.</div>
                <c:if test="${not empty errors.image}">
                    <span class="field-error">${errors.image}</span>
                </c:if>
                <div id="imagePreviewContainer" style="display:none;margin-top:12px;">
                    <label>Xem trước ảnh</label>
                    <div class="current-image-box">
                        <img id="imagePreview" class="category-edit-image" src="" alt="Xem trước ảnh">
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label for="description">Mô tả</label>
                <textarea class="${not empty errors.description?'is-invalid-server':''}" id="description" name="description" rows="5" maxlength="2000" placeholder="Nhập mô tả sản phẩm">${formDescription}</textarea>
                <c:if test="${not empty errors.description}">
                    <span class="field-error">${errors.description}</span>
                </c:if>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Thêm sản phẩm</button>
                <a href="${pageContext.request.contextPath}/admin/product/list" class="btn btn-secondary">Hủy</a>
            </div>
        </form>
    </div>
</div>
<script>
document.getElementById("image").addEventListener("change",function(){
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
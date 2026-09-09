<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa sản phẩm</title>
</head>
<body>
<div class="container">
    <div class="page-header">
        <h1 class="fs-3 fw-bold mb-0">Sửa sản phẩm</h1>
        <p>Cập nhật thông tin sản phẩm.</p>
    </div>
    <div class="card category-form-card">
        <form class="needs-validation" action="${pageContext.request.contextPath}/admin/product/edit" method="post" enctype="multipart/form-data" novalidate>
            <input type="hidden" name="id" value="${product.id}">
            <div class="form-group">
                <label for="name">Tên sản phẩm</label>
                <input class="${not empty errors.name?'is-invalid-server':''}" type="text" id="name" name="name" value="${hasFormData?formName:product.name}" minlength="2" maxlength="255" required>
                <c:if test="${not empty errors.name}">
                    <span class="field-error">${errors.name}</span>
                </c:if>
            </div>
            <div class="form-group">
                <label for="price">Giá</label>
                <c:choose>
                    <c:when test="${hasFormData}">
                        <input class="${not empty errors.price?'is-invalid-server':''}" type="text" id="price" name="price" value="${formPrice}" inputmode="numeric" autocomplete="off" required>
                    </c:when>
                    <c:otherwise>
                        <fmt:setLocale value="vi_VN"/>
                        <input class="${not empty errors.price?'is-invalid-server':''}" type="text" id="price" name="price" value="<fmt:formatNumber value='${product.price}' type='number' groupingUsed='true' maxFractionDigits='0'/>" inputmode="numeric" autocomplete="off" required>
                    </c:otherwise>
                </c:choose>
                <c:if test="${not empty errors.price}">
                    <span class="field-error">${errors.price}</span>
                </c:if>
            </div>
            <div class="form-group">
                <label for="quantity">Số lượng</label>
                <input class="${not empty errors.quantity?'is-invalid-server':''}" type="number" id="quantity" name="quantity" value="${hasFormData?formQuantity:product.quantity}" min="0" step="1" required>
                <c:if test="${not empty errors.quantity}">
                    <span class="field-error">${errors.quantity}</span>
                </c:if>
            </div>
            <div class="form-group">
                <label for="categoryId">Danh mục</label>
                <select class="${not empty errors.category?'is-invalid-server':''}" id="categoryId" name="categoryId" required>
                    <c:forEach items="${cateList}" var="cate">
                        <option value="${cate.id}" ${(hasFormData?formCategoryId:product.category.id)==cate.id?'selected':''}>${cate.name}</option>
                    </c:forEach>
                </select>
                <c:if test="${not empty errors.category}">
                    <span class="field-error">${errors.category}</span>
                </c:if>
            </div>
            <c:if test="${not empty product.image}">
                <c:url value="/image" var="imgUrl">
                    <c:param name="fname" value="${product.image}"/>
                </c:url>
                <div class="form-group" id="currentImageContainer">
                    <label>Ảnh hiện tại</label>
                    <div class="current-image-box">
                        <img class="category-edit-image" src="${imgUrl}" alt="${product.name}">
                    </div>
                </div>
            </c:if>
            <div class="form-group">
                <label for="image">Chọn ảnh mới</label>
                <input class="${not empty errors.image?'is-invalid-server':''}" type="file" id="image" name="image" accept="image/png,image/jpeg,image/gif,image/webp">
                <p class="form-help">Nếu không chọn ảnh mới, hệ thống sẽ giữ nguyên ảnh hiện tại.</p>
                <p class="form-help">Tối đa 10 MB. Hỗ trợ JPG, JPEG, GIF, WEBP.</p>
                <c:if test="${not empty errors.image}">
                    <span class="field-error">${errors.image}</span>
                </c:if>
                <div id="newImagePreviewContainer" style="display:none;margin-top:12px;">
                    <label>Ảnh mới xem trước</label>
                    <div class="current-image-box">
                        <img id="newImagePreview" class="category-edit-image" src="" alt="Ảnh mới xem trước">
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label for="description">Mô tả</label>
                <textarea class="${not empty errors.description?'is-invalid-server':''}" id="description" name="description" rows="5" maxlength="2000">${hasFormData?formDescription:product.description}</textarea>
                <c:if test="${not empty errors.description}">
                    <span class="field-error">${errors.description}</span>
                </c:if>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                <a href="${pageContext.request.contextPath}/admin/product/list" class="btn btn-secondary">Hủy</a>
            </div>
        </form>
    </div>
</div>
<script>
document.getElementById("image").addEventListener("change",function(){
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
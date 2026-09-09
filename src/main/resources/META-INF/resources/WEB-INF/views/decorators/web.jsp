<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property="title" default="Shop"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/validation.css">
    <sitemesh:write property="head"/>
</head>
<body class="d-flex flex-column min-vh-100">
    <%@ include file="/WEB-INF/views/common/header.jsp"%>
    <div class="flex-grow-1">
        <sitemesh:write property="body"/>
    </div>
    <%@ include file="/WEB-INF/views/common/footer.jsp"%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        (() =>{
            "use strict";
            const patternMessages={
                username:"Tên đăng nhập chỉ gồm chữ cái, số, dấu chấm và dấu gạch dưới.",
                phone:"Số điện thoại phải gồm 9 đến 11 chữ số.",
                otp:"Mã OTP phải gồm đúng 6 chữ số."
            };
            const getLabel=field =>{
                if (!field.id){
                    return "Trường này";
                }
                const label=document.querySelector("label[for='"+field.id+"']");
                return label?label.textContent.trim():"Trường này";
            };
            const getMessage=field =>{
                const label=getLabel(field);
                if (field.validity.valueMissing){
                    return label+" không được để trống.";
                }
                if (field.validity.typeMismatch){
                    return label+" không đúng định dạng.";
                }
                if (field.validity.tooShort){
                    return label+" phải có ít nhất "+field.minLength+" ký tự.";
                }
                if (field.validity.tooLong){
                    return label+" không được vượt quá "+field.maxLength+" ký tự.";
                }
                if (field.validity.patternMismatch){
                    return patternMessages[field.name] || label+" không đúng định dạng.";
                }
                if (field.validity.rangeUnderflow){
                    return label+" không được nhỏ hơn "+field.min+".";
                }
                if (field.validity.rangeOverflow){
                    return label+" không được lớn hơn "+field.max+".";
                }
                if (field.validity.badInput){
                    return label+" phải là một giá trị hợp lệ.";
                }
                if (field.validity.stepMismatch){
                    return label+" không đúng bước giá trị cho phép.";
                }
                if (field.validity.customError){
                    return field.validationMessage;
                }
                return label+" không hợp lệ.";
            };
            const removeClientError=field =>{
                field.classList.remove("is-invalid-client");
                const formGroup=field.closest(".form-group");
                const oldError=formGroup?formGroup.querySelector(".client-field-error"):null;
                if (oldError){
                    oldError.remove();
                }
            };
            const showClientError=field =>{
                removeClientError(field);
                if (field.validity.valid){
                    return;
                }
                field.classList.add("is-invalid-client");
                const error=document.createElement("span");
                error.className="field-error client-field-error";
                error.textContent=getMessage(field);
                const formGroup=field.closest(".form-group");
                if (formGroup){
                    formGroup.appendChild(error);
                }else{
                    field.insertAdjacentElement("afterend", error);
                }
            };
            const updateCustomValidity=form =>{
                form.querySelectorAll("input[required][type='text'],input[required][type='email'],textarea[required]").forEach(field =>{
                    if (field.value.length>0 && field.value.trim().length===0){
                        field.setCustomValidity(getLabel(field)+" không được chỉ chứa khoảng trắng.");
                    }else{
                        field.setCustomValidity("");
                    }
                });
                const password=form.querySelector("[name='password']");
                const repassword=form.querySelector("[name='repassword']");
                if (password && repassword){
                    if (repassword.value && password.value!==repassword.value){
                        repassword.setCustomValidity("Mật khẩu nhập lại không khớp với mật khẩu.");
                    }else{
                        repassword.setCustomValidity("");
                    }
                }
            };
            document.querySelectorAll(".needs-validation").forEach(form =>{
                const fields=form.querySelectorAll("input,select,textarea");
                fields.forEach(field =>{
                    const eventName=field.type==="file" || field.tagName==="SELECT"?"change":"input";
                    field.addEventListener(eventName, () =>{
                        updateCustomValidity(form);
                        removeClientError(field);
                        if (form.classList.contains("was-validated") && !field.checkValidity()){
                            showClientError(field);
                        }
                    });
                });
                form.addEventListener("submit", event =>{
                    updateCustomValidity(form);
                    if (!form.checkValidity()){
                        event.preventDefault();
                        event.stopPropagation();
                        let firstInvalid=null;
                        fields.forEach(field =>{
                            if (!field.checkValidity()){
                                showClientError(field);
                                if (!firstInvalid){
                                    firstInvalid=field;
                                }
                            }else{
                                removeClientError(field);
                            }
                        });
                        if (firstInvalid){
                            firstInvalid.focus();
                        }
                    }
                    form.classList.add("was-validated");
                });
            });
        })();
    </script>
</body>
</html>

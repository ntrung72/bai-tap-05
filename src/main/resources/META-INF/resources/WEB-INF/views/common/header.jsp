<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<nav class="navbar navbar-expand-lg bg-white border-bottom shadow-sm sticky-top"
     data-bs-theme="light">

    <div class="container-fluid px-3 px-lg-5">

        <a class="navbar-brand fw-bold text-primary"
           href="${pageContext.request.contextPath}/home">
            ShopNamTrung
        </a>

        <button class="navbar-toggler"
                type="button"
                data-bs-toggle="collapse"
                data-bs-target="#mainNavbar"
                aria-controls="mainNavbar"
                aria-expanded="false"
                aria-label="Mở menu">

            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="mainNavbar">

            <ul class="navbar-nav me-auto mb-2 mb-lg-0">

                <c:if test="${sessionScope.account != null}">
                    <li class="nav-item">
                        <a class="nav-link"
                           href="${pageContext.request.contextPath}/product">
                            Sản phẩm
                        </a>
                    </li>
                </c:if>

                <c:if test="${sessionScope.account != null
                              && sessionScope.account.roleid == 1}">

                    <li class="nav-item dropdown">

                        <a class="nav-link dropdown-toggle"
                           href="#"
                           role="button"
                           data-bs-toggle="dropdown"
                           aria-expanded="false">
                            Quản trị
                        </a>

                        <ul class="dropdown-menu">

                            <li>
                                <a class="dropdown-item"
                                   href="${pageContext.request.contextPath}/admin/category/list">
                                    Danh mục
                                </a>
                            </li>

                            <li>
                                <a class="dropdown-item"
                                   href="${pageContext.request.contextPath}/admin/product/list">
                                    Sản phẩm
                                </a>
                            </li>

                            <li>
                                <a class="dropdown-item"
                                   href="${pageContext.request.contextPath}/admin/user/list">
                                    Người dùng
                                </a>
                            </li>

                        </ul>
                    </li>
                </c:if>

            </ul>

            <div class="d-flex flex-column flex-lg-row
                        align-items-lg-center gap-2 gap-lg-3">

                <c:choose>

                    <c:when test="${sessionScope.account == null}">

                        <a class="btn btn-outline-primary"
                           href="${pageContext.request.contextPath}/login">
                            Đăng nhập
                        </a>

                        <a class="btn btn-primary"
                           href="${pageContext.request.contextPath}/register">
                            Đăng ký
                        </a>

                    </c:when>

                    <c:otherwise>

                        <span class="navbar-text">
                            Xin chào,
                            <strong>${sessionScope.account.fullName}</strong>
                        </span>

                        <a class="navbar-avatar-link"
                           href="${pageContext.request.contextPath}/member/myaccount"
                           title="Thông tin cá nhân"
                           aria-label="Mở thông tin cá nhân">

                            <c:choose>

                                <c:when test="${not empty sessionScope.account.avatar}">

                                    <c:url value="/image" var="navbarAvatarUrl">
                                        <c:param name="fname"
                                                 value="${sessionScope.account.avatar}"/>
                                    </c:url>

                                    <img class="navbar-avatar-image"
                                         src="${navbarAvatarUrl}"
                                         alt="Avatar của ${sessionScope.account.fullName}">

                                </c:when>

                                <c:otherwise>

                                    <span class="navbar-avatar-fallback">

                                        <c:choose>

                                            <c:when test="${not empty sessionScope.account.fullName}">
                                                ${sessionScope.account.fullName.substring(0,1)}
                                            </c:when>

                                            <c:otherwise>
                                                U
                                            </c:otherwise>

                                        </c:choose>

                                    </span>

                                </c:otherwise>

                            </c:choose>

                        </a>

                        <a class="btn btn-danger"
                           href="${pageContext.request.contextPath}/logout">
                            Đăng xuất
                        </a>

                    </c:otherwise>

                </c:choose>

            </div>
        </div>
    </div>
</nav>
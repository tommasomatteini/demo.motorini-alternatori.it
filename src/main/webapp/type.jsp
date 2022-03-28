<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/commons.jspf" %>
<%@ include file="/WEB-INF/sql.jspf" %>
<%@ include file="/WEB-INF/routes.jspf" %>
<%@ taglib prefix="ex" uri="/WEB-INF/tags/custom.tld"%>

<layout:extends name="base" >
    <layout:put block="head" type="REPLACE">
        <meta name="description" content="{{description}}">
        <meta name="keywords" content="{{keywords}}">
        <title>Motorini Alternatori</title>
    </layout:put>
    <layout:put block="contents">

        <div class="container-fluid anno-fabbricazione">
            <div class="row">

                <%@ include file="WEB-INF/partials/aside.jspf" %>

                <main class="col-lg-9 mb-4" role="main">

                </main>

            </div>
        </div>

    </layout:put>
</layout:extends>
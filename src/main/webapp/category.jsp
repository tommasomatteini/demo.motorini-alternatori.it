<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/core/commons.jspf" %>
<%@ include file="/WEB-INF/core/sql.jspf" %>
<%@ include file="/WEB-INF/core/routes.jspf" %>

<%@ taglib prefix="utils" uri="/WEB-INF/tlds/utils.tld" %>

<c:if test="${not empty param.id_categoria}">
    <cache:results lang="${lang}" name="resultcategories__${param.id_categoria}" var="resultcategories" />
    <c:if test="${empty resultcategories}">
        <sql:query var="resultcategories">
            SELECT
                categorie.id AS id,
                IF(categorie_synonyms.description IS NULL, categorie.name, categorie_synonyms.description) AS name
            FROM
                tecdoc.categorie
            INNER JOIN motorinialternatori_main.categorie_visibility ON ( categorie.id = categorie_visibility.id_categoria AND categorie_visibility.visible = 1 )
            LEFT JOIN motorinialternatori_main.categorie_synonyms ON categorie_synonyms.id_categoria = categorie.id
            WHERE
                categorie.id = ?
            <sql:param value="${param.id_categoria}" />
        </sql:query>
        <cache:results lang="${lang}" name="resultcategories__${param.id_categoria}" value="${resultcategories}" />
    </c:if>
</c:if>
<c:forEach var="row" items="${resultcategories.rowsByIndex}">
    <c:set value="${row[0]}" var="id" />
    <c:set value="${row[1]}" var="name" />
</c:forEach>

<utils:hashMap var="breadcrumbList">
    <utils:hashMapItem key="${name}" value="category.jsp?id_categoria=${id}" />
</utils:hashMap>

<layout:extends name="base">
    <layout:put block="head" type="REPLACE">
        <meta name="description" content="{{description}}">
        <meta name="keywords" content="{{keywords}}">
        <title>Motorini Alternatori</title>
    </layout:put>
    <layout:put block="contents">
        <div class="container-fluid anno-fabbricazione">
            <div class="row">

                <%@ include file="/WEB-INF/partials/aside.jspf" %>

                <main class="col-lg-9 mb-4" role="main">

                    <h1>${name}</h1>
                    <p></p>


                </main>

            </div> <!-- .row -->
        </div> <!-- .container-fluid -->
    </layout:put>
</layout:extends>
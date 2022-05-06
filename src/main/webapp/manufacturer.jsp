<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/core/commons.jspf" %>
<%@ include file="/WEB-INF/core/sql.jspf" %>
<%@ include file="/WEB-INF/core/routes.jspf" %>

<%@ taglib prefix="utils" uri="/WEB-INF/tlds/utils.tld" %>

<c:if test="${not empty param.id_marca}">
    <cache:results lang="${lang}" name="manufacturer_${param.id_marca}" var="manufacturers" />
    <c:if test="${empty manufacturers}">
        <sql:query var="manufacturers">
            SELECT
                veicoli_marche.id AS id_marca,
                veicoli_marche.description AS marca_description,
                veicoli_marche_description.description AS marca_description_full
            FROM
                tecdoc.veicoli_marche
            LEFT JOIN motorinialternatori_main.veicoli_marche_description ON veicoli_marche.id = veicoli_marche_description.id_marca
            WHERE
                veicoli_marche.id = ?
            LIMIT 1
            <sql:param value="${param.id_marca}" />
        </sql:query>
        <cache:results lang="${lang}" name="manufacturer_${param.id_marca}" value="${manufacturers}" />
    </c:if>
</c:if>
<c:forEach var="rowman" items="${manufacturers.rowsByIndex}" varStatus="status">
    <c:set var="id" value="${rowman[0]}" />
    <c:set var="name" value="${rowman[1]}" />
    <c:set var="description" value="${rowman[2]}" />
</c:forEach>

<utils:hashMap var="breadcrumbList">
    <utils:hashMapItem key="Marche auto" value="manufacturers.jsp" />
    <utils:hashMapItem key="${name}" value="manufacturer.jsp?id_marca=${id}" />
</utils:hashMap>

<layout:extends name="base" >
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
                    <h1 class="main-header">${name}</h1>
                    <div class="row header">
                        <div class="col-md-9 header-text">
                            <p>${description}</p>
                        </div>

                        <c:if test="${not empty id}">
                            <cache:results lang="${lang}" name="manufacturerlogos_${id}" var="manufacturerlogos" />
                            <c:if test="${empty manufacturerlogos}">
                                <sql:query var="manufacturerlogos">
                                    SELECT
                                        veicoli_marche_media.filename AS filename,
                                        veicoli_marche_media.ext AS ext
                                    FROM
                                        motorinialternatori_main.veicoli_marche_media
                                    WHERE
                                        veicoli_marche_media.id_marca = ?
                                    <sql:param value="${id}" />
                                </sql:query>
                                <cache:results lang="${lang}" name="manufacturerlogos_${id}" value="${manufacturerlogos}" />
                            </c:if>
                        </c:if>
                        <c:forEach var="rowimg" items="${manufacturerlogos.rowsByIndex}">
                            <c:set var="image" value="${rowimg[0]}.${rowimg[1]}" />
                        </c:forEach>

                        <div class="col-md-3 header-image-container">
                            <img src="${commons.storage("images/brands/", image)}" alt="${name}" class="header-img">
                        </div>

                    </div> <!-- .header -->

                    <div class="color-choice">
                        <h2 class="secondary-header">Scegli il tuo modello</h2>
                        <div class="">

                            <c:if test="${not empty id}">
                                <cache:results lang="${lang}" name="manufacturer_${id}_models" var="models" />
                                <c:if test="${empty models}">
                                    <sql:query var="models">
                                        SELECT
                                            veicoli_marche.id AS id_marca,
                                            veicoli_modelli.id AS id_modello,
                                            veicoli_marche.description AS marca_description,
                                            veicoli_modelli.description AS modello_description,
                                            '' AS _from,
                                            '' AS _to,
                                            veicoli_serie.name
                                        FROM
                                            tecdoc.veicoli_marche
                                        JOIN tecdoc.veicoli_modelli ON veicoli_marche.id = veicoli_modelli.id_marca
                                        JOIN tecdoc.veicoli_serie ON veicoli_modelli.id = veicoli_serie.id_modello
                                        WHERE
                                            veicoli_marche.id = ?
                                        ORDER BY
                                            veicoli_serie.name
                                        <sql:param value="${id}" />
                                    </sql:query>
                                    <cache:results lang="${lang}" name="manufacturer_${id}_models" value="${models}" />
                                </c:if>
                            </c:if>

                            <c:set var="modello_corrente" value="" />
                            <c:forEach var="rowmod" items="${models.rowsByIndex}" varStatus="status">
                                <c:if test="${ !status.first && modello_corrente != rowmod[6]}">
                                    </div>
                                </c:if>
                                <c:if test="${ status.first || modello_corrente != rowmod[6] }">
                                    <h2 class="mb-0 mt-4 terthiary-header">${rowmod[6]}</h2>
                                    <div class="row color-choice-list">
                                </c:if>
                                <div class="col-md-6 color-choice-item">
                                    <a href="model.jsp?id_marca=${rowmod[0]}&id_modello=${rowmod[1]}">
                                        <h6 class="color-choice-name">${rowmod[2]} ${rowmod[3]}</h6>
                                        <div class="color-choice-info">

                                            <cache:results lang="${lang}" name="modelimages__${rowmod[0]}_${rowmod[1]}" var="modelimages" />
                                            <c:if test="${empty modelimages}">
                                                <sql:query var="modelimages">
                                                    SELECT
                                                        veicoli_modelli_media.filename AS filename,
                                                        veicoli_modelli_media.ext AS ext
                                                    FROM
                                                        motorinialternatori_main.veicoli_modelli_media
                                                    WHERE
                                                        veicoli_modelli_media.id_modello = ?
                                                    <sql:param value="${rowmod[1]}" />
                                                </sql:query>
                                                <cache:results lang="${lang}" name="modelimages__${rowmod[0]}_${rowmod[1]}" value="${modelimages}" />
                                            </c:if>
                                            <c:forEach var="rowimg" items="${modelimages.rowsByIndex}">
                                                <c:set var="image" value="${rowimg[0]}.${rowimg[1]}" />
                                            </c:forEach>
                                            <c:set var="modelimages" value="" /><%-- svuoto la variabile per il loop --%>

                                            <img alt="${rowmod[2]} ${rowmod[3]}" class="img-responsive" src="${commons.storage("images/models/", image)}" />
                                            <div class="color-choice-description">
                                                <p>Modello: ${rowmod[3]}</p>
                                                <p>Anno: </p>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                                <c:if test="${ status.last }">
                                    </div>
                                </c:if>
                                <c:set var="modello_corrente" value="${rowmod[6]}" />
                            </c:forEach>

                        </div> <!-- .color-choiche -->
                    </div>

                </main>

            </div> <!-- .row -->
        </div> <!-- .container-fluid -->
    </layout:put>
</layout:extends>
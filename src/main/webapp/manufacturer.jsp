<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ include file="/WEB-INF/core/commons.jspf" %>
<%@ include file="/WEB-INF/core/sql.jspf" %>
<%@ include file="/WEB-INF/core/routes.jspf" %>

<%@ taglib prefix="utils" uri="/WEB-INF/tlds/utils.tld" %>

<c:if test="${not empty param.id_marca}">
    <sql:query var="manufacturers">
        SELECT
            veicoli_marche.id AS id_marca,
            veicoli_marche.description AS marca_description,
            veicoli_marche_description.description AS marca_description_full
        FROM
            tecdoc.veicoli_marche
        LEFT JOIN motorinialternatori.veicoli_marche_description ON veicoli_marche.id = veicoli_marche_description.id_marca
        WHERE
            veicoli_marche.id = ?
        LIMIT 1
        <sql:param value="${param.id_marca}" />
    </sql:query>
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

                        <c:if test="${empty manufacturerlogos}">
                            <sql:query var="manufacturerlogos">
                                SELECT
                                    veicoli_marche_media.filename AS filename,
                                    veicoli_marche_media.ext AS ext
                                FROM
                                    motorinialternatori.veicoli_marche_media
                                WHERE
                                    veicoli_marche_media.id_marca = ?
                                <sql:param value="${id}" />
                            </sql:query>
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
                                <sql:query var="models">
                                    SELECT
                                        veicoli_marche.id AS id_marca,
                                        veicoli_modelli.id AS id_modello,
                                        veicoli_marche.description AS marca_description,
                                        veicoli_modelli.description AS modello_description,
                                        IF(veicoli_modelli._from = '0000-00-00', NULL, DATE_FORMAT(veicoli_modelli._from, '%m-%Y')) AS _from,
                                        IF(veicoli_modelli._to = '0000-00-00', NULL, DATE_FORMAT(veicoli_modelli._to, '%m-%Y')) AS _to,
                                        IF(veicoli_serie_synonyms.name IS NULL, veicoli_serie.name, veicoli_serie_synonyms.name)
                                    FROM
                                        tecdoc.veicoli_marche
                                    JOIN tecdoc.veicoli_modelli ON veicoli_marche.id = veicoli_modelli.id_marca
                                    JOIN tecdoc.veicoli_serie ON veicoli_modelli.id = veicoli_serie.id_modello
                                    INNER JOIN ( SELECT veicoli_tipi.id AS id, veicoli_tipi.id_modello AS id_modello FROM tecdoc.veicoli_tipi GROUP BY id_modello ) AS veicoli_tipi ON veicoli_modelli.id = veicoli_tipi.id_modello
                                    LEFT JOIN motorinialternatori.veicoli_serie_synonyms ON veicoli_modelli.id = veicoli_serie_synonyms.id_modello
                                    WHERE EXISTS( SELECT article_id FROM kuhner.articles_vehicles INNER JOIN tecdoc.articoli_categorie ON articoli_categorie.id_articolo = articles_vehicles.article_id INNER JOIN motorinialternatori.categorie_visibility ON ( articoli_categorie.id_categoria = categorie_visibility.id_categoria AND categorie_visibility.visible = 1 ) WHERE veicoli_tipi.id = articles_vehicles.link_target_id )
                                    AND
                                        veicoli_marche.id = ?
                                    ORDER BY
                                        veicoli_serie.name
                                    <sql:param value="${id}" />
                                </sql:query>
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

                                            <sql:query var="modelimages">
                                                SELECT
                                                    veicoli_modelli_media.filename AS filename,
                                                    veicoli_modelli_media.ext AS ext
                                                FROM
                                                    motorinialternatori.veicoli_modelli_media
                                                WHERE
                                                    veicoli_modelli_media.id_modello = ?
                                                <sql:param value="${rowmod[1]}" />
                                            </sql:query>
                                            <c:forEach var="rowimg" items="${modelimages.rowsByIndex}">
                                                <c:set var="image" value="${rowimg[0]}.${rowimg[1]}" />
                                            </c:forEach>
                                            <c:set var="modelimages" value="" /><%-- svuoto la variabile per il loop --%>

                                            <img alt="${rowmod[2]} ${rowmod[3]}" class="img-responsive" src="${commons.storage("images/models/", image)}" />
                                            <div class="color-choice-description">
                                                <p>Modello: ${rowmod[3]}</p>
                                                <c:if test="${ not empty rowmod[4] or not empty rowmod[5] }">
                                                    <p>Anno:&nbsp;<c:if test="${ not empty rowmod[4] }">dal ${rowmod[4]}</c:if>&nbsp;<c:if test="${ not empty rowmod[5] }">al ${rowmod[5]}</c:if></p>
                                                </c:if>
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
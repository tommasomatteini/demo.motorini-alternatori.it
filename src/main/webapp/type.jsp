<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ include file="/WEB-INF/core/commons.jspf" %>
<%@ include file="/WEB-INF/core/sql.jspf" %>
<%@ include file="/WEB-INF/core/routes.jspf" %>

<%@ taglib prefix="utils" uri="/WEB-INF/tlds/utils.tld" %>

<c:if test="${not empty param.id_marca and not empty param.id_modello and not empty param.id_tipo}">
    <sql:query var="types">
        SELECT
            veicoli_marche.id AS id_marca,
            veicoli_marche.description AS marca_description,
            veicoli_modelli.id AS id_modello,
            veicoli_modelli.description AS modello_description,
            veicoli_tipi.id AS id_tipo,
            veicoli_tipi.description AS tipo_description,
            IF(veicoli_tipi._from = '0000-00-00', NULL, DATE_FORMAT(veicoli_tipi._from, '%m-%Y')) AS _from,
            IF(veicoli_tipi._to = '0000-00-00', NULL, DATE_FORMAT(veicoli_tipi._to, '%m-%Y')) AS _to,
            CAST(veicoli_tipi.engine_hp AS UNSIGNED) AS hp,
            CAST(veicoli_tipi.engine_kw AS UNSIGNED) AS kw,
            veicoli_tipi.fuel_type AS fuel_type
        FROM
            tecdoc.veicoli_tipi
        JOIN tecdoc.veicoli_modelli ON veicoli_modelli.id = veicoli_tipi.id_modello
        JOIN tecdoc.veicoli_marche ON veicoli_modelli.id_marca = veicoli_marche.id
        WHERE
            veicoli_marche.id = ? AND veicoli_modelli.id = ? AND veicoli_tipi.id = ?
        LIMIT 1
        <sql:param value="${param.id_marca}" />
        <sql:param value="${param.id_modello}" />
        <sql:param value="${param.id_tipo}" />
    </sql:query>
</c:if>
<c:forEach var="rowtyp" items="${types.rowsByIndex}">
    <c:set var="id_marca" value="${rowtyp[0]}" />
    <c:set var="name_marca" value="${rowtyp[1]}" />
    <c:set var="id_modello" value="${rowtyp[2]}" />
    <c:set var="name_modello" value="${rowtyp[3]}" />
    <c:set var="id" value="${rowtyp[4]}" />
    <c:set var="name" value="${rowtyp[5]}" />
    <c:set var="name_full" value="${name_marca} ${name_modello} ${name}" />
    <c:set var="hp" value="${rowtyp[8]}" />
    <c:set var="kw" value="${rowtyp[9]}" />
    <c:set var="fuel_type" value="${rowtyp[10]}" />
    <c:set var="interval">
        <c:if test="${ not empty rowtyp[6] or not empty rowtyp[7] }">
            <c:if test="${ not empty rowtyp[6] }">dal ${rowtyp[6]}</c:if>&nbsp;<c:if test="${ not empty rowtyp[7] }">al ${rowtyp[7]}</c:if>
        </c:if>
    </c:set>
</c:forEach>

<utils:hashMap var="breadcrumbList">
    <utils:hashMapItem key="Marche auto" value="manufacturers.jsp" />
    <utils:hashMapItem key="${name_marca}" value="manufacturer.jsp?id_marca=${id_marca}" />
    <utils:hashMapItem key="${name_modello}" value="model.jsp?id_marca=${id_marca}&id_modello=${id_modello}" />
    <utils:hashMapItem key="${name}" value="type.jsp?id_marca=${id_marca}&id_modello=${id_modello}&id_tipo=${id}" />
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

                    <h1 class="main-header mb-4">${name_full} <small>(HP: ${hp}, KW: ${kw})</small></h1>
                    <div class="row color-main-info">
                        <div class="col-md-3 mb-5">
                            <div class="product-image p-2">

                                <c:if test="${not empty id_marca and not empty id_modello}">
                                    <sql:query var="modelimages">
                                        SELECT
                                            veicoli_modelli_media.filename AS filename,
                                            veicoli_modelli_media.ext AS ext
                                        FROM
                                            motorinialternatori.veicoli_modelli_media
                                        WHERE
                                            veicoli_modelli_media.id_modello = ?
                                        <sql:param value="${id_modello}" />
                                    </sql:query>
                                </c:if>
                                <c:forEach var="rowimg" items="${modelimages.rowsByIndex}">
                                    <c:set var="model_image" value="${rowimg[0]}.${rowimg[1]}" />
                                </c:forEach>
                                <img class="mb-2" alt="${name_full}" src="${commons.storage("images/models/", model_image)}" />

                                <c:if test="${not empty id_marca}">
                                    <sql:query var="manufacturerlogos">
                                        SELECT
                                            veicoli_marche_media.filename AS filename,
                                            veicoli_marche_media.ext AS ext
                                        FROM
                                            motorinialternatori.veicoli_marche_media
                                        WHERE
                                            veicoli_marche_media.id_marca = ?
                                        <sql:param value="${id_marca}" />
                                    </sql:query>
                                </c:if>
                                <c:forEach var="rowimg" items="${manufacturerlogos.rowsByIndex}">
                                    <c:set var="manufacturer_image" value="${rowimg[0]}.${rowimg[1]}" />
                                </c:forEach>
                                <img alt="${name_marca}" src="${commons.storage("images/brands/", manufacturer_image)}" />

                                <h5 class="mb-2">${name}</h5>
                            </div>
                        </div>
                        <div class="col-md-9 mb-3">
                            <h2 class="terthiary-header mb-2">Informazioni</h2>
                            <div>
                                <ul class="list-group list-group-flush">
                                    <li class="list-group-item"><strong>Marca:</strong> <a href="manufacturer.jsp?id_marca=${id_marca}">${name_marca}</a></li>
                                    <li class="list-group-item"><strong>Modello:</strong> <a href="model.jsp?id_marca=${id_marca}&id_modello=${id_modello}">${name_modello}</a></li>
                                    <li class="list-group-item"><strong>Motorizzazione:</strong> <a href="type.jsp?id_marca=${id_marca}&id_modello=${id_modello}&id_tipo=${id}">${name}</a></li>
                                    <li class="list-group-item"><strong>Intervallo:</strong> ${interval}</li>
                                    <li class="list-group-item"><strong>Potenza:</strong> HP: ${hp}, KW: ${kw}</li>
                                    <li class="list-group-item"><strong>Alimentazione:</strong> ${fuel_type}</li>

                                    <c:if test="${not empty id}">
                                        <sql:query var="enginenumbers">
                                            SELECT
                                                veicoli_motorizzazioni.code
                                            FROM
                                                tecdoc.veicoli_motorizzazioni
                                            WHERE
                                                veicoli_motorizzazioni.id_tipo = ?
                                            GROUP BY
                                                veicoli_motorizzazioni.code
                                            <sql:param value="${id}" />
                                        </sql:query>
                                    </c:if>

                                    <c:set var="engine_numbers" value="" />
                                    <c:forEach var="rowen" items="${enginenumbers.rowsByIndex}" varStatus="status">
                                        <c:set var="engine_numbers">${engine_numbers}<c:if test="${!status.first}">,</c:if> ${rowen[0]} </c:set>
                                    </c:forEach>
                                    <c:set var="enginenumbers" value="" /><%-- svuoto la variabile per il loop --%>

                                    <li class="list-group-item"><strong>Codice motore:</strong> ${engine_numbers}</li>
                                </ul>
                                <p class="color-main-info-box mt-2">L???immagine di anteprima del veicolo ?? indicativa, se la motorizzazione corrisponde il veicolo individuato ?? corretto. Per qualsiasi dubbio contattaci.</p>
                            </div>
                        </div> <!-- col-md-9 mb-5 -->
                        <div class="col-md-12 mb-5">

                            <c:if test="${not empty id}">
                                <sql:query var="categories">
                                    SELECT
                                        ANY_VALUE(categorie.id) AS id,
                                        ANY_VALUE(IF(categorie_synonyms.description IS NOT NULL, categorie_synonyms.description, categorie.description)) AS description
                                    FROM
                                        tecdoc.articoli_veicoli
                                    JOIN tecdoc.articoli ON articoli.id = articoli_veicoli.id_articolo
                                    JOIN kuhner.articles ON articles.id = articoli.id OR articles.id_article = articoli.id
                                    JOIN motorinialternatori.categorie_visibility ON articoli_veicoli.id_categoria = categorie_visibility.id_categoria AND categorie_visibility.visible = 1
                                    JOIN tecdoc.categorie ON categorie.id = articoli_veicoli.id_categoria
                                    LEFT JOIN motorinialternatori.categorie_synonyms ON categorie_synonyms.id_categoria = articoli_veicoli.id_categoria
                                    WHERE
                                        articoli_veicoli.link_target_id = ?
                                    GROUP BY
                                        articoli_veicoli.id_categoria
                                    <sql:param value="${id}" />
                                </sql:query>
                            </c:if>

                            <c:if test="${categories.rowCount > 0}">
                                <h2 class="terthiary-header mt-2">Prodotti disponibili per ${name_full}</h2>
                                <div class="color-choice mt-0">
                                    <div class="row color-choice-list">
                                        <c:forEach var="rowcat" items="${categories.rowsByIndex}" varStatus="status">
                                            <div class="col-md-6 color-choice-item">
                                                <a href="articles.jsp?id_marca=${id_marca}&id_modello=${id_modello}&id_tipo=${id}&id_categoria=${rowcat[0]}">
                                                    <div class="color-choice-info">

                                                        <sql:query var="categoryimages">
                                                            SELECT
                                                                filename,
                                                                ext
                                                            FROM
                                                                motorinialternatori.categorie_media
                                                            WHERE
                                                                id_categoria = ?
                                                            ORDER BY
                                                                filename ASC
                                                            LIMIT 1
                                                            <sql:param value="${rowcat[0]}" />
                                                        </sql:query>
                                                        <c:forEach var="rowimg" items="${categoryimages.rowsByIndex}">
                                                            <c:set var="image" value="${rowimg[0]}.${rowimg[1]}" />
                                                        </c:forEach>
                                                        <c:set var="categoryimages" value="" /><%-- svuoto la variabile per il loop --%>

                                                        <img src="${commons.storage("images/categories/", image)}" alt="${rowcat[1]}" />
                                                        <div class="color-choice-description">
                                                            <p>${rowcat[1]}</p>
                                                        </div>
                                                    </div>
                                                </a>
                                            </div>
                                        </c:forEach>
                                    </div> <!-- .color-choiche -->
                                </div>
                            </c:if>

                        </div>
                    </div> <!-- .color-main-info -->

                </main>

            </div>
        </div>

    </layout:put>
</layout:extends>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/core/commons.jspf" %>
<%@ include file="/WEB-INF/core/sql.jspf" %>
<%@ include file="/WEB-INF/core/routes.jspf" %>

<%@ taglib prefix="utils" uri="/WEB-INF/tlds/utils.tld" %>

<c:if test="${not empty param.id_marca and not empty param.id_modello}">
    <cache:results lang="${lang}" name="models__${param.id_marca}_${param.id_modello}" var="models" />
    <c:if test="${empty models}">
        <sql:query var="models">
            SELECT
                veicoli_marche.id AS id_marca,
                veicoli_marche.description AS marca_description,
                veicoli_modelli.id AS id_modello,
                veicoli_modelli.description AS modello_description,
                '' AS _from,
                '' AS _to,
                veicoli_modelli_description.description AS modello_description_full
            FROM
                tecdoc.veicoli_modelli
            JOIN tecdoc.veicoli_marche ON veicoli_modelli.id_marca = veicoli_marche.id
            LEFT JOIN motorinialternatori.veicoli_modelli_description ON veicoli_modelli.id = veicoli_modelli_description.id_modello
            WHERE
                veicoli_marche.id = ? AND veicoli_modelli.id = ?
            LIMIT 1
            <sql:param value="${param.id_marca}" />
            <sql:param value="${param.id_modello}" />
        </sql:query>
        <cache:results lang="${lang}" name="models__${param.id_marca}_${param.id_modello}" value="${models}" />
    </c:if>
</c:if>
<c:forEach var="rowmod" items="${models.rowsByIndex}" varStatus="status">
    <c:set var="id_marca" value="${rowmod[0]}" />
    <c:set var="name_marca" value="${rowmod[1]}" />
    <c:set var="id" value="${rowmod[2]}" />
    <c:set var="name" value="${rowmod[3]}" />
    <c:set var="description" value="${rowmod[6]}" />
</c:forEach>

<utils:hashMap var="breadcrumbList">
    <utils:hashMapItem key="Marche auto" value="manufacturers.jsp" />
    <utils:hashMapItem key="${name_marca}" value="manufacturer.jsp?id_marca=${id_marca}" />
    <utils:hashMapItem key="${name}" value="model.jsp?id_marca=${id_marca}&id_modello=${id}" />
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

                    <h1 class="main-header">${name_marca} ${name}</h1>
                    <div class="row header">
                        <div class="col-md-9 header-text">
                            <p>${description}</p>
                        </div>
                        <div class="col-md-3 header-image-container">

                            <c:if test="${not empty id}">
                                <cache:results lang="${lang}" name="modelimages_${id}" var="modelimages" />
                                <c:if test="${empty modelimages}">
                                    <sql:query var="modelimages">
                                        SELECT
                                            veicoli_modelli_media.filename AS filename,
                                            veicoli_modelli_media.ext AS ext
                                        FROM
                                            motorinialternatori.veicoli_modelli_media
                                        WHERE
                                            veicoli_modelli_media.id_modello = ?
                                        <sql:param value="${id}" />
                                    </sql:query>
                                    <cache:results lang="${lang}" name="modelimages_${id}" value="${modelimages}" />
                                </c:if>
                            </c:if>
                            <c:forEach var="rowimg" items="${modelimages.rowsByIndex}">
                                <c:set var="image" value="${rowimg[0]}.${rowimg[1]}" />
                            </c:forEach>

                            <img alt="${name}" class="header-img" src="${commons.storage("images/models/", image)}" />
                        </div>
                    </div> <!-- .header -->

                    <div class="color-choice">

                        <c:if test="${not empty id}">
                            <cache:results lang="${lang}" name="model_${id}_types" var="types" />
                            <c:if test="${empty types}">
                                <sql:query var="types">
                                    SELECT
                                        veicoli_tipi.id AS id_tipo,
                                        veicoli_tipi.description AS tipo_description,
                                        veicoli_modelli.id AS id_modello,
                                        veicoli_modelli.description AS modello_description,
                                        veicoli_marche.id AS id_marca,
                                        veicoli_marche.description AS marca_description,
                                        IF(veicoli_tipi._from = '0000-00-00', NULL, DATE_FORMAT(veicoli_tipi._from, '%m-%Y')) AS _from,
                                        IF(veicoli_tipi._to = '0000-00-00', NULL, DATE_FORMAT(veicoli_tipi._to, '%m-%Y')) AS _to,
                                        CAST(veicoli_tipi.engine_hp AS UNSIGNED) AS hp,
                                        CAST(veicoli_tipi.engine_kw AS UNSIGNED) AS kw,
                                        veicoli_tipi.fuel_type AS fuel_type,
                                        veicoli_tipi.id_fuel_type AS id_fuel_type
                                    FROM
                                        tecdoc.veicoli_tipi
                                    JOIN tecdoc.veicoli_modelli ON veicoli_tipi.id_modello = veicoli_modelli.id
                                    JOIN tecdoc.veicoli_marche ON veicoli_modelli.id_marca = veicoli_marche.id
                                    WHERE
                                        EXISTS( SELECT article_id FROM kuhner.articles_vehicles INNER JOIN tecdoc.articoli_categorie ON articoli_categorie.id_articolo = articles_vehicles.article_id INNER JOIN motorinialternatori.categorie_visibility ON ( articoli_categorie.id_categoria = categorie_visibility.id_categoria AND categorie_visibility.visible = 1 ) WHERE veicoli_tipi.id = articles_vehicles.link_target_id )
                                    AND
                                        veicoli_marche.id = ? AND veicoli_modelli.id = ?
                                    ORDER BY
                                        fuel_type ASC
                                    <sql:param value="${id_marca}" />
                                    <sql:param value="${id}" />
                                </sql:query>
                                <cache:results lang="${lang}" name="model_${id}_types" value="${types}" />
                            </c:if>
                        </c:if>

                        <c:if test="${types.rowCount > 0}">
                            <h3 class="h4">Scegli la tua motorizzazione</h3>
                            <div class="row color-choice-list">

                                <c:set var="fuel_type_id" value="" />
                                <c:forEach var="rowtyp" items="${types.rowsByIndex}">
                                    <c:set var="name" value="${rowtyp[1]}" />
                                    <c:set var="fuel_type" value="${rowtyp[10]}" />
                                    <c:set var="hp" value="${rowtyp[8]}" />
                                    <c:set var="kw" value="${rowtyp[9]}" />
                                    <c:set var="interval">
                                        <c:if test="${ not empty rowtyp[6] or not empty rowtyp[7] }">
                                            <c:if test="${ not empty rowtyp[6] }">dal ${rowtyp[6]}</c:if>&nbsp;<c:if test="${ not empty rowtyp[7] }">al ${rowtyp[7]}</c:if>
                                        </c:if>
                                    </c:set>

                                    <cache:results lang="${lang}" name="type_${rowtyp[0]}_enginenumbers" var="enginenumbers" />
                                    <c:if test="${empty enginenumbers}">
                                        <sql:query var="enginenumbers">
                                            SELECT
                                                veicoli_motorizzazioni.code
                                            FROM
                                                tecdoc.veicoli_motorizzazioni
                                            WHERE
                                                veicoli_motorizzazioni.id_tipo = ?
                                            GROUP BY
                                                veicoli_motorizzazioni.code
                                            <sql:param value="${rowtyp[0]}" />
                                        </sql:query>
                                        <cache:results lang="${lang}" name="type_${rowtyp[0]}_enginenumbers" value="${enginenumbers}" />
                                    </c:if>

                                    <c:set var="engine_numbers" value="" />
                                    <c:forEach var="rowen" items="${enginenumbers.rowsByIndex}" varStatus="status">
                                        <c:set var="engine_numbers">${engine_numbers}<c:if test="${!status.first}">,</c:if> ${rowen[0]} </c:set>
                                    </c:forEach>
                                    <c:set var="enginenumbers" value="" /><%-- svuoto la variabile per il loop --%>

                                    <c:if test="${fuel_type_id != rowtyp[10]}"><h4 class="mt-1 w-100 ml-3 h5">${fuel_type}</h4></c:if>
                                    <div class="col-md-6 color-choice-item">
                                        <a href="type.jsp?id_marca=${rowtyp[4]}&id_modello=${rowtyp[2]}&id_tipo=${rowtyp[0]}">
                                            <h6 class="color-choice-name">${name} <small>(HP: ${hp}, KW: ${kw})</small></h6>
                                            <div class="color-choice-info">

                                                <cache:results lang="${lang}" name="fueltypeimages__${rowtyp[11]}" var="fueltypeimages" />
                                                <c:if test="${empty fueltypeimages}">
                                                    <sql:query var="fueltypeimages">
                                                        SELECT
                                                            fuel_type_media.filename AS filename,
                                                            fuel_type_media.ext AS ext,
                                                            fuel_type_media.alt AS alt
                                                        FROM
                                                            motorinialternatori.fuel_type_media
                                                        WHERE
                                                            fuel_type_media.id_fuel_type = ?
                                                        <sql:param value="${rowtyp[11]}" />
                                                    </sql:query>
                                                    <cache:results lang="${lang}" name="fueltypeimages__${rowtyp[11]}" value="${fueltypeimages}" />
                                                </c:if>
                                                <c:forEach var="rowimg" items="${fueltypeimages.rowsByIndex}">
                                                    <c:set var="image" value="${rowimg[0]}.${rowimg[1]}" />
                                                    <c:set var="image_alt" value="${rowimg[2]}" />
                                                </c:forEach>
                                                <c:set var="fueltypeimages" value="" /><%-- svuoto la variabile per il loop --%>

                                                <img alt="${image_alt}" class="header-img" src="${commons.storage("images/alimentazione/", image)}" />
                                                <div class="color-choice-description">
                                                    <p>Periodo: <strong>${interval}</strong></p>
                                                    <p>Alimentazione: <strong>${fuel_type}</strong></p>
                                                    <p>Codice motore: <strong>${engine_numbers}</strong></p>
                                                </div>
                                            </div>
                                        </a>
                                    </div>
                                    <c:set var="fuel_type_id" value="${rowtyp[10]}" />
                                </c:forEach>

                            </div> <!-- .color-choiche -->
                        </c:if>

                    </div>

                </main>

            </div>
        </div>
    </layout:put>
</layout:extends>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ include file="/WEB-INF/core/commons.jspf" %>
<%@ include file="/WEB-INF/core/sql.jspf" %>

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

<h3 class="h4 mt-0 mb-4">${name_full}<br/><small>(HP: ${hp}, KW: ${kw})</small></h3>
<div class="row color-main-info">
    <div class="col-md-12 mb-2">

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

        <h5 class="h5 mt-2">Prodotti disponibili</h5>
        <div class="color-choice mt-0">
            <div class="row color-choice-list">
                <c:forEach var="rowcat" items="${categories.rowsByIndex}" varStatus="status">
                    <div class="col-12 color-choice-item">
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
    </div>
</div> <!-- .color-main-info -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/core/commons.jspf" %>
<%@ include file="/WEB-INF/core/sql.jspf" %>
<%@ include file="/WEB-INF/core/routes.jspf" %>

<%@ taglib prefix="utils" uri="/WEB-INF/tlds/utils.tld" %>

<c:if test="${not empty param.id_marca and not empty param.id_modello and not empty param.id_tipo}">
    <cache:results lang="${lang}" name="types__${param.id_marca}_${param.id_modello}_${param.id_tipo}" var="types" />
    <c:if test="${empty types}">
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
        <cache:results lang="${lang}" name="types__${param.id_marca}_${param.id_modello}_${param.id_tipo}" value="${types}" />
    </c:if>
</c:if>
<c:forEach var="rowtyp" items="${types.rowsByIndex}">
    <c:set var="id_marca" value="${rowtyp[0]}" />
    <c:set var="name_marca" value="${rowtyp[1]}" />
    <c:set var="id_modello" value="${rowtyp[2]}" />
    <c:set var="name_modello" value="${rowtyp[3]}" />
    <c:set var="id_tipo" value="${rowtyp[4]}" />
    <c:set var="name_tipo" value="${rowtyp[5]}" />
    <c:set var="name_tipo_full" value="${name_marca} ${name_modello} ${name_tipo}" />
    <c:set var="hp" value="${rowtyp[8]}" />
    <c:set var="kw" value="${rowtyp[9]}" />
    <c:set var="fuel_type" value="${rowtyp[10]}" />
    <c:set var="interval">
        <c:if test="${ not empty rowtyp[6] or not empty rowtyp[7] }">
            <c:if test="${ not empty rowtyp[6] }">dal ${rowtyp[6]}</c:if>&nbsp;<c:if test="${ not empty rowtyp[7] }">al ${rowtyp[7]}</c:if>
        </c:if>
    </c:set>
</c:forEach>

<c:if test="${not empty param.id_categoria}">
    <cache:results lang="${lang}" name="${param.id_categoria}_category" var="categories" />
    <c:if test="${empty categories}">
        <sql:query var="categories">
            SELECT
                ANY_VALUE(categorie.id) AS id,
                ANY_VALUE(IF(categorie_synonyms.description IS NOT NULL, categorie_synonyms.description, categorie.description)) AS description
            FROM
                tecdoc.articoli_veicoli
            JOIN motorinialternatori_main.categorie_visibility ON articoli_veicoli.id_categoria = categorie_visibility.id_categoria AND categorie_visibility.visible = 1
            JOIN tecdoc.categorie ON categorie.id = articoli_veicoli.id_categoria
            LEFT JOIN motorinialternatori_main.categorie_synonyms ON categorie_synonyms.id_categoria = articoli_veicoli.id_categoria
            WHERE
                articoli_veicoli.id_categoria = ?
            LIMIT 1
            <sql:param value="${param.id_categoria}" />
        </sql:query>
        <cache:results lang="${lang}" name="${param.id_categoria}_category" value="${categories}" />
    </c:if>
</c:if>
<c:forEach var="rowcat" items="${categories.rowsByIndex}">
    <c:set var="id_categoria" value="${rowcat[0]}" />
    <c:set var="name_categoria" value="${rowcat[1]}" />
</c:forEach>

<c:if test="${not empty id_tipo}">
    <cache:results lang="${lang}" name="type_${id_tipo}_enginenumbers" var="enginenumbers" />
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
            <sql:param value="${id_tipo}" />
        </sql:query>
        <cache:results lang="${lang}" name="type_${id_tipo}_enginenumbers" value="${enginenumbers}" />
    </c:if>
</c:if>
<c:set var="engine_numbers" value="" />
<c:forEach var="rowen" items="${enginenumbers.rowsByIndex}" varStatus="status">
    <c:set var="engine_numbers">${engine_numbers}<c:if test="${!status.first}">,</c:if> ${rowen[0]} </c:set>
</c:forEach>

<c:if test="${not empty param.id_categoria}">
    <cache:results lang="${lang}" name="product_${param.id_categoria}_descriptions" var="product_descriptions" />
    <c:if test="${empty product_descriptions}">
        <sql:query var="product_descriptions">
            SELECT
                articoli_description.description
            FROM
                motorinialternatori_main.articoli_description
            WHERE
                articoli_description.id_categoria = ?
            <sql:param value="${param.id_categoria}" />
        </sql:query>
        <cache:results lang="${lang}" name="product_${param.id_categoria}_descriptions" value="${product_descriptions}" />
    </c:if>
</c:if>
<c:set var="product_description" value="" />
<c:forEach var="rowpdesc" items="${product_descriptions.rowsByIndex}" varStatus="status">
    <c:set var="product_description" value="${rowpdesc[0]}" />
</c:forEach>

<utils:hashMap var="breadcrumbList">
    <utils:hashMapItem key="Marche auto" value="manufacturers.jsp" />
    <utils:hashMapItem key="${name_marca}" value="manufacturer.jsp?id_marca=${id_marca}" />
    <utils:hashMapItem key="${name_modello}" value="model.jsp?id_marca=${id_marca}&id_modello=${id_modello}" />
    <utils:hashMapItem key="${name_tipo}" value="type.jsp?id_marca=${id_marca}&id_modello=${id_modello}&id_tipo=${id_tipo}" />
    <utils:hashMapItem key="${name_categoria}" value="articles.jsp?id_marca=${id_marca}&id_modello=${id_modello}&id_tipo=${id_tipo}&id_categoria=${id_categoria}" />
</utils:hashMap>

<layout:extends name="base" >
    <layout:put block="head" type="REPLACE">
        <meta name="description" content="{{description}}">
        <meta name="keywords" content="{{keywords}}">
        <title>Motorini Alternatori</title>
    </layout:put>
    <layout:put block="contents">

        <div class="container-fluid">
            <div class="row">

                <%@ include file="/WEB-INF/partials/aside.jspf" %>

                <main class="col-lg-9 mb-4" role="main">

                    <h1 class="main-header mb-4"><a class="text-dark" data-toggle="collapse" href="#collapseDescription" role="button" aria-expanded="false" aria-controls="collapseDescription">${name_categoria}</a> per ${name_tipo_full}</h1>
                    <div class="collapse" id="collapseDescription">
                        <div class="card card-body">
                            <c:set var="product_description" value="${fn:replace(product_description, '@MARCA@', name_marca)}" />
                            <c:set var="product_description" value="${fn:replace(product_description, '@MODELLO@', name_modello)}" />
                            <c:set var="product_description" value="${fn:replace(product_description, '@MOTORIZZAZIONE@', name_tipo)}" />
                            <c:set var="product_description" value="${fn:replace(product_description, '@CODICEMOTORE@', engine_numbers)}" />
                            <c:set var="product_description" value="${fn:replace(product_description, '@ALIMENTAZIONE@', fuel_type)}" />
                            <p class="m-0 p-0"><small>${product_description}</small></p>
                        </div>
                    </div>
                    <div class="row color-main-info">
                        <div class="col-md-12 mb-3">
                            <div>
                                <ul class="list-group list-group-flush">
                                    <li class="list-group-item"><strong>Categoria prodotto:</strong> ${name_categoria}</li>
                                    <li class="list-group-item"><strong>Veicolo:</strong> <a href="type.jsp?id_marca=${id_marca}&id_modello=${id_modello}&id_tipo=${id_tipo}">${name_tipo_full} ${fuel_type} <small>(HP: ${hp}, KW: ${kw})</small></a></li>
                                    <li class="list-group-item"><strong>Intervallo veicolo:</strong> ${interval}</li>
                                    <li class="list-group-item"><strong>Codice motore veicolo:</strong> ${engine_numbers}</li>
                                </ul>
                            </div>
                        </div> <!-- col-md-9 mb-5 -->
                        <div class="col-md-12 mb-5">

                            <c:if test="${not empty param.id_tipo and not empty param.id_categoria}">
                                <cache:results lang="${lang}" name="articles__${param.id_tipo}_${param.id_categoria}" var="articles" />
                                <c:if test="${empty articles}">
                                    <sql:query var="articles">
                                        SELECT
                                            ANY_VALUE(articoli.id) AS id,
                                            ANY_VALUE(articles.id) AS id_esteso,
                                            ANY_VALUE(articoli_produttori.name) AS name_produttore,
                                            ANY_VALUE(articoli.name) AS name,
                                            ANY_VALUE(articles.description) AS description,
                                            ANY_VALUE(articles.price) AS price,
                                            ANY_VALUE(articles.price_wreck) AS price_wreck,
                                            ANY_VALUE(articles.availability) AS availability,
                                            ANY_VALUE(articoli_veicoli.id_categoria) AS id_categoria,
                                            ANY_VALUE(articoli_veicoli.link_target_id) AS link_target_id
                                        FROM
                                            tecdoc.articoli_veicoli
                                        JOIN tecdoc.articoli ON articoli_veicoli.id_articolo = articoli.id
                                        JOIN kuhner.articles ON articles.id_article = articoli.id OR articles.id = articoli.id
                                        JOIN tecdoc.articoli_produttori ON articoli.id_produttore = articoli_produttori.id
                                        WHERE
                                            articoli_veicoli.link_target_id = ? AND articoli_veicoli.id_categoria = ?
                                        GROUP BY
                                            articles.id
                                        <sql:param value="${param.id_tipo}" />
                                        <sql:param value="${param.id_categoria}" />
                                    </sql:query>
                                    <cache:results lang="${lang}" name="articles__${param.id_tipo}_${param.id_categoria}" value="${articles}" />
                                </c:if>
                            </c:if>

                            <c:if test="${articles.rowCount <= 0}">
                                <div>Nessun prodotto disponibile.</div>
                            </c:if>

                            <c:if test="${articles.rowCount > 0}">

                                <h2 class="terthiary-header mt-4 mb-3">Prodotti disponibili</h2>
                                <c:forEach var="rowart" items="${articles.rowsByIndex}" varStatus="status">
                                    <div class="product">
                                        <h3><a href="article.jsp?id_marca=${id_marca}&id_modello=${id_modello}&id_tipo=${id_tipo}&id_categoria=${id_categoria}&id_articolo=${rowart[1]}">${name_categoria} ${rowart[1]} <small>per ${name_tipo_full}</small></a></h3>
                                        <p>${rowart[4]}</p>
                                        <div class="row product-main-info">
                                            <div class="col-md-3 mb-5">
                                                <div class="product-image">

                                                    <cache:results lang="${lang}" name="image_${rowart[1]}" var="images" />
                                                    <c:if test="${empty images}">
                                                        <sql:query var="images">
                                                            SELECT
                                                                filename,
                                                                ext
                                                            FROM
                                                                motorinialternatori_main.articoli_media
                                                            WHERE
                                                                id_articolo = ?
                                                            ORDER BY filename ASC
                                                            LIMIT 1
                                                            <sql:param value="${rowart[0]}" />
                                                        </sql:query>
                                                        <cache:results lang="${lang}" name="image_${rowart[1]}" value="${images}" />
                                                    </c:if>
                                                    <c:forEach var="rowimg" items="${images.rowsByIndex}">
                                                        <c:set var="image" value="${rowimg[0]}.${rowimg[1]}" />
                                                    </c:forEach>
                                                    <c:set var="images" value="" /><%-- svuoto la variabile per il loop --%>

                                                    <c:if test="${not empty image}">
                                                        <img src="${commons.storage("images/bundles/", image)}" alt="${name_categoria} ${rowart[1]}">
                                                    </c:if>
                                                    <c:if test="${empty image}">
                                                        <img src="${commons.storage("images/", "unavailable.jpg")}" alt="${name_categoria} ${rowart[1]}">
                                                    </c:if>

                                                    <h5>Art. ${rowart[1]}</h5>

                                                    <cache:results lang="${lang}" name="articleean_${rowart[1]}" var="articleeans" />
                                                    <c:if test="${empty articleeans}">
                                                        <sql:query var="articleeans">
                                                            SELECT
                                                                EAN
                                                            FROM
                                                                tecdoc.articoli_ean
                                                            WHERE
                                                                id_articolo = ?
                                                            <sql:param value="${rowart[0]}" />
                                                        </sql:query>
                                                        <cache:results lang="${lang}" name="articleean_${rowart[1]}" value="${articleeans}" />
                                                    </c:if>
                                                    <c:set var="eans" value="" />
                                                    <c:forEach var="rowean" items="${articleeans.rowsByIndex}" varStatus="status">
                                                        <c:set var="eans">${eans}<c:if test="${!status.first}">,</c:if> ${rowean[0]} </c:set>
                                                    </c:forEach>

                                                    EAN: ${eans}

                                                </div>
                                            </div>
                                            <div class="col-md-6 mb-5">

                                                <!-- @todo --
                                                <div class="rating">
                                                    <i class="fas fa-star"></i>
                                                    <i class="fas fa-star"></i>
                                                    <i class="fas fa-star"></i>
                                                    <i class="fas fa-star"></i>
                                                    <i class="fas fa-star-half"></i>
                                                    <a class="reviews" href="#"><strong>4.8</strong> <small>(18 recensioni)</small></a>
                                                </div>
                                                !-- /. -->

                                                <ul class="list-group list-group-flush">

                                                    <cache:results lang="${lang}" name="articleproperties_${rowart[1]}" var="articleproperties" />
                                                    <c:if test="${empty articleproperties}">
                                                        <sql:query var="articleproperties">
                                                            SELECT
                                                                property,
                                                                value,
                                                                unit
                                                            FROM
                                                                tecdoc.articoli_proprieta
                                                            WHERE
                                                                id_articolo = ?
                                                            ORDER BY
                                                                id ASC
                                                            <sql:param value="${rowart[0]}" />
                                                        </sql:query>
                                                        <cache:results lang="${lang}" name="articleproperties_${rowart[1]}" value="${articleproperties}" />
                                                    </c:if>
                                                    <c:forEach var="rowartprop" items="${articleproperties.rowsByIndex}">
                                                        <li class="list-group-item"><strong>${rowartprop[0]}<c:if test="${not empty rowartprop[1]}">:</c:if></strong> ${rowartprop[1]} ${rowartprop[2]}</li>
                                                    </c:forEach>
                                                    <c:set var="articleproperties" value="" /><%-- svuoto la variabile per il loop --%>

                                                </ul>

                                            </div>
                                            <div class="col-md-3 mb-5 text-right">

                                                <c:set var="availability" value="${rowart[7]}" />
                                                <c:choose>
                                                    <c:when test="${availability > 1}">
                                                        <span class="availability">Disponibilità: <strong class="good">Buona</strong></span>
                                                    </c:when>
                                                    <c:when test="${availability > 0}">
                                                        <span class="availability">Disponibilità: <strong class="average">Media</strong></span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="availability">Disponibilità: <strong class="poor">Scarsa</strong></span>
                                                    </c:otherwise>
                                                </c:choose>

                                                <c:set value="${rowart[5]}" var="price" />
                                                <c:set value="22" var="vat" />
                                                <c:set value="${(price/100)*vat}" var="vatted" />
                                                <span class="price-without-vat">Prezzo unitario <fmt:formatNumber value="${price}" type="currency" currencySymbol="€" currencyCode="EUR" /></span>
                                                <span class="price"><fmt:formatNumber value="${price + vatted}" type="currency" currencySymbol="€" currencyCode="EUR" /></span>
                                                <span class="vat-label">iva inclusa</span>
                                                <a class="btn btn-outline-secondary btn-block text-center mb-2" href="article.jsp?id_marca=${id_marca}&id_modello=${id_modello}&id_tipo=${id_tipo}&id_categoria=${id_categoria}&id_articolo=${rowart[1]}"><i class="fas fa-info-circle mr-2"></i> Dettagli articolo</a>
                                                <a class="btn btn-primary btn-block text-center mb-2" href="#"><i class="fas fa-shopping-cart mr-2"></i> Acquista</a>
                                            </div>
                                        </div> <!-- .row -->
                                    </div>

                                    <hr />

                                </c:forEach>

                            </c:if>

                        </div>
                    </div>

                </main>

            </div>
        </div>

    </layout:put>
</layout:extends>
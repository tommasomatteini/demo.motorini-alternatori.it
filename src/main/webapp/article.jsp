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
<c:set var="id_tipo" value="" />
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

<c:if test="${not empty param.id_articolo}">
    <cache:results lang="${lang}" name="article__${param.id_articolo}" var="articles" />
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
                ANY_VALUE(articoli_veicoli.id_categoria) AS id_categoria
            FROM
                tecdoc.articoli
            JOIN tecdoc.articoli_veicoli ON articoli_veicoli.id_articolo = articoli.id
            JOIN kuhner.articles ON articles.id_article = articoli.id OR articles.id = articoli.id
            JOIN tecdoc.articoli_produttori ON articoli.id_produttore = articoli_produttori.id
            WHERE
                articles.id = ?
            GROUP BY
                articoli.id
            <sql:param value="${param.id_articolo}" />
        </sql:query>
        <cache:results lang="${lang}" name="article__${param.id_articolo}" value="${articles}" />
    </c:if>
</c:if>
<c:forEach var="rowart" items="${articles.rowsByIndex}">
    <c:set var="id" value="${rowart[0]}" />
    <c:set var="id_ext" value="${rowart[1]}" />
    <c:set var="name_produttore" value="${rowart[2]}" />
    <c:set var="name" value="${rowart[3]}" />
    <c:set var="description" value="${rowart[4]}" />
    <c:set var="price" value="${rowart[5]}" />
    <c:set var="price_wreck" value="${rowart[6]}" />
    <c:set var="availability" value="${rowart[7]}" />
    <c:set var="id_categoria" value="${rowart[8]}" />
</c:forEach>

<c:if test="${not empty param.id_categoria or not empty id_categoria}">
    <c:if test="${empty id_categoria}">
        <c:set var="id_categoria" value="${param.id_categoria}" />
    </c:if>
    <cache:results lang="${lang}" name="${id_categoria}_category" var="categories" />
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
            <sql:param value="${id_categoria}" />
        </sql:query>
        <cache:results lang="${lang}" name="${id_categoria}_category" value="${categories}" />
    </c:if>
</c:if>
<c:forEach var="rowcat" items="${categories.rowsByIndex}">
    <c:set var="id_categoria" value="${rowcat[0]}" />
    <c:set var="name_categoria" value="${rowcat[1]}" />
</c:forEach>

<c:set var="is_generic" value="${empty param.id_marca or empty param.id_modello or empty param.id_tipo or empty param.id_categoria}" />
<c:if test="${is_generic}">
    <utils:hashMap var="breadcrumbList">
        <utils:hashMapItem key="${name_categoria}" value="category.jsp?id_categoria=${id_categoria}" />
        <utils:hashMapItem key="${id_ext}" value="article.jsp?id_marca=${id_marca}&id_modello=${id_modello}&id_tipo=${id_tipo}&id_categoria=${id_categoria}&id_articolo=${id}" />
    </utils:hashMap>
</c:if>
<c:if test="${not is_generic}">
    <utils:hashMap var="breadcrumbList">
        <utils:hashMapItem key="Marche auto" value="manufacturers.jsp" />
        <utils:hashMapItem key="${name_marca}" value="manufacturer.jsp?id_marca=${id_marca}" />
        <utils:hashMapItem key="${name_modello}" value="model.jsp?id_marca=${id_marca}&id_modello=${id_modello}" />
        <utils:hashMapItem key="${name_tipo}" value="type.jsp?id_marca=${id_marca}&id_modello=${id_modello}&id_tipo=${id_tipo}" />
        <utils:hashMapItem key="${name_categoria}" value="articles.jsp?id_marca=${id_marca}&id_modello=${id_modello}&id_tipo=${id_tipo}&id_categoria=${id_categoria}" />
        <utils:hashMapItem key="${id_ext}" value="article.jsp?id_marca=${id_marca}&id_modello=${id_modello}&id_tipo=${id_tipo}&id_categoria=${id_categoria}&id_articolo=${id}" />
    </utils:hashMap>
</c:if>


<layout:extends name="base" >
    <layout:put block="head" type="REPLACE">
        <meta name="description" content="{{description}}">
        <meta name="keywords" content="{{keywords}}">
        <title>Motorini Alternatori</title>
    </layout:put>
    <layout:put block="contents">
        <div class="container-fluid product">
            <div class="row">

                <%@ include file="/WEB-INF/partials/aside.jspf" %>

                <main class="col-lg-9" role="main">

                    <h1 class="h4">${name_categoria} ${id_ext} <c:if test="${not is_generic}">per ${name_tipo_full}</c:if></h1>
                    <p>${description}</p>
                    <div class="row product-main-info">
                        <div class="col-md-3 mb-4">
                            <div class="product-image">

                                <cache:results lang="${lang}" name="image_${id_ext}" var="images" />
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
                                        <sql:param value="${id}" />
                                    </sql:query>
                                    <cache:results lang="${lang}" name="image_${id_ext}" value="${images}" />
                                </c:if>
                                <c:forEach var="rowimg" items="${images.rowsByIndex}">
                                    <c:set var="image" value="${rowimg[0]}.${rowimg[1]}" />
                                </c:forEach>

                                <c:if test="${not empty image}">
                                    <img src="${commons.storage("images/bundles/", image)}" alt="${category_description} ${rowart[0]}">
                                </c:if>
                                <c:if test="${empty image}">
                                    <img src="${commons.storage("images/", "unavailable.jpg")}" alt="${category_description} ${rowart[0]}">
                                </c:if>

                                <h5>Art. ${id_ext}</h5>

                                <cache:results lang="${lang}" name="articleean_${id_ext}" var="articleeans" />
                                <c:if test="${empty articleeans}">
                                    <sql:query var="articleeans">
                                        SELECT
                                            EAN
                                        FROM
                                            tecdoc.articoli_ean
                                        WHERE
                                            id_articolo = ?
                                        <sql:param value="${id}" />
                                    </sql:query>
                                    <cache:results lang="${lang}" name="articleean_${id_ext}" value="${articleeans}" />
                                </c:if>
                                <c:set var="eans" value="" />
                                <c:forEach var="rowean" items="${articleeans.rowsByIndex}" varStatus="status">
                                    <c:set var="eans">${eans}<c:if test="${!status.first}">,</c:if> ${rowean[0]} </c:set>
                                </c:forEach>

                                EAN: ${eans}

                            </div>
                        </div>
                        <div class="col-md-6">

                            <!--
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half"></i>
                                <a class="reviews" href="#"><strong>4.8</strong> <small>(18 recensioni)</small></a>
                            </div>
                            -->

                            <h2 class="h5">Dettagli tecnici articolo</h2>
                            <ul class="list-group list-group-flush">

                                <li class="list-group-item"><strong>Categoria prodotto:</strong> ${name_categoria}</li>

                                <cache:results lang="${lang}" name="articleproperties_${id_ext}" var="articleproperties" />
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
                                        <sql:param value="${id}" />
                                    </sql:query>
                                    <cache:results lang="${lang}" name="articleproperties_${id_ext}" value="${articleproperties}" />
                                </c:if>
                                <c:forEach var="rowartprop" items="${articleproperties.rowsByIndex}">
                                    <li class="list-group-item"><strong>${rowartprop[0]}<c:if test="${not empty rowartprop[1]}">:</c:if></strong> ${rowartprop[1]} ${rowartprop[2]}</li>
                                </c:forEach>
                            </ul>

                            <c:if test="${not is_generic}">
                                <h2 class="h5 mt-4">Dettagli veicolo</h2>
                                <ul class="list-group list-group-flush">
                                    <li class="list-group-item"><strong>Veicolo:</strong> <a href="type.jsp?id_marca=${id_marca}&id_modello=${id_modello}&id_tipo=${id_tipo}">${name_tipo_full} ${fuel_type} (HP: ${hp}, KW: ${kw})</a></li>
                                    <li class="list-group-item"><strong>Intervallo veicolo:</strong> ${interval}</li>

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
                                    <c:set var="engine_numbers" value="" />
                                    <c:forEach var="rowen" items="${enginenumbers.rowsByIndex}" varStatus="status">
                                        <c:set var="engine_numbers">${engine_numbers}<c:if test="${!status.first}">,</c:if> ${rowen[0]} </c:set>
                                    </c:forEach>
                                    <li class="list-group-item"><strong>Codice motore veicolo:</strong> ${engine_numbers}</li>

                                </ul>
                            </c:if>

                        </div>
                        <div class="col-md-3 text-right">

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

                            <c:set value="22" var="vat" />
                            <c:set value="${(price/100)*vat}" var="vatted" />
                            <span class="price-without-vat">Prezzo unitario <fmt:formatNumber value="${price}" type="currency" currencySymbol="€" currencyCode="EUR" /></span>
                            <span class="price"><fmt:formatNumber value="${price + vatted}" type="currency" currencySymbol="€" currencyCode="EUR" /></span>
                            <span class="vat-label">iva inclusa</span>
                            <a class="btn btn-primary btn-block text-center mb-2" href="#"><i class="fas fa-shopping-cart mr-2"></i> Acquista</a>

                        </div>
                    </div> <!-- .row -->

                    <c:if test="${not is_generic}">
                        <c:if test="${not empty id_categoria}">
                            <cache:results lang="${lang}" name="product_${id_categoria}_descriptions" var="product_descriptions" />
                            <c:if test="${empty product_descriptions}">
                                <sql:query var="product_descriptions">
                                    SELECT
                                        articoli_description.description
                                    FROM
                                        motorinialternatori_main.articoli_description
                                    WHERE
                                        articoli_description.id_categoria = ?
                                    <sql:param value="${id_categoria}" />
                                </sql:query>
                                <cache:results lang="${lang}" name="product_${id_categoria}_descriptions" value="${product_descriptions}" />
                            </c:if>
                        </c:if>
                        <c:set var="product_description" value="" />
                        <c:forEach var="rowpdesc" items="${product_descriptions.rowsByIndex}" varStatus="status">
                            <c:set var="product_description" value="${rowpdesc[0]}" />
                        </c:forEach>
                        <h2 class="mb-3 mt-4">Descrizione prodotto</h2>
                        <c:set var="product_description" value="${fn:replace(product_description, '@MARCA@', name_marca)}" />
                        <c:set var="product_description" value="${fn:replace(product_description, '@MODELLO@', name_modello)}" />
                        <c:set var="product_description" value="${fn:replace(product_description, '@MOTORIZZAZIONE@', name_tipo)}" />
                        <c:set var="product_description" value="${fn:replace(product_description, '@CODICEMOTORE@', engine_numbers)}" />
                        <c:set var="product_description" value="${fn:replace(product_description, '@ALIMENTAZIONE@', fuel_type)}" />
                        <p class="product-descr">${product_description}</p>
                    </c:if>

                    <h2 class="mb-3 mt-4">OEM</h2>
                    <cache:results lang="${lang}" name="articleoems_${id_ext}" var="articleoems" />
                    <c:if test="${empty articleoems}">
                        <sql:query var="articleoems">
                            SELECT
                                OEM,
                                description
                            FROM
                                tecdoc.articoli_oem
                            JOIN tecdoc.veicoli_marche ON veicoli_marche.id = articoli_oem.id_marca
                            WHERE
                                id_articolo = ?
                            <sql:param value="${id}" />
                        </sql:query>
                        <cache:results lang="${lang}" name="articleoems_${id_ext}" value="${articleoems}" />
                    </c:if>
                    <table class="table table-striped table-small">
                        <thead>
                            <tr>
                                <th scope="col">OEM</th>
                                <th scope="col">Produttore</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="rowoem" items="${articleoems.rowsByIndex}">
                                <tr>
                                    <th scope="row">${rowoem[0]}</th>
                                    <td>${rowoem[1]}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <!--
                    <h2>Commenti</h2>
                    <div class="reviews">

                        <div class="review">
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half"></i>
                                <div class="author">Domenico</div>
                                <div class="date">13/09/2019</div>
                            </div>
                            <div class="comment">
                                <h5 class="title">Ottimo prodotto. Ottima comunicazione</h5>
                                Ho avuto necessità di reperire delle vernici per restauro strumenti musicali e che non trovavo a catalogo, VerniciSpray mi ha sempre risolto il problema con competenza e con una velocità mai trovata in altri siti. Una particolare attenzione alla comunicazione che è a dir poco ineccepibile.
                            </div>
                        </div>
                        <div class="review">
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half"></i>
                                <div class="author">Carlo</div>
                                <div class="date">06/09/2019</div>
                            </div>
                            <div class="comment">
                                <h5 class="title">Colore perfetto</h5>
                                Venditore serio, spedizione veloce, e soprattutto colore azzeccato (non tutti ci riescono)
                            </div>
                        </div>
                        <div class="review">
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <div class="author">Claudio</div>
                                <div class="date">01/09/2019</div>
                            </div>
                            <div class="comment">
                                <h5 class="title">Copertura ok</h5>
                                Vernice perfetta con una buona adesione e copertura.
                            </div>
                        </div>

                        <a class="show-all-reviews" href="#">Visualizza tutti i commenti</a>

                        <div class="hidden-reviews">
                            <div class="review">
                                <div class="rating">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <div class="author">Carlo</div>
                                    <div class="date">06/09/2019</div>
                                </div>
                                <div class="comment">
                                    <h5 class="title">Tinta vernice perfetta.</h5>
                                    Vernice perfetta per i sensori della mia Panda caffellatte (beige accogliente)
                                </div>
                            </div>
                        </div>

                    </div>
                    -->

                    <hr>
                    <h2 class="mb-0 mt-4">Veicoli compatibili</h2>
                    <div class="row colors">

                        <sql:query var="compatiblearticles">
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
                                tecdoc.articoli_veicoli
                            JOIN tecdoc.veicoli_tipi ON articoli_veicoli.link_target_id = veicoli_tipi.id
                            JOIN tecdoc.veicoli_modelli ON veicoli_modelli.id = veicoli_tipi.id_modello
                            JOIN tecdoc.veicoli_marche ON veicoli_modelli.id_marca = veicoli_marche.id
                            WHERE
                                articoli_veicoli.id_categoria = ? AND articoli_veicoli.id_articolo = ? AND veicoli_tipi.id <> ?
                            <sql:param value="${id_categoria}" />
                            <sql:param value="${id}" />
                            <sql:param value="${id_tipo}" />
                        </sql:query>

                        <c:forEach var="rowcompatart" items="${compatiblearticles.rowsByIndex}">

                            <c:set var="name" value="${rowcompatart[1]} ${rowcompatart[3]} ${rowcompatart[5]}" />

                            <c:set var="hp" value="${rowcompatart[8]}" />
                            <c:set var="kw" value="${rowcompatart[9]}" />
                            <c:set var="fuel_type" value="${rowcompatart[10]}" />

                            <cache:results lang="${lang}" name="type_${rowcompatart[9]}_enginenumbers" var="enginenumbers" />
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
                                    <sql:param value="${rowcompatart[9]}" />
                                </sql:query>
                                <cache:results lang="${lang}" name="type_${rowcompatart[9]}_enginenumbers" value="${enginenumbers}" />
                            </c:if>
                            <c:set var="engine_numbers" value="" />
                            <c:forEach var="rowen" items="${enginenumbers.rowsByIndex}" varStatus="status">
                                <c:set var="engine_numbers">${engine_numbers}<c:if test="${!status.first}">,</c:if> ${rowen[0]} </c:set>
                            </c:forEach>
                            <c:set var="enginenumbers" value="" /><%-- svuoto la variabile per il loop --%>

                            <div class="col-sm-6 col-xl-4 mt-3">
                                <div class="color">
                                    <h5 class="name"><a href="article.jsp?id_marca=${rowcompatart[0]}&id_modello=${rowcompatart[2]}&id_tipo=${rowcompatart[4]}&id_categoria=${id_categoria}&id_articolo=${id_ext}">${name} <small>(HP ${hp}, KW ${kw})</small></a></h5>
                                    <div class="media">

                                        <cache:results lang="${lang}" name="modelimages__${rowcompatart[0]}_${rowcompatart[2]}" var="modelimages" />
                                        <c:if test="${empty modelimages}">
                                            <sql:query var="modelimages">
                                                SELECT
                                                    veicoli_modelli_media.filename AS filename,
                                                    veicoli_modelli_media.ext AS ext
                                                FROM
                                                    motorinialternatori_main.veicoli_modelli_media
                                                WHERE
                                                    veicoli_modelli_media.id_modello = ?
                                                <sql:param value="${rowcompatart[2]}" />
                                            </sql:query>
                                            <cache:results lang="${lang}" name="modelimages__${rowcompatart[0]}_${rowcompatart[2]}" value="${modelimages}" />
                                        </c:if>
                                        <c:set var="image" value="" />
                                        <c:forEach var="rowimg" items="${modelimages.rowsByIndex}">
                                            <c:set var="image" value="${rowimg[0]}.${rowimg[1]}" />
                                        </c:forEach>
                                        <c:set var="modelimages" value="" /><%-- svuoto la variabile per il loop --%>
                                        <img class="img-responsive" src="${commons.storage("images/models/", image)}">

                                        <div class="media-body">
                                            <p class="mb-1">Periodo: <strong><c:if test="${ not empty rowcompatart[6] or not empty rowcompatart[7] }"><c:if test="${ not empty rowcompatart[6] }">dal ${rowcompatart[6]}</c:if>&nbsp;<c:if test="${ not empty rowcompatart[7] }">al ${rowcompatart[7]}</c:if></c:if></strong></p>
                                            <p class="mb-1">Alimentazione: <strong>${fuel_type}</strong></p>
                                            <p class="mb-1">Codice motore: <strong>${engine_numbers}</strong></p>
                                        </div>
                                    </div>
                                </div> <!-- .color -->
                            </div> <!-- .col -->
                        </c:forEach>

                    </div> <!-- .row.colors -->

                    <c:if test="${not is_generic}">
                        <sql:query var="similararticles">
                            SELECT
                                ANY_VALUE(articoli.id) AS id,
                                ANY_VALUE(articles.id) AS id_esteso,
                                ANY_VALUE(articoli_produttori.name) AS name_produttore,
                                ANY_VALUE(articoli.name) AS name,
                                ANY_VALUE(articles.description) AS description,
                                ANY_VALUE(articles.price) AS price,
                                ANY_VALUE(articles.price_wreck) AS price_wreck,
                                ANY_VALUE(articles.availability) AS availability,
                                ANY_VALUE(articoli_veicoli.id_categoria) AS id_categoria
                            FROM
                                tecdoc.articoli
                            JOIN tecdoc.articoli_veicoli ON articoli_veicoli.id_articolo = articoli.id
                            JOIN kuhner.articles ON articles.id_article = articoli.id OR articles.id = articoli.id
                            JOIN tecdoc.articoli_produttori ON articoli.id_produttore = articoli_produttori.id
                            WHERE
                                articoli_veicoli.link_target_id = ? AND articoli_veicoli.id_categoria = ? AND articles.id <> ?
                            LIMIT 4
                            <sql:param value="${id_tipo}" />
                            <sql:param value="${id_categoria}" />
                            <sql:param value="${id_ext}" />
                        </sql:query>
                        <c:if test="${similararticles.rowCount > 0}">
                            <hr>
                            <h2 class="mb-0">Prodotti simili</h2>
                            <div class="row products-list">

                                <c:forEach var="rowsimilar" items="${similararticles.rowsByIndex}" varStatus="status">
                                    <div class="col-sm-6 col-md-4 col-lg-3 mt-3">
                                        <div class="product-thumb">

                                            <cache:results lang="${lang}" name="image_${rowsimilar[1]}" var="images" />
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
                                                    <sql:param value="${rowsimilar[0]}" />
                                                </sql:query>
                                                <cache:results lang="${lang}" name="image_${rowsimilar[1]}" value="${images}" />
                                            </c:if>
                                            <c:forEach var="rowimg" items="${images.rowsByIndex}">
                                                <c:set var="image" value="${rowimg[0]}.${rowimg[1]}" />
                                            </c:forEach>
                                            <c:set var="images" value="" /><%-- svuoto la variabile per il loop --%>

                                            <c:if test="${not empty image}">
                                                <img src="${commons.storage("images/bundles/", image)}">
                                            </c:if>
                                            <c:if test="${empty image}">
                                                <img src="${commons.storage("images/", "unavailable.jpg")}">
                                            </c:if>

                                            <div class="details">
                                                <h6 class="name">${name_categoria} ${rowsimilar[1]}</h6>
                                                <p class="excerpt">
                                                    <strong>${rowsimilar[4]}</strong><br/>
                                                    Compatibile con ${name_tipo_full} (${interval})
                                                </p>
                                                <span class="price"><fmt:formatNumber value="${rowsimilar[5]}" type="currency" currencySymbol="€" currencyCode="EUR" /><small>iva esclusa</small></span>
                                                <a class="btn btn-primary" href="article.jsp?id_marca=${id_marca}&id_modello=${id_modello}&id_tipo=${id_tipo}&id_categoria=${id_categoria}&id_articolo=${rowsimilar[1]}">Vai al prodotto</a>
                                            </div>

                                        </div>
                                    </div>
                                </c:forEach>

                            </div><!-- .row.products-list -->
                        </c:if>
                    </c:if>

                </main>

            </div>
        </div>
    </layout:put>
</layout:extends>
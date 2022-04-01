<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/core/commons.jspf" %>
<%@ include file="/WEB-INF/core/sql.jspf" %>
<%@ include file="/WEB-INF/core/routes.jspf" %>

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

                    <sql:query var="resulttipiricambi">
                        SELECT
                            t1.codice,
                            t1.descrizione_it,
                            t2.descrizione_it
                        FROM
                            tipo_ricambi_generico t1,
                            tipo_ricambi_generico_descrizione t2
                        WHERE
                            t2.tipo_ricambi_generico = t1.codice AND
                            EXISTS (
                                SELECT
                                    *
                                FROM
                                    motorizzazioni_articoli
                                WHERE
                                    t1.codice = motorizzazioni_articoli.articolo_generico
                                AND
                                    motorizzazioni_articoli.motorizzazione_s = ?
                                AND
                                    t1.codice = ?
                            )
                        <sql:param value="${param.code}" />
                        <sql:param value="${param.category}" />
                    </sql:query>
                    <c:forEach var="rowmot" items="${resulttipiricambi.rowsByIndex}">
                        <c:set var="category_description" value="${rowmot[1]}" />
                        <c:set var="product_description" value="${rowmot[2]}" />
                    </c:forEach>

                    <sql:query var="resultmotorizzazione">
                        SELECT
                            m2.descrizione_it,
                            marche.descrizione,
                            modelli.marca,
                            motorizzazioni.modello,
                            motorizzazioni.descrizione_it,
                            CAST(DATE_FORMAT(STR_TO_DATE(CONCAT(motorizzazioni.anno_inizio,1), '%Y%m%d'), '%m/%Y') AS CHAR) AS anno_inizio,
                            CAST(DATE_FORMAT(STR_TO_DATE(CONCAT(motorizzazioni.anno_fine,1), '%Y%m%d'), '%m/%Y') AS CHAR) AS anno_fine,
                            motorizzazioni.kw,
                            motorizzazioni.hp,
                            motorizzazioni.codice,
                            alimentazione.descrizione_it,
                            marche.descrizione,
                            m2.descrizione_it,
                            motorizzazioni.descrizione_it,
                            marche.descrizione,
                            m2.descrizione_fr,
                            motorizzazioni.descrizione_fr,
                            modelli.codice
                        FROM
                            marche
                        INNER JOIN modelli ON marche.codice = modelli.marca
                        INNER JOIN modelli_ext m2 ON modelli.codice = m2.codice
                        INNER JOIN motorizzazioni ON modelli.codice = motorizzazioni.modello AND motorizzazioni.codice = ?
                        INNER JOIN alimentazione ON motorizzazioni.alimentazione = alimentazione.codice
                        ORDER BY
                            motorizzazioni.descrizione_it ASC
                        <sql:param value="${param.code}" />
                    </sql:query>
                    <c:forEach var="rowmot" items="${resultmotorizzazione.rowsByIndex}">
                        <c:set var="manufacturer_id" value="${rowmot[2]}" />
                        <c:set var="model_id" value="${rowmot[3]}" />
                        <c:set var="type_code" value="${rowmot[17]}" />
                        <c:set var="type_name" value="${rowmot[4]}" />
                        <c:set var="type_name_ext" value="${rowmot[1]} ${rowmot[0]} ${rowmot[4]}" />
                        <c:set var="description" value="${rowmot[12]}" />
                        <c:set var="brand" value="${rowmot[11]}" />
                        <c:set var="model" value="${rowmot[0]}" />
                        <c:set var="interval">
                            <c:if test="${rowmot[5] != '00/0000' and rowmot[6] != '00/0000'}">dal ${rowmot[5]} al ${rowmot[6]}</c:if><c:if test="${rowmot[5] != '00/0000' and rowmot[6] == '00/0000'}">dal ${rowmot[5]}</c:if>
                        </c:set>
                        <c:set var="hp" value="${rowmot[7]}" />
                        <c:set var="kw" value="${rowmot[8]}" />
                        <c:set var="fuel_type" value="${rowmot[10]}" />
                    </c:forEach>

                    <sql:query var="resultenginenumber">
                        SELECT
                            motorizzazioni_numero_motore.numero_motore
                        FROM
                            motorizzazioni_numero_motore
                        WHERE
                            motorizzazioni_numero_motore.motorizzazione = ?
                        <sql:param value="${param.code}" />
                    </sql:query>
                    <c:forEach var="rowen" items="${resultenginenumber.rowsByIndex}" varStatus="status">
                        <c:set var="engine_number">${engine_number} ${rowen[0]}<c:if test="${!status.last}">,</c:if> </c:set>
                    </c:forEach>

                    <h1 class="main-header mb-4"><a class="text-dark" data-toggle="collapse" href="#collapseDescription" role="button" aria-expanded="false" aria-controls="collapseDescription">${category_description}</a> per ${type_name_ext}</h1>
                    <div class="collapse" id="collapseDescription">
                        <div class="card card-body">
                            <c:set var="product_description" value="${fn:replace(product_description, '@MARCA@', brand)}" />
                            <c:set var="product_description" value="${fn:replace(product_description, '@MODELLO@', model)}" />
                            <c:set var="product_description" value="${fn:replace(product_description, '@MOTORIZZAZIONE@', type_name)}" />
                            <c:set var="product_description" value="${fn:replace(product_description, '@CODICEMOTORE@', engine_number)}" />
                            <c:set var="product_description" value="${fn:replace(product_description, '@ALIMENTAZIONE@', fuel_type)}" />
                            <p class="m-0 p-0"><small>${product_description}</small></p>
                        </div>
                    </div>
                    <div class="row color-main-info">
                        <div class="col-md-12 mb-3">
                            <div>
                                <ul class="list-group list-group-flush">
                                    <li class="list-group-item"><strong>Categoria prodotto:</strong> ${category_description}</li>
                                    <li class="list-group-item"><strong>Veicolo:</strong> <a href="#">${type_name_ext} ${fuel_type} <small>(HP: ${hp}, KW: ${kw})</small></a></li>
                                    <li class="list-group-item"><strong>Intervallo veicolo:</strong> ${interval}</li>
                                    <sql:query var="resultenginenumber">
                                        SELECT
                                            motorizzazioni_numero_motore.numero_motore
                                        FROM
                                            motorizzazioni_numero_motore
                                        WHERE
                                            motorizzazioni_numero_motore.motorizzazione = ?
                                        <sql:param value="${param.code}" />
                                    </sql:query>
                                    <c:set var="engine_number" value="" />
                                    <c:forEach var="rowen" items="${resultenginenumber.rowsByIndex}" varStatus="status">
                                        <c:set var="engine_number">${engine_number} ${rowen[0]}<c:if test="${!status.last}">,</c:if> </c:set>
                                    </c:forEach>
                                    <li class="list-group-item"><strong>Codice motore veicolo:</strong> ${engine_number}</li>
                                </ul>
                            </div>
                        </div> <!-- col-md-9 mb-5 -->
                        <div class="col-md-12 mb-5">

                            <sql:query var="resultart">
                                SELECT
                                    motorizzazioni_articoli.articolo,
                                    motorizzazioni_articoli.articolo_generico
                                FROM
                                    motorizzazioni_articoli inner join articoli on codice = articolo
                                WHERE
                                    motorizzazioni_articoli.motorizzazione_s = ? AND
                                    motorizzazioni_articoli.articolo_generico = ? AND
                                    articoli.fornitore = '4528'
                                <sql:param value="${param.code}" />
                                <sql:param value="${param.category}" />
                            </sql:query>

                            <c:if test="${resultart.rowCount <= 0}">
                                <div>Nessun prodotto disponibile.</div>
                            </c:if>

                            <c:if test="${resultart.rowCount > 0}">

                                <h2 class="terthiary-header mt-4 mb-3">Prodotti disponibili</h2>
                                <c:forEach var="rowart" items="${resultart.rowsByIndex}" varStatus="status">

                                    <sql:query var="resultartloc">
                                        SELECT
                                            descrizione, prezzo, prezzo_carcassa, disponibilita
                                        FROM
                                            articoli
                                        WHERE
                                            codice = ?
                                        <sql:param value="${rowart[0]}" />
                                    </sql:query>
                                    <c:forEach var="rown" items="${resultartloc.rowsByIndex}">

                                        <c:set var="availability" value="${rown[3]}" />
                                        <c:set var="description" value="${rown[0]}" />

                                        <!-- @todo -->
                                        <c:set var="price" value="0" /><!-- ... -->
                                        <c:set var="vat_percentage" value="0" /><!-- ... -->
                                        <!-- /. -->

                                        <c:set var="vat" value="${ ( price / 100 ) * vat_percentage }" />

                                    </c:forEach>

                                    <div class="product">
                                        <h3><a href="article.jsp?manufacturer=${param.manufacturer}&model=${param.model}&article=${rowart[0]}">${category_description} ${rowart[0]} <small>per ${type_name_ext}</small></a></h3>
                                        <p>${description}</p>
                                        <div class="row product-main-info">
                                            <div class="col-md-3 mb-5">
                                                <div class="product-image">

                                                    <sql:query var="resultartimages">
                                                        SELECT
                                                            immagine
                                                        FROM
                                                            immagini_articoli
                                                        WHERE
                                                            articolo = ?
                                                        ORDER BY
                                                            immagini_articoli.immagine ASC
                                                        LIMIT 1
                                                        <sql:param value="${rowart[0]}" />
                                                    </sql:query>
                                                    <c:forEach var="resultartimage" items="${resultartimages.rowsByIndex}">
                                                        <c:set var="image" value="${resultartimage[0]}.jpg" />
                                                    </c:forEach>
                                                    <c:if test="${not empty image}">
                                                        <img src="${commons.storage("images/bundles/", image)}" alt="${category_description} ${rowart[0]}">
                                                    </c:if>
                                                    <c:if test="${empty image}">
                                                        <img src="${commons.storage("images/", "unavailable.jpg")}" alt="${category_description} ${rowart[0]}">
                                                    </c:if>

                                                    <h5>Art. ${rowart[0]}</h5>
                                                    EAN:
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

                                                    <sql:query var="resultartcrit">
                                                        SELECT
                                                            descrizione_it,
                                                            valore
                                                        FROM
                                                            proprieta_articoli
                                                        WHERE
                                                            articolo = ?
                                                        ORDER BY
                                                            proprieta_articoli.descrizione_it ASC
                                                        <sql:param value="${rowart[0]}" />
                                                    </sql:query>
                                                    <c:forEach var="rowcrit" items="${resultartcrit.rowsByIndex}">
                                                        <li class="list-group-item"><strong>${rowcrit[0]}<c:if test="${not empty rowcrit[1]}">:</c:if></strong> ${rowcrit[1]}</li>
                                                    </c:forEach>

                                                </ul>

                                            </div>
                                            <div class="col-md-3 mb-5 text-right">

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

                                                <span class="price-without-vat">Prezzo unitario <fmt:formatNumber value="${price}" pattern="0.00" type="currency" /></span>
                                                <span class="price"><fmt:formatNumber value="${price + vat}" type="currency" currencySymbol="€" currencyCode="EUR" /></span>
                                                <span class="vat-label">iva inclusa</span>
                                                <a class="btn btn-outline-secondary btn-block text-center mb-2" href="article.jsp?manufacturer=${param.manufacturer}&model=${param.model}&article=${rowart[0]}"><i class="fas fa-info-circle mr-2"></i> Dettagli articolo</a>
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
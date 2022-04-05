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

        <div class="container-fluid anno-fabbricazione">
            <div class="row">

                <%@ include file="/WEB-INF/partials/aside.jspf" %>

                <main class="col-lg-9 mb-4" role="main">

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
                            <c:if test="${rowmot[5] != null and rowmot[6] != null}">dal ${rowmot[5]} al ${rowmot[6]}</c:if><c:if test="${rowmot[5] != null and rowmot[6] == null}">dal ${rowmot[5]}</c:if>
                        </c:set>
                        <c:set var="hp" value="${rowmot[7]}" />
                        <c:set var="kw" value="${rowmot[8]}" />
                        <c:set var="fuel_type" value="${rowmot[10]}" />
                    </c:forEach>
                    <h1 class="main-header mb-4">${type_name_ext} <small>(HP: ${hp}, KW: ${kw})</small></h1>
                    <div class="row color-main-info">
                        <div class="col-md-3 mb-5">
                            <div class="product-image p-2">
                                <c:set value="${fn:replace(fn:toLowerCase(type_code),' ','-')}.jpg" var="image" />
                                <img class="mb-2" alt="${type_name}" src="${commons.storage("images/models/", image)}" />
                                <c:set value="${fn:replace(fn:toLowerCase(brand),' ','-')}.png" var="image_brand" />
                                <img alt="${brand}" src="${commons.storage("images/brands/", image_brand)}" />
                                <h5 class="mb-2">${type_name}</h5>
                            </div>
                        </div>
                        <div class="col-md-9 mb-3">
                            <h2 class="terthiary-header mb-2">Informazioni</h2>
                            <div>
                                <ul class="list-group list-group-flush">
                                    <li class="list-group-item"><strong>Marca:</strong> <a href="manufacturer.jsp?id=${manufacturer_id}">${brand}</a></li>
                                    <li class="list-group-item"><strong>Modello:</strong> <a href="model.jsp?id=${model_id}&id_manifacturer=${manufacturer_id}">${model}</a></li>
                                    <li class="list-group-item"><strong>Motorizzazione:</strong> <a href="type.jsp?code=${param.code}">${type_name}</a></li>
                                    <li class="list-group-item"><strong>Intervallo:</strong> ${interval}</li>
                                    <li class="list-group-item"><strong>Potenza:</strong> HP: ${hp}, KW: ${kw}</li>
                                    <li class="list-group-item"><strong>Alimentazione:</strong> ${fuel_type}</li>

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
                                    <li class="list-group-item"><strong>Codice motore:</strong> ${engine_number}</li>
                                </ul>
                                <p class="color-main-info-box mt-2">L’immagine di anteprima del veicolo è indicativa, se la motorizzazione corrisponde il veicolo individuato è corretto. Per qualsiasi dubbio contattaci.</p>
                            </div>
                        </div> <!-- col-md-9 mb-5 -->
                        <div class="col-md-12 mb-5">
                            <sql:query var="resulttipiricambi">
                                SELECT
                                    t1.codice,
                                    t1.descrizione_it,
                                    t1.descrizione_it,
                                    t1.descrizione_fr
                                FROM
                                    tipo_ricambi_generico t1
                                WHERE
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
                                            (t1.codice = 2 OR t1.codice = 4 OR t1.codice = 1390 OR t1.codice = 295 OR t1.codice = 1561)
                                    )
                                <sql:param value="${param.code}" />
                            </sql:query>
                            <h2 class="terthiary-header mt-2">Prodotti disponibili per ${type_name_ext}</h2>
                            <div class="color-choice mt-0">
                                <div class="row color-choice-list">
                                    <c:forEach var="rowtipiricambi" items="${resulttipiricambi.rowsByIndex}" varStatus="status">
                                        <div class="col-md-6 color-choice-item">
                                            <a href="articles.jsp?manufacturer=${manufacturer_id}&model=${model_id}&code=${param.code}&category=${rowtipiricambi[0]}">
                                                <div class="color-choice-info">
                                                    <c:set value="${fn:replace(fn:toLowerCase(rowtipiricambi[0]),' ','-')}.png" var="image" />
                                                    <img src="${commons.storage("images/categories/", image)}" alt="${rowtipiricambi[1]}" />
                                                    <div class="color-choice-description">
                                                        <p>${rowtipiricambi[1]}</p>
                                                    </div>
                                                </div>
                                            </a>
                                        </div>
                                    </c:forEach>
                                </div> <!-- .color-choiche -->
                            </div>
                        </div>
                    </div> <!-- .color-main-info -->

                </main>

            </div>
        </div>

    </layout:put>
</layout:extends>
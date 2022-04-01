<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/core/commons.jspf" %>
<%@ include file="/WEB-INF/core/sql.jspf" %>
<%@ include file="/WEB-INF/core/routes.jspf" %>
<%@ taglib prefix="ex" uri="/WEB-INF/tags/custom.tld"%>

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

                    <sql:query var="resultmotorizzazioni">
                        SELECT
                            m2.descrizione_it,
                            m3.descrizione,
                            modelli.marca,
                            motorizzazioni.modello,
                            motorizzazioni.descrizione_it,
                            CAST(DATE_FORMAT(STR_TO_DATE(CONCAT(motorizzazioni.anno_inizio,1), '%Y%m%d'), '%m/%Y') AS CHAR) AS anno_inizio,
                            CAST(DATE_FORMAT(STR_TO_DATE(CONCAT(motorizzazioni.anno_fine,1), '%Y%m%d'), '%m/%Y') AS CHAR) AS anno_fine,
                            motorizzazioni.kw,
                            motorizzazioni.hp,
                            motorizzazioni.codice,
                            alimentazione.descrizione_it,
                            motorizzazioni.alimentazione,
                            m2.descrizione_estesa_it,
                            m3.descrizione,
                            m2.descrizione_it,
                            m3.descrizione,
                            m2.descrizione_fr,
                            modelli.codice
                        FROM
                            marche
                        INNER JOIN modelli ON marche.codice = modelli.marca AND marche.codice = ?
                        INNER JOIN modelli_ext m2 ON modelli.codice = m2.codice
                        INNER JOIN marche_ext m3 ON marche.codice = m3.marca
                        INNER JOIN motorizzazioni ON modelli.codice = motorizzazioni.modello AND modelli.codice = ?
                        INNER JOIN alimentazione ON motorizzazioni.alimentazione = alimentazione.codice
                        WHERE EXISTS (
                            SELECT
                                *
                            FROM
                                tipo_ricambi_generico t1, motorizzazioni_articoli
                            WHERE
                                t1.codice = motorizzazioni_articoli.articolo_generico
                            AND
                                motorizzazioni_articoli.motorizzazione_s = motorizzazioni.codice
                            AND
                                (t1.codice = 2 OR t1.codice = 4 OR t1.codice = 1390 OR t1.codice = 295 OR t1.codice = 1561)
                        )
                        ORDER BY
                            motorizzazioni.alimentazione ASC,
                            motorizzazioni.descrizione_it ASC
                        <sql:param value="${param.id_manifacturer}" />
                        <sql:param value="${param.id}" />
                    </sql:query>
                    <c:forEach var="rowmot" items="${resultmotorizzazioni.rowsByIndex}" varStatus="status">
                        <c:set var="name" value="${rowmot[1]} ${rowmot[0]}" />
                        <c:set var="description" value="${rowmot[12]}" />
                        <c:set var="image" value="${rowmot[17]}.jpg" />
                    </c:forEach>

                    <h1 class="main-header">${name}</h1>
                    <div class="row header">
                        <div class="col-md-9 header-text">
                            <p>${description}</p>
                        </div>
                        <div class="col-md-3 header-image-container">
                            <img alt="${name}" class="header-img" src="${commons.storage("images/models/", image)}" />
                        </div>
                    </div> <!-- .header -->

                    <div class="color-choice">
                        <h3 class="h4">Scegli la tua motorizzazione</h3>
                        <div class="row color-choice-list">

                            <c:forEach var="rowmot" items="${resultmotorizzazioni.rowsByIndex}">
                                <c:set var="name" value="${rowmot[4]}" />
                                <c:set var="description" value="${rowmot[12]}" />
                                <c:set var="image" value="${rowmot[11]}.png" />
                                <c:set var="interval">
                                    <c:if test="${rowmot[5] != '00/0000' and rowmot[6] != '00/0000'}">dal ${rowmot[5]} al ${rowmot[6]}</c:if><c:if test="${rowmot[5] != '00/0000' and rowmot[6] == '00/0000'}">dal ${rowmot[5]}</c:if>
                                </c:set>
                                <c:set var="hp" value="${rowmot[7]}" />
                                <c:set var="kw" value="${rowmot[8]}" />
                                <c:set var="fuel_type_txt" value="${rowmot[10]}" />

                                <sql:query var="resultenginenumber">
                                    SELECT
                                        motorizzazioni_numero_motore.numero_motore
                                    FROM
                                        motorizzazioni_numero_motore
                                    WHERE
                                        motorizzazioni_numero_motore.motorizzazione = ?
                                    <sql:param value="${rowmot[9]}" />
                                </sql:query>
                                <c:forEach var="rowen" items="${resultenginenumber.rowsByIndex}" varStatus="status">
                                    <c:set var="engine_number">${engine_number} ${rowen[0]}<c:if test="${!status.last}">,</c:if> </c:set>
                                </c:forEach>

                                <c:if test="${fuel_type != rowmot[11]}"><h4 class="mt-1 w-100 ml-3 h5">${rowmot[10]}</h4></c:if>
                                <div class="col-md-6 color-choice-item">
                                    <a href="type.jsp?code=${rowmot[9]}">
                                        <h6 class="color-choice-name">${name} <small>(HP: ${hp}, KW: ${kw})</small></h6>
                                        <div class="color-choice-info">
                                            <img alt="${name}" class="header-img" src="${commons.storage("images/alimentazione/", image)}" />
                                            <div class="color-choice-description">
                                                <p>Periodo: <strong>${interval}</strong></p>
                                                <p>Alimentazione: <strong>${fuel_type_txt}</strong></p>
                                                <p>Codice motore: <strong>${engine_number}</strong></p>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                                <c:set var="fuel_type" value="${rowmot[11]}" />
                            </c:forEach>

                        </div> <!-- .color-choiche -->
                    </div>

                </main>

            </div>
        </div>
    </layout:put>
</layout:extends>
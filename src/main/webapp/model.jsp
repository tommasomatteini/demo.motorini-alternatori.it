<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/commons.jspf" %>
<%@ include file="/WEB-INF/sql.jspf" %>
<%@ include file="/WEB-INF/routes.jspf" %>
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

                <%@ include file="WEB-INF/partials/aside.jspf" %>

                <main class="col-lg-9 mb-4" role="main">

                    <sql:query var="resultmotorizzazioni">
                        SELECT
                            m2.descrizione_it,
                            m3.descrizione,
                            modelli.marca,
                            motorizzazioni.modello,
                            motorizzazioni.descrizione_it,
                            motorizzazioni.anno_inizio,
                            motorizzazioni.anno_fine,
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
                            motorizzazioni.descrizione_it ASC
                        <sql:param value="${param.id_manifacturer}" />
                        <sql:param value="${param.id}" />
                    </sql:query>

                    <c:set var="name" value="" />
                    <c:set var="description" value="" />
                    <c:set var="image" value="" />
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
                        <h3 class="terthiary-header">Scegli la tua motorizzazione</h3>
                        <div class="row color-choice-list">

                            <c:forEach var="rowmot" items="${resultmotorizzazioni.rowsByIndex}" varStatus="status">
                                <div class="col-md-6 color-choice-item">
                                    <a href="color_results.html">
                                        <h6 class="color-choice-name">Absoluterote</h6>
                                        <div class="color-choice-info">
                                            <img src="" alt="" />
                                            <div class="color-choice-description">
                                                <p>Codice colore originale: <strong>Y3F</strong></p>
                                                <p>Anno: <strong>1999-2002</strong></p>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            </c:forEach>

                        </div> <!-- .color-choiche -->
                    </div>

                </main>

            </div>
        </div>
    </layout:put>
</layout:extends>
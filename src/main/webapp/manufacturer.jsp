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

                <sql:query var="resultmodelli">
                    SELECT
                        m1.codice,
                        m2.descrizione_it,
                        m3.descrizione,
                        m1.anno_inizio,
                        m1.anno_fine,
                        m1.marca,
                        m3.descrizione_estesa_it
                    FROM
                        marche
                    INNER JOIN modelli m1 ON marche.codice = m1.marca AND marche.codice = ?
                    INNER JOIN marche_ext m3 ON marche.codice = m3.marca
                    INNER JOIN modelli_ext m2 ON m1.codice = m2.codice
                    WHERE EXISTS (
                        SELECT
                            *
                        FROM
                            motorizzazioni,
                            tipo_ricambi_generico t1,
                            motorizzazioni_articoli
                        WHERE
                            m1.codice = motorizzazioni.modello
                        AND
                            t1.codice = motorizzazioni_articoli.articolo_generico
                        AND
                            motorizzazioni_articoli.motorizzazione_s = motorizzazioni.codice
                        AND
                            (t1.codice = 2 OR t1.codice = 4 OR t1.codice = 1390 OR t1.codice = 295 OR t1.codice = 1561)
                    )
                    ORDER BY
                        m1.descrizione_it ASC
                    <sql:param value="${param.id}" />
                </sql:query>

                <c:set var="name" value="" />
                <c:set var="description" value="" />
                <c:forEach var="rowmot" items="${resultmodelli.rowsByIndex}" varStatus="status">
                    <c:set var="name" value="${rowmot[2]}" />
                    <c:set var="description" value="${rowmot[6]}" />
                </c:forEach>

                <main class="col-lg-9 mb-4" role="main">
                    <h1 class="main-header">${name}</h1>
                    <div class="row header">
                        <div class="col-md-9 header-text">
                            <p>${description}</p>
                        </div>
                        <div class="col-md-3 header-image-container">
                            <c:set value="${fn:replace(fn:toLowerCase(name),' ','-')}.png" var="image" />
                            <img src="${commons.storage("images/brands/", image)}" alt="${name}" class="header-img">
                        </div>
                    </div> <!-- .header -->

                    <div class="color-choice">
                        <h3 class="terthiary-header">Scegli il tuo modello</h3>
                        <div class="row color-choice-list">

                            <c:forEach var="rowmot" items="${resultmodelli.rowsByIndex}" varStatus="status">
                                <div class="col-md-6 color-choice-item">
                                    <a href="model.jsp?id=${rowmot[0]}&id_manifacturer=${param.id}">
                                        <h6 class="color-choice-name">${rowmot[2]} ${rowmot[1]}</h6>
                                        <div class="color-choice-info">
                                            <c:set var="image" value="${rowmot[0]}.jpg" />
                                            <img alt="${rowmot[2]} ${rowmot[1]}" class="img-responsive" src="${commons.storage("images/models/", image)}" />
                                            <div class="color-choice-description">
                                                <p>Modello: ${rowmot[1]}</p>
                                                <p>Anno: <strong>dal ${fn:substring(rowmot[3], 4, 7)}-${fn:substring(rowmot[3], 0, 4)}<c:if test="${!empty rowmot[4]}"> al ${fn:substring(rowmot[4], 4, 7)}-${fn:substring(rowmot[4], 0, 4)}</c:if></strong></p>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            </c:forEach>

                        </div> <!-- .color-choiche -->
                    </div>

                </main>

            </div> <!-- .row -->
        </div> <!-- .container-fluid -->
    </layout:put>
</layout:extends>
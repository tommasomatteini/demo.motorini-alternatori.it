<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/core/commons.jspf" %>
<%@ include file="/WEB-INF/core/sql.jspf" %>
<%@ include file="/WEB-INF/core/routes.jspf" %>
<%@ taglib prefix="ex" uri="/WEB-INF/tags/custom.tld" %>

<layout:extends name="base" >
    <layout:put block="head" type="REPLACE">
        <meta name="description" content="{{description}}">
        <meta name="keywords" content="{{keywords}}">
        <title>Motorini Alternatori</title>
    </layout:put>
    <layout:put block="contents">
        <!-- <ex:Hello message = "This is custom tag" /> -->

        <div class="container-fluid home">
            <div class="row">

                <aside class="col-lg-3">
                    <ul class="nav nav-tabs search-tabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link search-car-parts active" data-toggle="tab" href="#car-parts-tab" role="tab" aria-controls="car-parts" aria-selected="true">
                                <span class="d-flex w-100 flex-row">
                                    <span class="material-icons material-icons-outlined">construction</span>
                                    <span class="ml-2">Cerca ricambi</span>
                                </span>
                            </a>
                        </li>
                    </ul>
                    <div class="tab-content search-tabs-content" id="car-colors-tab">
                        <div class="tab-pane active show">
                            <div class="">
                                <h5 class="">Ricerca guidata ricambi auto</h5>
                                <form method="get" class="form" id="form_autoricambi" role="form" action="type.jsp" accept-charset="UTF-8" name="form_autoricambi" autocomplete="off">
                                    <input type="hidden" >
                                    <div class="form-group">
                                        <label class="sr-only" for="form_autoricambi_manufacturers">Marca</label>
                                        <select name="manufacturer" id="form_autoricambi_manufacturers" class="form-control" disabled>
                                            <option value="-1">Marca</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label class="sr-only" for="form_autoricambi_models">Modello</label>
                                        <select name="model" id="form_autoricambi_models" class="form-control" disabled>
                                            <option value="-1">Modello</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label class="sr-only" for="form_autoricambi_type">Motorizzazione</label>
                                        <select name="code" class="form-control" id="form_autoricambi_type" disabled>
                                            <option value="-1">Motorizzazione</option>
                                        </select>
                                    </div>
                                    <button class="btn btn-primary" disabled>Cerca ricambio</button>
                                </form>
                            </div>
                            <hr />
                            <div class="mb-sm-4 mb-md-4">
                                <h5>Hai dubbi? Ti aiutiamo noi</h5>
                                <a class="btn btn-primary" href="#">Contattaci</a>
                            </div>
                        </div>
                    </div>
                </aside>

                <div class="col-lg-9" role="main">
                    <div class="owl-carousel owl-theme hero-carousel">
                        <a class="hero-banner" href="#">
                            <img src="https://via.placeholder.com/1000x480">
                        </a>
                        <a class="hero-banner" href="#">
                            <img src="https://via.placeholder.com/1000x480">
                        </a>
                        <a class="hero-banner" href="#">
                            <img src="https://via.placeholder.com/1000x480">
                        </a>
                        <a class="hero-banner" href="#">
                            <img src="https://via.placeholder.com/1000x480">
                        </a>
                    </div>
                </div>

            </div>

            <div class="row">

                <div class="col-lg-9" role="main">

                    <p class="lead">Un vasto assortimento di ricambi, qualità garantita e pagamenti sicuri. Un centro assistenza disponibile e competente a tua disposizione. <strong>Prezzi convenienti e spedizione in 24 ore.</strong></p>

                    <sql:query var="resultmarche">
                        SELECT
                            m1.codice,
                            m3.descrizione
                        FROM
                            marche m1
                        INNER JOIN marche_ext m3 ON m1.codice = m3.marca
                        WHERE
                            m3.visibile = 'Y'
                        AND
                            m3.visibile_home = 'Y'
                        ORDER BY
                            descrizione
                    </sql:query>
                    <div class="brands-box">
                        <c:forEach var="row" items="${resultmarche.rowsByIndex}">
                            <a class="brand" href="manufacturer.jsp?id=${row[0]}" title="${row[1]}">
                                <c:set value="${fn:replace(fn:toLowerCase(row[1]),' ','-')}.png" var="image" />
                                <img class="img-responsive p-3" src="${commons.storage("images/brands/", image)}" alt="${row[1]}" />
                                ${row[1]}
                            </a>
                        </c:forEach>
                    </div>

                    <p>Ogni marca auto ha il suo ricambio carrozzeria che si adatta perfettamente. La marca, il modello e l'anno di immatricolazione sono le uniche informazioni che ti occorrono per individuare il tuo componente di carrozzeria compatibile per la tua auto senza avere nessun dubbio!</p>
                    <a class="btn btn-primary" href="#">Tutte le marche</a>

                    <hr>

                    <sql:query var="resultmodelli">
                        SELECT
                            marche.descrizione,
                            modelli_ext.descrizione_it,
                            motorizzazioni.descrizione_it,
                            motorizzazioni.anno_inizio,
                            motorizzazioni.anno_fine,
                            tipo_ricambi_generico.descrizione_it,
                            marche.codice,
                            modelli.codice,
                            home_motorini.motorizzazione,
                            home_motorini.tipo_ricambi_generico
                        FROM
                            home_motorini
                        INNER JOIN tipo_ricambi_generico ON home_motorini.tipo_ricambi_generico = tipo_ricambi_generico.codice
                        INNER JOIN tipo_ricambi_generico_descrizione ON tipo_ricambi_generico.codice = tipo_ricambi_generico_descrizione.tipo_ricambi_generico
                        INNER JOIN motorizzazioni ON home_motorini.motorizzazione = motorizzazioni.codice
                        INNER JOIN modelli ON motorizzazioni.modello = modelli.codice
                        INNER JOIN modelli_ext ON modelli.codice = modelli_ext.codice
                        INNER JOIN marche ON modelli.marca = marche.codice
                        INNER JOIN marche_ext ON marche.codice = marche_ext.marca
                        ORDER BY
                            home_motorini.tipo_ricambi_generico ASC
                    </sql:query>
                    <c:set var="tipo_corrente" value="" />
                    <c:forEach var="rowmot" items="${resultmodelli.rowsByIndex}" varStatus="status">
                        <c:if test="${ !status.first && tipo_corrente != rowmot[9]}">
                            </div>
                        </c:if>
                        <c:if test="${ status.first || tipo_corrente != rowmot[9] }">
                            <h2><a href="#">${rowmot[5]}</a></h2>
                            <div class="row products-list">
                        </c:if>
                            <div class="col-sm-6 col-md-4 col-lg-3">
                                <div class="product-thumb">
                                    <sql:query var="resultarticoli">
                                        SELECT
                                            motorizzazioni_articoli.articolo,
                                            motorizzazioni_articoli.articolo_generico,
                                            descrizione,
                                            prezzo,
                                            prezzo_carcassa,
                                            disponibilita
                                        FROM
                                            motorizzazioni_articoli
                                        INNER JOIN articoli ON articoli.codice = motorizzazioni_articoli.articolo
                                        WHERE
                                            motorizzazioni_articoli.motorizzazione_s = ? AND
                                            motorizzazioni_articoli.articolo_generico = ? AND
                                            articoli.fornitore = '4528'
                                        ORDER BY prezzo ASC
                                        LIMIT 1
                                        <sql:param value="${rowmot[8]}" />
                                        <sql:param value="${rowmot[9]}" />
                                    </sql:query>
                                    <c:forEach var="resultarticolo" items="${resultarticoli.rowsByIndex}">
                                        <c:set var="id" value="${resultarticolo[0]}" />
                                        <c:set var="price" value="${resultarticolo[3]}" /><!-- @TODO -->
                                        <c:set var="description" value="${resultarticolo[2]}" />
                                    </c:forEach>
                                    <sql:query var="resultartimages">
                                        SELECT
                                            immagine
                                        FROM
                                            immagini_articoli
                                        WHERE
                                            articolo = ?
                                        ORDER BY immagini_articoli.immagine ASC
                                        LIMIT 1
                                        <sql:param value="${id}" />
                                    </sql:query>
                                    <c:forEach var="resultartimage" items="${resultartimages.rowsByIndex}">
                                        <c:set var="image" value="${resultartimage[0]}.jpg" />
                                    </c:forEach>
                                    <c:if test="${not empty image}">
                                        <img src="${commons.storage("images/bundles/", image)}" alt="${id} ${description}">
                                    </c:if>
                                    <c:if test="${empty image}">
                                        <img src="${commons.storage("images/", "unavailable.jpg")}" alt="${id} ${description}">
                                    </c:if>
                                    <div class="details">
                                        <h6 class="name">${rowmot[5]} ${id}</h6>
                                        <p class="excerpt">
                                            <strong>${description}</strong><br/>
                                            Compatibile con <strong>${rowmot[0]} ${rowmot[1]} ${rowmot[2]} (${fn:substring(rowmot[3], 4, 7)}-${fn:substring(rowmot[3], 0, 4)}<c:if test="${!empty rowmot[4]}">/${fn:substring(rowmot[4], 4, 7)}-${fn:substring(rowmot[4], 0, 4)}</c:if>)</strong>
                                        </p>
                                        <span class="price">€ 0,00<small>iva esclusa</small></span>
                                        <a class="btn btn-primary" href="article.jsp?manufacturer=${rowmot[6]}&model=${rowmot[7]}&code=${rowmot[8]}&category=${rowmot[9]}&article=${id}">Vai al prodotto</a>
                                    </div>
                                </div>
                            </div>
                        <c:if test="${ status.last }">
                            </div>
                        </c:if>
                        <c:set var="tipo_corrente" value="${rowmot[9]}" />
                    </c:forEach>

                </div>

                <aside class="col-lg-3">
                    <div class="sticky">
                        <div class="mb-4">
                            <a href="#">
                                <img class="w-100" src="https://via.placeholder.com/300x120" />
                            </a>
                        </div>
                        <div class="mb-4">
                            <a href="#">
                                <img class="w-100" src="https://via.placeholder.com/300x120" />
                            </a>
                        </div>
                        <div class="mb-4">
                            <a href="#">
                                <img class="w-100" src="https://via.placeholder.com/300x120" />
                            </a>
                        </div>
                        <div class="customer-care d-sm-none d-md-none d-lg-block">
                            Hai dubbi? chiama i nostri esperti
                            <a href="tel:+390571530262"><img src="${commons.assets("img/customercare-it.png")}"></a>
                        </div>
                    </div>
                </aside>

            </div> <!-- .row -->
        </div> <!-- .container-fluid -->

    </layout:put>
</layout:extends>
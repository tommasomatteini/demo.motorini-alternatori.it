<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ include file="/WEB-INF/core/commons.jspf" %>
<%@ include file="/WEB-INF/core/sql.jspf" %>
<%@ include file="/WEB-INF/core/routes.jspf" %>

<%@ taglib prefix="utils" uri="/WEB-INF/tlds/utils.tld" %>
<%@ taglib prefix="ex" uri="/WEB-INF/tlds/custom.tld" %>

<layout:extends name="base" >
    <layout:put block="head" type="REPLACE">
        <meta name="description" content="{{description}}">
        <meta name="keywords" content="{{keywords}}">
        <title>Motorini Alternatori</title>
    </layout:put>
    <layout:put block="contents">
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
                                    <div class="form-group">
                                        <label class="sr-only" for="form_autoricambi_manufacturers">Marca</label>
                                        <select name="id_marca" id="form_autoricambi_manufacturers" class="form-control" disabled>
                                            <option value="-1">Marca</option>
                                        </select>
                                        <div class="loader-line loader-line-manufacturers w-100"></div>
                                    </div>
                                    <div class="form-group">
                                        <label class="sr-only" for="form_autoricambi_models">Modello</label>
                                        <select name="id_modello" id="form_autoricambi_models" class="form-control" disabled>
                                            <option value="-1">Modello</option>
                                        </select>
                                        <div class="loader-line loader-line-models w-100"></div>
                                    </div>
                                    <div class="form-group">
                                        <label class="sr-only" for="form_autoricambi_type">Motorizzazione</label>
                                        <select name="id_tipo" class="form-control" id="form_autoricambi_type" disabled>
                                            <option value="-1">Motorizzazione</option>
                                        </select>
                                        <div class="loader-line loader-line-types w-100"></div>
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

                    <p class="lead">Un vasto assortimento di ricambi, qualit?? garantita e pagamenti sicuri. Un centro assistenza disponibile e competente a tua disposizione. <strong>Prezzi convenienti e spedizione in 24 ore.</strong></p>

                    <sql:query var="resultmarche_home">
                        SELECT
                            veicoli_marche.id AS id,
                            veicoli_marche.description AS description,
                            veicoli_marche_media.filename AS filename,
                            veicoli_marche_media.ext AS ext
                        FROM
                            motorinialternatori.veicoli_marche_visibility
                        INNER JOIN motorinialternatori.veicoli_marche_media ON veicoli_marche_visibility.id_marca = veicoli_marche_media.id_marca
                        INNER JOIN tecdoc.veicoli_marche ON veicoli_marche.id = veicoli_marche_visibility.id_marca AND veicoli_marche_visibility.visible_home = 1
                        INNER JOIN tecdoc.utility__veicoli_marche ON veicoli_marche.id = utility__veicoli_marche.id
                    </sql:query>
                    <div class="brands-box">
                        <c:forEach var="rowma" items="${resultmarche_home.rowsByIndex}">
                            <a class="brand" href="manufacturer.jsp?id_marca=${rowma[0]}" title="${rowma[1]}">
                                <c:set value="${rowma[2]}.${rowma[3]}" var="image" />
                                <img class="img-responsive p-3" src="${commons.storage("images/brands/", image)}" alt="${rowma[1]}" />
                                ${rowma[1]}
                            </a>
                        </c:forEach>
                    </div>

                    <p>Ogni marca auto ha il suo ricambio carrozzeria che si adatta perfettamente. La marca, il modello e l'anno di immatricolazione sono le uniche informazioni che ti occorrono per individuare il tuo componente di carrozzeria compatibile per la tua auto senza avere nessun dubbio!</p>
                    <a class="btn btn-primary" href="manufacturers.jsp">Tutte le marche</a>

                    <hr>

                    <sql:query var="resultmodelli_home">
                        SELECT
                            ANY_VALUE(veicoli_marche.id) AS id_marca,
                            ANY_VALUE(veicoli_modelli.id) AS id_modello,
                            ANY_VALUE(veicoli_tipi.id) AS id_tipo,
                            ANY_VALUE(categorie.id) AS id_categoria,
                            ANY_VALUE(veicoli_marche.description) AS description_marca,
                            ANY_VALUE(veicoli_modelli.description) AS description_modello,
                            ANY_VALUE(veicoli_tipi.description) AS description_tipo,
                            IF(veicoli_tipi._from = '0000-00-00', NULL, DATE_FORMAT(veicoli_tipi._from, '%m-%Y')) AS _from,
                            IF(veicoli_tipi._to = '0000-00-00', NULL, DATE_FORMAT(veicoli_tipi._to, '%m-%Y')) AS _to,
                            ANY_VALUE(IF(categorie_synonyms.description IS NOT NULL, categorie_synonyms.description, categorie.description)) AS description_categoria,
                            ANY_VALUE(articoli_veicoli.id_articolo),
                            ANY_VALUE(articoli_produttori.name),
                            ANY_VALUE(articoli.name),
                            ANY_VALUE(articles.description),
                            ANY_VALUE(articles.price),
                            ANY_VALUE(articles.price_wreck),
                            ANY_VALUE(articles.availability)
                        FROM
                            motorinialternatori.articoli_home
                        INNER JOIN tecdoc.categorie ON articoli_home.id_categoria = categorie.id
                        INNER JOIN tecdoc.veicoli_tipi ON veicoli_tipi.id = articoli_home.id_tipo
                        INNER JOIN tecdoc.veicoli_modelli ON veicoli_tipi.id_modello = veicoli_modelli.id
                        INNER JOIN tecdoc.veicoli_marche ON veicoli_modelli.id_marca = veicoli_marche.id
                        INNER JOIN tecdoc.utility__veicoli_marche ON veicoli_marche.id = utility__veicoli_marche.id
                        LEFT JOIN motorinialternatori.categorie_synonyms ON categorie_synonyms.id_categoria = categorie.id
                        INNER JOIN tecdoc.articoli_veicoli ON articoli_veicoli.link_target_id = articoli_home.id_tipo AND articoli_veicoli.id_categoria = articoli_home.id_categoria
                        INNER JOIN kuhner.articles ON articles.id = articoli_veicoli.id_articolo
                        LEFT JOIN tecdoc.articoli ON articoli.id = articles.id
                        LEFT JOIN tecdoc.articoli_produttori ON articoli.id_produttore = articoli_produttori.id
                        GROUP BY
                            articoli_home.id_tipo,
                            categorie.id
                        ORDER BY
                            categorie.id
                    </sql:query>

                    <c:set var="tipo_corrente" value="" />
                    <c:forEach var="rowmod" items="${resultmodelli_home.rowsByIndex}" varStatus="status">
                        <c:set var="id" value="${rowmod[10]}" />
                        <c:set var="price" value="${rowmod[14]}" /><!-- @TODO -->
                        <c:set var="description" value="${rowmod[13]}" />
                        <c:set var="interval">
                            <c:if test="${ not empty rowmod[7] or not empty rowmod[8] }">
                                <c:if test="${ not empty rowmod[7] }">dal ${rowmod[7]}</c:if>&nbsp;<c:if test="${ not empty rowmod[8] }">al ${rowmod[8]}</c:if>
                            </c:if>
                        </c:set>
                        <c:if test="${ !status.first && tipo_corrente != rowmod[3]}">
                            </div>
                        </c:if>
                        <c:if test="${ status.first || tipo_corrente != rowmod[3] }">
                            <h2><a href="category.jsp?id_categoria=${rowmod[3]}">${rowmod[9]}</a></h2>
                            <div class="row products-list">
                        </c:if>
                            <div class="col-sm-6 col-md-4 col-lg-3">
                                <div class="product-thumb">

                                    <sql:query var="resultartimages_home">
                                        SELECT
                                            filename,
                                            ext
                                        FROM
                                            motorinialternatori.articoli_media
                                        WHERE
                                            id_articolo = ?
                                        ORDER BY filename ASC
                                        LIMIT 1
                                        <sql:param value="${id}" />
                                    </sql:query>
                                    <c:forEach var="rowimg" items="${resultartimages_home.rowsByIndex}">
                                        <c:set var="image" value="${rowimg[0]}.${rowimg[1]}" />
                                    </c:forEach>
                                    <c:set var="resultartimages_home" value="" /><%-- svuoto la variabile per il loop --%>

                                    <c:if test="${not empty image}">
                                        <img src="${commons.storage("images/bundles/", image)}" alt="${id} ${description}">
                                    </c:if>
                                    <c:if test="${empty image}">
                                        <img src="${commons.storage("images/", "unavailable.jpg")}" alt="${id} ${description}">
                                    </c:if>
                                    <div class="details">
                                        <h6 class="name">${rowmod[9]} ${id}</h6>
                                        <p class="excerpt">
                                            <strong>${description}</strong><br/>
                                            Compatibile con <strong>${rowmod[4]} ${rowmod[5]} ${rowmod[6]} (${interval})</strong>
                                        </p>
                                        <span class="price">??? ${price}<small>iva esclusa</small></span>
                                        <a class="btn btn-primary" href="article.jsp?id_marca=${rowmod[0]}&id_modello=${rowmod[1]}&id_tipo=${rowmod[2]}&id_categoria=${rowmod[3]}&id_articolo=${id}">Vai al prodotto</a>
                                    </div>
                                </div>
                            </div>
                        <c:if test="${ status.last }">
                            </div>
                        </c:if>
                        <c:set var="tipo_corrente" value="${rowmod[3]}" />
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
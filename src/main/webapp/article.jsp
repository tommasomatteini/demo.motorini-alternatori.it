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
        <div class="container-fluid product">
            <div class="row">

                <%@ include file="/WEB-INF/partials/aside.jspf" %>

                <main class="col-lg-9" role="main">

                    <sql:query var="resulttipiricambi">
                        SELECT
                            t1.codice,
                            t1.descrizione_it,
                            t2.descrizione_prodotto_it
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
                            <c:if test="${rowmot[5] != null and rowmot[6] != null}">dal ${rowmot[5]} al ${rowmot[6]}</c:if><c:if test="${rowmot[5] != null and rowmot[6] == null}">dal ${rowmot[5]}</c:if>
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

                    <sql:query var="resultartloc">
                        SELECT
                            descrizione, prezzo, prezzo_carcassa, disponibilita
                        FROM
                            articoli
                        WHERE
                            codice = ?
                        <sql:param value="${param.article}" />
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

                    <h1 class="main-header">${category_description} ${param.article} per ${type_name_ext}</h1>
                    <p>${description}</p>
                    <div class="row product-main-info">
                        <div class="col-md-3 mb-4">
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
                                    <sql:param value="${param.article}" />
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

                                <h5>Art. ${param.article}</h5>
                                EAN:

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

                                <li class="list-group-item"><strong>Categoria prodotto:</strong> ${category_description}</li>
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
                                    <sql:param value="${param.article}" />
                                </sql:query>
                                <c:forEach var="rowcrit" items="${resultartcrit.rowsByIndex}">
                                    <li class="list-group-item"><strong>${rowcrit[0]}<c:if test="${not empty rowcrit[1]}">:</c:if></strong> ${rowcrit[1]}</li>
                                </c:forEach>

                            </ul>

                            <h2 class="h5 mt-4">Dettagli veicolo</h2>
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item"><strong>Veicolo:</strong> <a href="type.jsp?code=${param.code}">${type_name_ext} ${fuel_type} (HP: ${hp}, KW: ${kw})</a></li>
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

                            <span class="price-without-vat">Prezzo unitario <fmt:formatNumber value="${price}" pattern="0.00" type="currency" /></span>
                            <span class="price"><fmt:formatNumber value="${price + vat}" type="currency" currencySymbol="€" currencyCode="EUR" /></span>
                            <span class="vat-label">iva inclusa</span>
                            <a class="btn btn-primary btn-block text-center mb-2" href="#"><i class="fas fa-shopping-cart mr-2"></i> Acquista</a>

                        </div>
                    </div> <!-- .row -->

                    <h2 class="mb-3 mt-4">Descrizione prodotto</h2>
                    <c:set var="product_description" value="${fn:replace(product_description, '@MARCA@', brand)}" />
                    <c:set var="product_description" value="${fn:replace(product_description, '@MODELLO@', model)}" />
                    <c:set var="product_description" value="${fn:replace(product_description, '@MOTORIZZAZIONE@', type_name)}" />
                    <c:set var="product_description" value="${fn:replace(product_description, '@CODICEMOTORE@', engine_number)}" />
                    <c:set var="product_description" value="${fn:replace(product_description, '@ALIMENTAZIONE@', fuel_type)}" />
                    <p class="product-descr">${product_description}</p>

                    <h2 class="mb-3 mt-4">OEM</h2>
                    <sql:query var="resultartoem">
                        SELECT
                            oem,
                            marca_produttore_str
                        FROM
                            referenze
                        WHERE
                            articolo = ?
                        ORDER BY
                            oem ASC
                        <sql:param value="${param.article}" />
                    </sql:query>
                    <table class="table table-striped table-small">
                        <thead>
                        <tr>
                            <th scope="col">OEM</th>
                            <th scope="col">Produttore</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="rowoem" items="${resultartoem.rowsByIndex}">
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
                    <h2 class="mb-0 mt-4">Altri veicoli compatibili</h2>
                    <div class="row colors">

                        <sql:query var="resultcompatibili">
                            SELECT
                                marche_ext.descrizione,
                                modelli.descrizione_it,
                                modelli_ext.descrizione_estesa_it,
                                motorizzazioni.descrizione_it,
                                CAST(DATE_FORMAT(STR_TO_DATE(CONCAT(motorizzazioni.anno_inizio,1), '%Y%m%d'), '%m/%Y') AS CHAR) AS anno_inizio,
                                CAST(DATE_FORMAT(STR_TO_DATE(CONCAT(motorizzazioni.anno_fine,1), '%Y%m%d'), '%m/%Y') AS CHAR) AS anno_fine,
                                motorizzazioni.kw,
                                motorizzazioni.hp,
                                alimentazione.descrizione_it,
                                marche.descrizione,
                                modelli.descrizione_it,
                                marche.codice,
                                modelli.codice,
                                motorizzazioni.codice
                            FROM
                                articoli
                            INNER JOIN motorizzazioni_articoli ON articoli.codice = motorizzazioni_articoli.articolo
                            INNER JOIN motorizzazioni ON motorizzazioni_articoli.motorizzazione_s = motorizzazioni.codice
                            INNER JOIN modelli ON motorizzazioni.modello = modelli.codice
                            INNER JOIN modelli_ext ON modelli.codice = modelli_ext.codice
                            INNER JOIN marche ON modelli.marca = marche.codice
                            INNER JOIN marche_ext ON marche.codice = marche_ext.marca
                            INNER JOIN alimentazione ON motorizzazioni.alimentazione = alimentazione.codice
                            WHERE
                                articoli.codice = ?
                            ORDER BY
                                marche_ext.descrizione ASC,
                                modelli.descrizione_it ASC,
                                motorizzazioni.descrizione_it ASC
                            LIMIT 3
                            <sql:param value="${param.article}" />
                        </sql:query>

                        <c:forEach var="rowmot" items="${resultcompatibili.rowsByIndex}">

                            <c:set var="name" value="${rowmot[9]} ${rowmot[10]} ${rowmot[3]}" />
                            <c:set var="description" value="${rowmot[2]}" />
                            <c:set var="image" value="${rowmot[12]}.jpg" />
                            <c:set var="interval">
                                <c:if test="${rowmot[4] != null and rowmot[5] != null}">dal ${rowmot[4]} al ${rowmot[5]}</c:if><c:if test="${rowmot[4] != null and rowmot[5] == null}">dal ${rowmot[4]}</c:if>
                            </c:set>
                            <c:set var="hp" value="${rowmot[6]}" />
                            <c:set var="kw" value="${rowmot[7]}" />
                            <c:set var="fuel_type_txt" value="${rowmot[8]}" />

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
                            <div class="col-sm-6 col-xl-4 mt-3">
                                <div class="color">
                                    <h5 class="name"><a href="article.jsp?manufacturer=${rowmot[11]}&model=${rowmot[12]}&code=${rowmot[13]}&category=${param.category}&article=${param.article}">${name} <small>(HP ${hp}, KW ${kw})</small></a></h5>
                                    <div class="media">
                                        <img class="img-responsive" src="${commons.storage("images/models/", image)}">
                                        <div class="media-body">
                                            <p class="mb-1">Periodo: <strong>${interval}</strong></p>
                                            <p class="mb-1">Alimentazione: <strong>${fuel_type_txt}</strong></p>
                                            <p class="mb-1">Codice motore: <strong>${engine_number}</strong></p>
                                        </div>
                                    </div>
                                </div> <!-- .color -->
                            </div> <!-- .col -->
                        </c:forEach>

                    </div> <!-- .row.colors -->

                    <sql:query var="resultcompatibili">
                        SELECT
                            marche_ext.descrizione,
                            modelli.descrizione_it,
                            modelli_ext.descrizione_estesa_it,
                            motorizzazioni.descrizione_it,
                            CAST(DATE_FORMAT(STR_TO_DATE(CONCAT(motorizzazioni.anno_inizio,1), '%Y%m%d'), '%m/%Y') AS CHAR) AS anno_inizio,
                            CAST(DATE_FORMAT(STR_TO_DATE(CONCAT(motorizzazioni.anno_fine,1), '%Y%m%d'), '%m/%Y') AS CHAR) AS anno_fine,
                            motorizzazioni.kw,
                            motorizzazioni.hp,
                            alimentazione.descrizione_it,
                            marche.descrizione,
                            modelli.descrizione_it,
                            marche.codice,
                            modelli.codice,
                            motorizzazioni.codice
                        FROM
                            articoli
                        INNER JOIN motorizzazioni_articoli ON articoli.codice = motorizzazioni_articoli.articolo
                        INNER JOIN motorizzazioni ON motorizzazioni_articoli.motorizzazione_s = motorizzazioni.codice
                        INNER JOIN modelli ON motorizzazioni.modello = modelli.codice
                        INNER JOIN modelli_ext ON modelli.codice = modelli_ext.codice
                        INNER JOIN marche ON modelli.marca = marche.codice
                        INNER JOIN marche_ext ON marche.codice = marche_ext.marca
                        INNER JOIN alimentazione ON motorizzazioni.alimentazione = alimentazione.codice
                        WHERE
                            articoli.codice = ?
                        ORDER BY
                            marche_ext.descrizione ASC,
                            modelli.descrizione_it ASC,
                            motorizzazioni.descrizione_it ASC
                        LIMIT 999999
                        OFFSET 3
                        <sql:param value="${param.article}" />
                    </sql:query>
                    <c:if test="${resultcompatibili.rowCount > 0}">
                        <a class="show-all-colors" href="#">Visualizza tutti i veicoli compatibili<i class="fas fa-arrow-down ml-1"></i></a>
                        <div class="hidden-colors">
                            <div class="row colors">

                                <c:forEach var="rowmot" items="${resultcompatibili.rowsByIndex}">

                                    <c:set var="name" value="${rowmot[9]} ${rowmot[10]} ${rowmot[3]}" />
                                    <c:set var="description" value="${rowmot[2]}" />
                                    <c:set var="image" value="${rowmot[12]}.jpg" />
                                    <c:set var="interval">
                                        <c:if test="${rowmot[4] != null and rowmot[5] != null}">dal ${rowmot[4]} al ${rowmot[5]}</c:if><c:if test="${rowmot[4] != null and rowmot[5] == null}">dal ${rowmot[4]}</c:if>
                                    </c:set>
                                    <c:set var="hp" value="${rowmot[6]}" />
                                    <c:set var="kw" value="${rowmot[7]}" />
                                    <c:set var="fuel_type_txt" value="${rowmot[8]}" />

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
                                    <div class="col-sm-6 col-xl-4 mt-3">
                                        <div class="color">
                                            <h5 class="name"><a href="article.jsp?manufacturer=${rowmot[11]}&model=${rowmot[12]}&code=${rowmot[13]}&category=${param.category}&article=${param.article}">${name} <small>(HP ${hp}, KW ${kw})</small></a></h5>
                                            <div class="media">
                                                <img class="img-responsive" src="${commons.storage("images/models/", image)}">
                                                <div class="media-body">
                                                    <p class="mb-1">Periodo: <strong>${interval}</strong></p>
                                                    <p class="mb-1">Alimentazione: <strong>${fuel_type_txt}</strong></p>
                                                    <p class="mb-1">Codice motore: <strong>${engine_number}</strong></p>
                                                </div>
                                            </div>
                                        </div> <!-- .color -->
                                    </div> <!-- .col -->
                                </c:forEach>

                            </div> <!-- .row.colors -->
                        </div> <!-- .hidden-colors -->
                    </c:if>

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
                            motorizzazioni_articoli.motorizzazione_s,
                            motorizzazioni_articoli.articolo_generico,
                            articoli.codice,
                            articoli.descrizione,
                            articoli.prezzo,
                            articoli.prezzo_carcassa,
                            articoli.disponibilita
                        FROM
                            motorizzazioni_articoli
                        INNER JOIN articoli on articoli.codice = motorizzazioni_articoli.articolo
                        INNER JOIN tipo_ricambi_generico ON motorizzazioni_articoli.articolo_generico = tipo_ricambi_generico.codice
                        INNER JOIN tipo_ricambi_generico_descrizione ON tipo_ricambi_generico.codice = tipo_ricambi_generico_descrizione.tipo_ricambi_generico
                        INNER JOIN motorizzazioni ON motorizzazioni_articoli.motorizzazione_s = motorizzazioni.codice
                        INNER JOIN modelli ON motorizzazioni.modello = modelli.codice
                        INNER JOIN modelli_ext ON modelli.codice = modelli_ext.codice
                        INNER JOIN marche ON modelli.marca = marche.codice
                        INNER JOIN marche_ext ON marche.codice = marche_ext.marca
                        WHERE
                            motorizzazioni_articoli.motorizzazione_s = ? AND
                            motorizzazioni_articoli.articolo_generico = ? AND
                            articoli.fornitore = '4528' AND
                            articoli.codice <> ?
                        LIMIT 4
                        <sql:param value="${param.code}" />
                        <sql:param value="${param.category}" />
                        <sql:param value="${param.article}" />
                    </sql:query>
                    <c:if test="${resultmodelli.rowCount > 0}">
                        <hr>
                        <h2 class="mb-0">Prodotti simili</h2>
                        <div class="row products-list">

                            <c:forEach var="rowmot" items="${resultmodelli.rowsByIndex}" varStatus="status">
                                <div class="col-sm-6 col-md-4 col-lg-3 mt-3">
                                    <div class="product-thumb">
                                        <c:set var="id" value="${rowmot[10]}" />
                                        <c:set var="price" value="${rowmot[12]}" />
                                        <c:set var="description" value="${rowmot[11]}" />
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
                                                Compatibile con ${rowmot[0]} ${rowmot[1]} ${rowmot[2]} (${fn:substring(rowmot[3], 4, 7)}-${fn:substring(rowmot[3], 0, 4)}<c:if test="${!empty rowmot[4]}">/${fn:substring(rowmot[4], 4, 7)}-${fn:substring(rowmot[4], 0, 4)})</c:if>
                                            </p>
                                            <span class="price">€ 0,00<small>iva esclusa</small></span>
                                            <a class="btn btn-primary" href="article.jsp?manufacturer=${param.manifacturer}&model=${param.model}&code=${param.code}&category=${param.category}&article=${id}">Vai al prodotto</a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>

                        </div><!-- .row.products-list -->
                    </c:if>

                </main>

            </div>
        </div>
    </layout:put>
</layout:extends>
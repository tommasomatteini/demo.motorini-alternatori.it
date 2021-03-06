<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ include file="/WEB-INF/core/commons.jspf" %>
<%@ include file="/WEB-INF/core/sql.jspf" %>
<%@ include file="/WEB-INF/core/routes.jspf" %>

<%@ taglib prefix="utils" uri="/WEB-INF/tlds/utils.tld" %>

<utils:hashMap var="breadcrumbList">
    <utils:hashMapItem key="Marche auto" value="manufacturers.jsp" />
</utils:hashMap>

<layout:extends name="base">
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

                    <h1>Tutte le marche</h1>
                    <p>Ogni marca auto ha il suo ricambio carrozzeria che si adatta perfettamente. La marca, il modello e l'anno di immatricolazione sono le uniche informazioni che ti occorrono per individuare il tuo componente di carrozzeria compatibile per la tua auto senza avere nessun dubbio!</p>

                    <sql:query var="resultmarche">
                        SELECT
                            veicoli_marche.id AS id,
                            veicoli_marche.description AS description,
                            veicoli_marche_media.filename AS filename,
                            veicoli_marche_media.ext AS ext
                        FROM
                            motorinialternatori.veicoli_marche_visibility
                        JOIN motorinialternatori.veicoli_marche_media ON veicoli_marche_visibility.id_marca = veicoli_marche_media.id_marca
                        JOIN tecdoc.veicoli_marche ON veicoli_marche.id = veicoli_marche_visibility.id_marca AND veicoli_marche_visibility.visible = 1
                        INNER JOIN ( SELECT id, id_marca FROM tecdoc.veicoli_modelli GROUP BY id_marca) AS veicoli_modelli ON veicoli_marche.id = veicoli_modelli.id_marca
                        INNER JOIN ( SELECT id, id_modello FROM tecdoc.veicoli_tipi GROUP BY id_modello ) AS veicoli_tipi ON veicoli_tipi.id_modello = veicoli_modelli.id
                        WHERE EXISTS( SELECT article_id FROM kuhner.articles_vehicles INNER JOIN tecdoc.articoli_categorie ON articoli_categorie.id_articolo = articles_vehicles.article_id INNER JOIN motorinialternatori.categorie_visibility ON ( articoli_categorie.id_categoria = categorie_visibility.id_categoria AND categorie_visibility.visible = 1 ) WHERE veicoli_tipi.id = articles_vehicles.link_target_id )
                        ORDER BY veicoli_marche.description
                    </sql:query>

                    <div class="brands-box">
                        <c:forEach var="row" items="${resultmarche.rowsByIndex}">
                            <a class="brand" href="manufacturer.jsp?id_marca=${row[0]}" title="${row[1]}">
                                <c:set value="${fn:replace(fn:toLowerCase(row[1]),' ','-')}.png" var="image" />
                                <img class="img-responsive p-3" src="${commons.storage("images/brands/", image)}" alt="${row[1]}" />
                                ${row[1]}
                            </a>
                        </c:forEach>
                    </div>

                </main>

            </div> <!-- .row -->
        </div> <!-- .container-fluid -->
    </layout:put>
</layout:extends>
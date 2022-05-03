<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

                    <cache:results lang="${lang}" name="resultmarche" var="resultmarche" />
                    <c:if test="${resultmarche == null}">
                        <pre>query!</pre>
                        <sql:query var="resultmarche">
                            SELECT
                                m1.codice,
                                m3.descrizione
                            FROM
                                marche m1
                            INNER JOIN marche_ext m3 ON m1.codice = m3.marca
                            WHERE
                                m3.visibile = 'Y'
                            ORDER BY
                                descrizione
                        </sql:query>
                        <cache:results lang="${lang}" name="resultmarche" value="${resultmarche}" />
                    </c:if>

                    <div class="brands-box">
                        <c:forEach var="row" items="${resultmarche.rowsByIndex}">
                            <a class="brand" href="manufacturer.jsp?id=${row[0]}" title="${row[1]}">
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
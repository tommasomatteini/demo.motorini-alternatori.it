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
                            motorizzazioni.anno_inizio,
                            motorizzazioni.anno_fine,
                            motorizzazioni.kw,
                            motorizzazioni.hp,
                            motorizzazioni.codice,
                            alimentazione.descrizione_it,
                            marche.descrizione,
                            m2.descrizione_it,
                            motorizzazioni.descrizione_it,
                            marche.descrizione,
                            m2.descrizione_fr,
                            motorizzazioni.descrizione_fr
                        FROM
                            marche
                        INNER JOIN modelli ON marche.codice = modelli.marca
                        INNER JOIN modelli_ext m2 ON modelli.codice = m2.codice
                        INNER JOIN motorizzazioni ON modelli.codice = motorizzazioni.modello AND motorizzazioni.codice = ?
                        INNER JOIN alimentazione ON motorizzazioni.alimentazione = alimentazione.codice
                        ORDER BY
                            motorizzazioni.descrizione_it ASC
                        <sql:param value="${param.motorizzazione}" />
                    </sql:query>
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
                        <sql:param value="${param.motorizzazione}" />
                    </sql:query>



                </main>

            </div>
        </div>

    </layout:put>
</layout:extends>
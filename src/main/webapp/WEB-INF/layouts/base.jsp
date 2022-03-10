<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/commons.jspf" %>
<%@ include file="/WEB-INF/sql.jspf" %>
<%@ include file="/WEB-INF/routes.jspf" %>
<!doctype html>
<html lang="${lang}">
<head>

    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />

    <meta name="owner" content="RAS - Ricambi Auto Store s.r.l.">
    <meta name="author" content="E-COMIT Srl">

    <layout:block name="head">
        <meta name="description" content="{{description}}">
        <meta name="keywords" content="{{keywords}}">
        <title>Motorini Alternatori</title>
    </layout:block>

    <link rel="dns-prefetch" href="" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preload" href="https://fonts.googleapis.com/css?family=Open+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;0,800;1,300;1,400;1,500;1,600;1,700;1,800&display=swap&subset=latin-ext" as="style" />
    <link rel="preload" href="https://fonts.googleapis.com/icon?family=Material+Icons" as="style" />
    <link rel="preload" href="${commons.assets("css/bootstrap.min.css")}" as="style" />
    <link rel="preload" href="${commons.assets("css/font-awesome/css/all.min.css")}" as="style" />
    <link rel="preload" href="${commons.assets("css/owlcarousel/owl.carousel.min.css")}" as="style" />
    <link rel="preload" href="${commons.assets("css/owlcarousel/owl.theme.default.min.css")}" as="style" />
    <link rel="preload" href="${commons.assets("css/hamburgers.min.css")}" as="style" />
    <link rel="preload" href="${commons.assets("css/styles.css")}" as="style" />

    <link rel="icon" href="${commons.assets("favicon.ico")}" />

    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Open+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;0,800;1,300;1,400;1,500;1,600;1,700;1,800&display=swap&subset=latin-ext" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons" />
    <link rel="stylesheet" href="${commons.assets("css/bootstrap.min.css")}" />
    <link rel="stylesheet" href="${commons.assets("css/font-awesome/css/all.min.css")}" />
    <link rel="stylesheet" href="${commons.assets("css/owlcarousel/owl.carousel.min.css")}" />
    <link rel="stylesheet" href="${commons.assets("css/owlcarousel/owl.theme.default.min.css")}" />
    <link rel="stylesheet" href="${commons.assets("css/hamburgers.min.css")}" />
    <link rel="stylesheet" href="${commons.assets("css/styles.css")}" />

</head>

<body>

    <%@ include file="./../partials/header.jspf" %>

    <c:if test="${!is_home}">
        <%@ include file="./../partials/breadcrumb.jspf" %>
    </c:if>

    <layout:block name="contents"></layout:block>

    <footer class="footer">
        <div class="container-fluid">
            <div class="row">

                <div class="col-sm-6 col-lg-3 mb-3">
                    <a href="/" class="logo push-bottom">
                        <img height="65" alt="" src="${commons.assets("img/logo-footer.png")}" />
                    </a>
                    <ul class="contacts">
                        <li><i class="fas fa-map-marker-alt"></i> <strong>Indirizzo:</strong> Ricambi Auto Store s.r.l., Viale Magenta, 1C - 42123 - Reggio Emilia (RE)</li>
                        <li><i class="fas fa-phone-alt"></i> <strong>Tel:</strong> <a href="tel:+393346370072">+39 334 637 0072</a></li>
                        <li><i class="fas fa-envelope"></i></i> <strong>Email:</strong> <a href="mailto:info@motorini-alternatori.it">info@motorini-alternatori.it</a></li>
                        <li><i class="fas fa-building"></i> <strong>Partita IVA:</strong> IT02707520355</li>
                    </ul>
                    <div>
                        <h5 class="payments">Pagamenti sicuri</h5>
                        <img src="${commons.assets("img/cards.svg")}" alt="Carte di credito accettate">
                    </div>
                </div> <!-- .col -->

                <div class="col-sm-6 col-lg-3">
                    <h4 class="title mt-4 mt-md-0">Informazioni Utili</h4>
                    <nav class="nav flex-column infos">
                        <a title="Chi Siamo" href="#">Chi Siamo</a>
                        <a title="Termini e Condizioni" href="#">Termini e Condizioni</a>
                        <a title="Site Map" href="#">Site Map</a>
                        <a title="Contatti" href="#">Contatti</a>
                        <a title="Informativa Privacy" href="#" target="_blank">Informativa Privacy</a>
                        <a title="Cookie policy" href="#" target="_blank">Cookie policy</a>
                    </nav>
                </div> <!-- .col -->

                <div class="col-sm-12 col-lg-6 d-none d-lg-block"> <!-- hide on <768px -->
                    <h4 class="title mt-4 mt-md-0">Ultime Offerte</h4>
                    <div class="row">
                        <!--
                        <a class="col product-thumb" href="https://www.vernicispray.com/132243IT/vernice-nitro-spray-opaca-in-colori-ral-ral-6005-verde-muschio.jsp" title="RAL 6005  VERDE MUSCHIO">
                            <img src="samples/vernice-spray-nitro-opaco.jpg" alt="Vernice Nitro spray Opaca in tutti i colori RAL Ral 6005  verde muschio">
                            <img class="finish" src="samples/ral_6005.jpg" alt="Ral 6005  verde muschio">
                            Vernice Nitro spray Opaca in tutti i colori RAL<br>
                            Ral 6005  verde muschio
                        </a>
                        -->
                    </div> <!-- .row -->
                    <a class="view-more" href="#">Vedi Ancora <i class="fas fa-arrow-right"></i></a>
                </div> <!-- .col -->

            </div> <!-- .row -->
        </div> <!-- .container-fluid -->

        <div class="credits">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-sm-5 mb-3 text-center text-sm-left">
                        <p class="copy">Copyright © 2022. All Rights Reserved.</p>
                    </div>
                    <div class="col-sm-2 mb-3 text-center">
                        Credits: <a href="https://www.e-comit.it" title="E-COMIT">E-COMIT</a>
                    </div>
                    <div class="col-sm-5 mb-3 text-center text-sm-right">
                        <a class="social-icon" href="https://www.facebook.com/Ricambiautoweb.it/" target="_blank" title="Facebook"><i class="fab fa-facebook-f"></i></a>
                        <a class="social-icon" href="https://www.instagram.com/ricambi_auto_store/" target="_blank" title="Instagram"><i class="fab fa-instagram"></i></a>
                    </div>
                </div> <!-- .row -->
            </div> <!-- .container-fluid -->
        </div> <!-- .credits -->

    </footer>

    <div class="blackout"></div>

    <script src="${commons.assets("js/jquery-3.4.1.min.js")}"></script>
    <script src="${commons.assets("js/bootstrap.bundle.min.js")}"></script>
    <script src="${commons.assets("js/owl.carousel.min.js")}"></script>
    <script src="${commons.assets("js/scripts.js")}"></script>

</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="sneakpeak.model.Utente" %>
        <style>
            /* Stili generali di base validi per tutto il sito */
            body {
                font-family: Arial, sans-serif;
                background-color: #FFFFFF;
                color: #333;
                margin: 0;
                padding: 0;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
            }

            /* Stile dell'intestazione */
            .header {
                background-color: #FFFFFF;
                color: #000;
                padding: 15px 20px 5px 20px;
                text-align: center;
            }

            .header h1 {
                margin: 0;
                font-size: 32px;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
            }

            /* Stile della barra di navigazione */
            .nav {
                background-color: #FFFFFF;
                border-bottom: 1px solid #eaeaea;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 10px 40px;
            }

            .nav-left,
            .nav-right {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .nav a {
                color: #333;
                text-decoration: none;
                font-weight: bold;
                font-size: 14px;
                transition: 0.2s;
            }

            .nav a:hover {
                color: #000;
            }

            .nav-separator {
                color: #ccc;
                font-size: 14px;
            }

            /* Pulsanti Header */
            .btn-nav {
                padding: 0 10px !important;
                border-radius: 4px;
                font-weight: bold;
                font-size: 13px !important;
                transition: 0.2s;
                min-width: 100px;
                /* Larghezza uniforme */
                height: 32px;
                /* Altezza fissa uniforme ridotta */
                display: inline-flex;
                align-items: center;
                justify-content: center;
                box-sizing: border-box;
                text-decoration: none;
            }

            .btn-green {
                background-color: #00FF00;
                color: #000 !important;
                border: 1px solid #00cc00;
            }

            .btn-white {
                background-color: #fff;
                color: #000 !important;
                border: 1px solid #333;
            }

            .btn-dark {
                background-color: #333;
                color: #fff !important;
                border: 1px solid #333;
            }

            /* Stile per i banner di notifica di successo */
            .toast-banner {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
                padding: 12px 20px;
                margin: 15px auto;
                max-width: 800px;
                border-radius: 6px;
                text-align: center;
                font-weight: bold;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
                animation: fadeInDown 0.4s ease-out;
            }

            @keyframes fadeInDown {
                from {
                    opacity: 0;
                    transform: translateY(-15px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* --- STILI BARRA DI RICERCA AJAX --- */
            .search-container {
                position: relative;
                padding: 0;
                /* Rimossa imbottitura che rompe il flex */
                z-index: 9999;
                flex-grow: 1;
                /* Permette alla barra di prendere spazio al centro */
                max-width: 400px;
                text-align: center;
            }

            .search-input {
                padding: 10px 15px;
                width: 100%;
                box-sizing: border-box;
                border-radius: 20px;
                border: 1px solid #ccc;
                font-size: 14px;
            }

            .search-input:focus {
                outline: none;
                border-color: #39FF14;
                box-shadow: 0 0 5px rgba(57, 255, 20, 0.5);
            }

            .search-results {
                display: none;
                /* Nascosto di default */
                position: absolute;
                top: 50px;
                left: 20px;
                right: 20px;
                background-color: white;
                box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
                z-index: 10000;
                border-radius: 4px;
                max-height: 300px;
                overflow-y: auto;
                box-sizing: border-box;
            }

            .search-result-item {
                color: black !important;
                padding: 10px;
                text-decoration: none;
                display: flex;
                align-items: center;
                border-bottom: 1px solid #eee;
                text-align: left;
                width: 100%;
                box-sizing: border-box;
            }

            .search-result-item:hover {
                background-color: #f1f1f1 !important;
                color: black !important;
            }

            .search-img {
                width: 40px;
                height: 40px;
                object-fit: cover;
                margin-right: 10px;
                border-radius: 4px;
            }

            .search-info {
                display: flex;
                flex-direction: column;
            }

            .search-name {
                font-size: 14px;
                font-weight: bold;
            }

            .search-price {
                font-size: 12px;
                color: #2F4F4F;
            }

            @media screen and (max-width: 768px) {
                .header h1 {
                    font-size: 24px;
                }

                .nav {
                    flex-direction: column;
                    padding: 10px;
                    gap: 15px;
                }

                .nav-right {
                    flex-wrap: wrap;
                    justify-content: center;
                    order: 1;
                }

                .nav-left {
                    flex-wrap: wrap;
                    justify-content: center;
                    order: 2;
                }

                .search-container {
                    max-width: 100%;
                    width: 100%;
                    order: 3;
                }

                .nav-separator {
                    display: none;
                }
            }

            /* --- DROPDOWN CATEGORIE --- */
            .dropdown {
                position: relative;
                display: inline-block;
            }

            .dropdown .dropbtn {
                font-size: 16px;
                border: none;
                outline: none;
                color: #333;
                padding: 14px 20px;
                background-color: inherit;
                font-family: inherit;
                margin: 0;
                cursor: pointer;
                text-decoration: none;
                display: block;
            }

            .nav a:hover,
            .dropdown:hover .dropbtn {
                background-color: #ddd;
                color: black;
            }

            .dropdown-content {
                display: none;
                position: absolute;
                background-color: #f9f9f9;
                min-width: 150px;
                white-space: nowrap;
                box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
                z-index: 10005;
                /* Più alto della search bar (9999) */
                top: 100%;
                /* Si attacca perfettamente sotto */
                left: 0;
            }

            .dropdown-content a {
                color: black;
                padding: 12px 16px;
                text-decoration: none;
                display: block;
                text-align: left;
            }

            .dropdown-content a:hover {
                background-color: #ddd;
                color: black;
            }

            .dropdown:hover .dropdown-content {
                display: block;
            }
        </style>

        <div class="header">
            <a href="home" style="text-decoration: none; color: inherit; display: inline-block;">
                <h1 style="display: flex; align-items: center; justify-content: center; gap: 5px;">
                    <img src="img/logo.png" alt="Logo" style="height: 38px; mix-blend-mode: multiply; margin-right: 2px;">
                    SneakPeak
                </h1>
            </a>
        </div>

        <div class="nav">
            <!-- PARTE SINISTRA: Menu e Link -->
            <div class="nav-left">
                <div class="dropdown">
                    <a href="javascript:void(0);" class="dropbtn" style="font-size: 20px; padding: 5px 10px;">☰</a>
                    <div class="dropdown-content">
                        <% sneakpeak.model.CategoriaDAO catDAO=new sneakpeak.model.CategoriaDAO();
                            java.util.List<sneakpeak.model.Categoria> categorie = catDAO.doRetrieveAll();
                            if(categorie != null) {
                            for (sneakpeak.model.Categoria cat : categorie) {
                            %>
                            <a href="home?categoria=<%= cat.getIdCategoria() %>">
                                <%= cat.getNome() %>
                            </a>
                            <% } } %>
                    </div>
                </div>
                <a href="home">Home</a>
                <span class="nav-separator">|</span>
                <a href="chiSiamo.jsp">Chi siamo</a>
                <span class="nav-separator">|</span>
                <a href="aiuto.jsp">Aiuto</a>
                <% 
                    sneakpeak.model.Utente uAdmin = (sneakpeak.model.Utente) session.getAttribute("utenteLoggato");
                    if (uAdmin != null && "ADMIN".equalsIgnoreCase(uAdmin.getTipo())) { 
                %>
                    <span class="nav-separator">|</span>
                    <a href="adminDashboard.jsp" style="color: #d9534f; font-weight: bold;">Area Admin</a>
                <% } %>
            </div>

            <!-- PARTE CENTRALE: BARRA DI RICERCA AJAX -->
            <div class="search-container">
                <input type="text" id="searchInput" class="search-input" placeholder="Cerca..." autocomplete="off">
                <div id="searchResults" class="search-results">
                    <!-- I risultati verranno inseriti qui dal JavaScript -->
                </div>
            </div>

            <!-- PARTE DESTRA: Pulsanti e Utente -->
            <div class="nav-right">
                <% 
                    // Recuperiamo l'utente loggato dalla sessione 
                    Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato"); 
                    if (utenteLoggato != null) { 
                %>
                    <a href="profilo" class="btn-nav btn-white">Ciao, <%= utenteLoggato.getNome() %></a>
                    <a href="logout" class="btn-nav btn-dark"
                        style="background-color: #d9534f; border-color: #d9534f;">Logout</a>
                    <% } else { %>
                        <a href="registrazione.jsp" class="btn-nav btn-green">Iscriviti</a>
                        <a href="login.jsp" class="btn-nav btn-white">Accedi</a>
                        <% } %>
                            <a href="carrello.jsp" class="btn-nav btn-dark">Carrello</a>
            </div>
        </div>

        <% String msgSuccesso=(String) session.getAttribute("messaggioSuccesso"); if (msgSuccesso !=null) { %>
            <div class="toast-banner" id="successToast">
                <%= msgSuccesso %>
            </div>
            <script>
                // Nascondi automaticamente la notifica dopo 4 secondi con effetto dissolvenza
                setTimeout(function () {
                    var toast = document.getElementById("successToast");
                    if (toast) {
                        toast.style.transition = "opacity 0.6s ease";
                        toast.style.opacity = "0";
                        setTimeout(function () {
                            toast.remove();
                        }, 600);
                    }
                }, 4000);
            </script>
            <% session.removeAttribute("messaggioSuccesso"); } %>

                <!-- JAVASCRIPT PER LA RICERCA AJAX -->
                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        const searchInput = document.getElementById('searchInput');
                        const searchResults = document.getElementById('searchResults');

                        // Quando l'utente digita qualcosa
                        searchInput.addEventListener('input', function () {
                            const query = searchInput.value.trim();

                            if (query.length < 2) {
                                searchResults.style.display = 'none';
                                return; // Non cerchiamo se ha scritto meno di 2 lettere
                            }

                            // Chiamata AJAX con Fetch API (Requisito Checklist)
                            fetch('ricercaAjax?q=' + encodeURIComponent(query))
                                .then(response => response.json()) // Chiediamo di convertire la risposta in JSON
                                .then(data => {
                                    searchResults.innerHTML = ''; // Puliamo i vecchi risultati

                                    if (data.length > 0) {
                                        // Creiamo l'HTML per ogni prodotto trovato
                                        data.forEach(prodotto => {
                                            const a = document.createElement('a');
                                            a.href = 'dettaglio?id=' + prodotto.id;
                                            a.className = 'search-result-item';

                                            a.innerHTML =
                                                '<img src="' + prodotto.immagine + '" class="search-img" alt="Foto prodotto">' +
                                                '<div class="search-info">' +
                                                '<span class="search-name">' + prodotto.nome + '</span>' +
                                                '<span class="search-price">€ ' + prodotto.prezzo.toFixed(2) + '</span>' +
                                                '</div>';

                                            searchResults.appendChild(a);
                                        });
                                        searchResults.style.display = 'block'; // Mostriamo la tendina
                                    } else {
                                        // Nessun risultato
                                        searchResults.innerHTML = '<div style="padding: 10px; color: #666; font-size: 14px;">Nessun prodotto trovato.</div>';
                                        searchResults.style.display = 'block';
                                    }
                                })
                                .catch(error => console.error('Errore durante la ricerca:', error));
                        });

                        // Nascondi la tendina se si clicca fuori
                        document.addEventListener('click', function (event) {
                            if (!searchInput.contains(event.target) && !searchResults.contains(event.target)) {
                                searchResults.style.display = 'none';
                            }
                        });
                    });
                </script>
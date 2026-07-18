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
            }

            /* Stile dell'intestazione */
            .header {
                background-color: #2F4F4F;
                color: #39FF14;
                padding: 20px;
                text-align: center;
            }

            /* Stile della barra di navigazione */
            .nav {
                background-color: #1a1a1a;
                overflow: hidden;
            }

            .nav a {
                float: left;
                display: block;
                color: white;
                text-align: center;
                padding: 14px 20px;
                text-decoration: none;
                font-weight: bold;
            }

            .nav a:hover {
                background-color: #39FF14;
                /* Hover verde neon */
                color: black;
            }

            /* Spinge i link a destra */
            .nav-right {
                float: right !important;
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
                box-shadow: 0 4px 6px rgba(0,0,0,0.05);
                animation: fadeInDown 0.4s ease-out;
            }

            @keyframes fadeInDown {
                from { opacity: 0; transform: translateY(-15px); }
                to { opacity: 1; transform: translateY(0); }
            }

            /* --- STILI BARRA DI RICERCA AJAX --- */
            .search-container {
                position: relative;
                float: left;
                padding: 10px 20px;
            }
            .search-input {
                padding: 6px;
                width: 250px;
                border-radius: 4px;
                border: 1px solid #ccc;
            }
            .search-input:focus {
                outline: none;
                border-color: #39FF14;
                box-shadow: 0 0 5px rgba(57, 255, 20, 0.5);
            }
            .search-results {
                display: none; /* Nascosto di default */
                position: absolute;
                top: 45px;
                left: 20px;
                background-color: white;
                min-width: 250px;
                box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
                z-index: 1000;
                border-radius: 4px;
                max-height: 300px;
                overflow-y: auto;
            }
            .search-result-item {
                color: black;
                padding: 10px;
                text-decoration: none;
                display: flex;
                align-items: center;
                border-bottom: 1px solid #eee;
            }
            .search-result-item:hover {
                background-color: #f1f1f1;
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

            /* --- RESPONSIVE DESIGN (Media Query) --- */
            @media screen and (max-width: 768px) {
                .nav a {
                    float: none;
                    display: block;
                    width: 100%;
                    text-align: left;
                    box-sizing: border-box;
                }
                .nav-right {
                    float: none !important;
                }
                .search-container {
                    float: none;
                    display: block;
                    width: 100%;
                    box-sizing: border-box;
                    padding: 10px;
                }
                .search-input {
                    width: 100%;
                    box-sizing: border-box;
                }
                .search-results {
                    width: calc(100% - 20px);
                    left: 10px;
                }
                
                /* Classi di utilità per tabelle responsive in altre pagine */
                .table-responsive {
                    overflow-x: auto;
                    display: block;
                    width: 100%;
                }
            }
        </style>

        <div class="header">
            <h1>SneakPeak</h1>
            <p>Il tuo punto di riferimento per lo streetwear</p>
        </div>

        <div class="nav">
            <a href="home">Catalogo Prodotti</a>
            <a href="carrello.jsp">Carrello</a>

            <!-- BARRA DI RICERCA AJAX -->
            <div class="search-container">
                <input type="text" id="searchInput" class="search-input" placeholder="Cerca una sneaker..." autocomplete="off">
                <div id="searchResults" class="search-results">
                    <!-- I risultati verranno inseriti qui dal JavaScript -->
                </div>
            </div>

    <%
        // Recuperiamo l'utente loggato dalla sessione
        Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");
        if (utenteLoggato != null) {
    %>
            <a href="logout" class="nav-right">Logout</a>
            <a href="profilo" class="nav-right">Ciao, <%= utenteLoggato.getNome() %></a>
    <%
        } else {
    %>
            <a href="registrazione.jsp" class="nav-right">Registrati</a>
            <a href="login.jsp" class="nav-right">Login</a>
    <%
        }
    %>
    <% 
    sneakpeak.model.Utente uHeader = (sneakpeak.model.Utente) session.getAttribute("utenteLoggato"); 
    if (uHeader != null && "ADMIN".equalsIgnoreCase(uHeader.getTipo())) { 
    %>
    <a href="adminDashboard.jsp" style="color: #d9534f; font-weight: bold;">[⚙️ Area Admin]</a>
    <%   }
    %>
        </div>

        <%
            String msgSuccesso = (String) session.getAttribute("messaggioSuccesso");
            if (msgSuccesso != null) {
        %>
            <div class="toast-banner" id="successToast">
                <%= msgSuccesso %>
            </div>
            <script>
                // Nascondi automaticamente la notifica dopo 4 secondi con effetto dissolvenza
                setTimeout(function() {
                    var toast = document.getElementById("successToast");
                    if (toast) {
                        toast.style.transition = "opacity 0.6s ease";
                        toast.style.opacity = "0";
                        setTimeout(function() {
                            toast.remove();
                        }, 600);
                    }
                }, 4000);
            </script>
        <%
                session.removeAttribute("messaggioSuccesso");
            }
        %>

        <!-- JAVASCRIPT PER LA RICERCA AJAX -->
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const searchInput = document.getElementById('searchInput');
                const searchResults = document.getElementById('searchResults');

                // Quando l'utente digita qualcosa
                searchInput.addEventListener('input', function() {
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
                document.addEventListener('click', function(event) {
                    if (!searchInput.contains(event.target) && !searchResults.contains(event.target)) {
                        searchResults.style.display = 'none';
                    }
                });
            });
        </script>
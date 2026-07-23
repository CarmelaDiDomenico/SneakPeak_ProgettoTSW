<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="sneakpeak.model.Utente" %>
        <link rel="stylesheet" href="css/header.css">

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
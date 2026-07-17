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
                from {
                    opacity: 0;
                    transform: translateY(-15px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
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
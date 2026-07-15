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
        </div>
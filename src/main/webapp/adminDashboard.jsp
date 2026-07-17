<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="sneakpeak.model.Utente" %>

<%
    // Un doppio controllo leggero per assicurarci di avere il nome
    Utente admin = (Utente) session.getAttribute("utenteLoggato");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Area Admin - SneakPeak</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .admin-menu { display: flex; gap: 20px; justify-content: center; margin-top: 40px; }
        .admin-card { 
            background: #f4f4f4; border: 1px solid #ccc; padding: 30px; 
            border-radius: 8px; text-align: center; width: 250px; 
            text-decoration: none; color: #333; font-weight: bold;
            transition: 0.3s;
        }
        .admin-card:hover { background: #333; color: #fff; }
    </style>
</head>
<body>

    <jsp:include page="header.jsp" />

    <div style="max-width: 800px; margin: 50px auto; text-align: center;">
        <h1 style="color: #d9534f;">⚙️ Pannello di Controllo</h1>
        <p>Bentornato Amministratore, <strong><%= admin.getNome() %></strong>. Cosa vuoi fare oggi?</p>
        
        <div class="admin-menu">
            <a href="aggiungiProdotto.jsp" class="admin-card">
                👟 Aggiungi Nuovo Prodotto
            </a>
            
            <a href="gestioneOrdini" class="admin-card">
                📦 Visualizza Tutti gli Ordini
            </a>
            
            <a href="gestioneCatalogo" class="admin-card">
                 📝 Gestisci Catalogo
            </a>
        </div>
    </div>

</body>
</html>
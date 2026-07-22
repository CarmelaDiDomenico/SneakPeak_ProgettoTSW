<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Controllo di sicurezza: accessibile solo se loggato E se ha appena completato un ordine
    if (session.getAttribute("utenteLoggato") == null || session.getAttribute("ordineConfermato") == null) {
        response.sendRedirect("home");
        return;
    }
    // Rimuoviamo l'attributo così se ricarica la pagina non può rivederla
    session.removeAttribute("ordineConfermato");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Ordine Confermato!</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <div class="no-print">
        <jsp:include page="header.jsp" />
    </div>

    <div style="text-align: center; margin-top: 100px; padding: 20px;">
        <h1 style="color: #5cb85c; font-size: 40px;">✔ Ordine Ricevuto!</h1>
        <p style="font-size: 18px; margin-top: 20px;">Grazie per il tuo acquisto su SneakPeak. Il tuo ordine è in fase di elaborazione.</p>
        <br>
        <a href="home" class="no-print" style="display: inline-block; background-color: #337ab7; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px; margin-top: 20px;">
            Torna allo Shopping
        </a>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <link rel="icon" type="image/png" href="assets/logo.png">
    <meta charset="UTF-8">
    <title>Errore del Server - SneakPeak</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/errore500.css">
</head>
<body>
    <div class="error-container">
        <h1>500</h1>
        <h2>Qualcosa è andato storto!</h2>
        <p>I nostri server hanno inciampato sui lacci delle scarpe. Stiamo già lavorando per risolvere il problema.</p>
        <a href="home" class="btn">Torna alla Home</a>
        
        <div class="tech-details">
            <strong>Dettagli tecnici (per gli sviluppatori):</strong><br>
            Errore imprevisto lato server. Impossibile processare la richiesta corrente.
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>


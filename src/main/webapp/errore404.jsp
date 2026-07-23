<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Pagina Non Trovata - SneakPeak</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/errore404.css">
</head>
<body>
    <div class="error-container">
        <h1>404</h1>
        <h2>Oops! Pagina non trovata</h2>
        <p>Sembra che la sneaker che stavi cercando sia fuori stock... o forse il link era sbagliato. Controlla l'URL o torna alla nostra homepage per continuare lo shopping.</p>
        <a href="home" class="btn">Torna alla Home</a>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>

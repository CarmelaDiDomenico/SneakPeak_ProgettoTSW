<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Errore del Server - SneakPeak</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
            text-align: center;
            padding: 50px;
        }
        .error-container {
            background-color: white;
            max-width: 600px;
            margin: 0 auto;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        h1 {
            font-size: 80px;
            color: #d9534f;
            margin: 0;
        }
        h2 {
            font-size: 24px;
            color: #2F4F4F;
        }
        p {
            font-size: 16px;
            line-height: 1.5;
            color: #666;
            margin-bottom: 30px;
        }
        .btn {
            background-color: #39FF14;
            color: black;
            padding: 12px 24px;
            text-decoration: none;
            font-weight: bold;
            border-radius: 4px;
            transition: background-color 0.3s;
        }
        .btn:hover {
            background-color: #2eb80f;
            color: white;
        }
        .tech-details {
            margin-top: 30px;
            font-size: 12px;
            color: #aaa;
            text-align: left;
            background: #eee;
            padding: 10px;
            border-radius: 4px;
        }
    </style>
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
</body>
</html>

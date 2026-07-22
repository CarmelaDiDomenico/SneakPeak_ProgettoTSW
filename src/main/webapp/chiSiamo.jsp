<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi Siamo - SneakPeak</title>
    <style>
        .container {
            width: 100%;
            box-sizing: border-box;
            max-width: 800px;
            margin: 40px auto;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        h2 {
            color: #333;
            border-bottom: 2px solid #ccc;
            padding-bottom: 10px;
        }
        p {
            line-height: 1.6;
            color: #555;
            font-size: 16px;
        }
    </style>
</head>
<body>

    <jsp:include page="header.jsp" />

    <div class="container">
        <h2>Chi Siamo 👟</h2>
        <p>
            Benvenuti su <strong>SneakPeak</strong>, la destinazione definitiva per gli amanti dello streetwear e delle sneakers! 
            Siamo nati con una missione semplice: rendere accessibili a tutti le scarpe più esclusive, iconiche e ricercate del momento.
        </p>
        <p>
            Ogni paio di sneaker racconta una storia, rappresenta un'epoca, o definisce una cultura. Il nostro team lavora costantemente per 
            selezionare i migliori brand globali – da Nike ad Adidas, fino a New Balance e Puma – garantendo l'assoluta autenticità di ogni singolo prodotto.
        </p>
        <p>
            Siamo più di un semplice e-commerce. Siamo una community di appassionati, collezionisti e trendsetter. Che tu stia cercando 
            la tua prima Jordan 1, l'ultima release Yeezy, o un comodo paio di Dunk per tutti i giorni, su SneakPeak troverai sempre ciò che fa per te.
        </p>
    </div>

    <jsp:include page="footer.jsp" />

</body>
</html>

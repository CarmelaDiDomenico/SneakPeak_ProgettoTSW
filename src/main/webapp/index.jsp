<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="sneakpeak.model.Prodotto" %>
<%
    // Se la lista prodotti non è presente, reindirizza subito alla Servlet Home
    if (request.getAttribute("listaProdotti") == null) {
        response.sendRedirect("home");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SneakPeak - Home</title>
    <style>
        /* Qui lasciamo solo gli stili specifici della griglia dei prodotti */
        .grid-container { display: flex; flex-wrap: wrap; gap: 20px; padding: 20px; justify-content: center; }
        .card { border: 1px solid #ccc; border-radius: 8px; width: 250px; padding: 15px; text-align: center; box-shadow: 2px 2px 5px rgba(0,0,0,0.1); }
        .card h3 { font-size: 1.2em; margin-bottom: 10px; }
        .card a { text-decoration: none; color: #333; }
        .card a:hover { color: #2F4F4F; text-decoration: underline; }
        .card p { font-size: 0.9em; color: #666; }
        .prezzo { font-weight: bold; font-size: 1.1em; color: #2F4F4F; }
        .btn-carrello { background-color: #39FF14; color: #000; padding: 10px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; width: 100%; margin-top: 10px; }
        .btn-carrello:hover { background-color: #32E012; }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <h2 style="text-align:center; margin-top:30px;">Nuovi Arrivi</h2>

    <div class="grid-container">
        <%
            @SuppressWarnings("unchecked")
            List<Prodotto> prodotti = (List<Prodotto>) request.getAttribute("listaProdotti");
            
            if(prodotti != null && !prodotti.isEmpty()) {
                for(Prodotto p : prodotti) {
        %>
                    <div class="card">
                        <h3><a href="dettaglio?id=<%= p.getIdProdotto() %>"><%= p.getNome() %></a></h3>
                        <p>Marca: <%= p.getMarca() %></p>
                        <p class="prezzo">€ <%= String.format("%.2f", p.getPrezzo()) %></p>
                        
                        <form action="aggiungiCarrello" method="POST">
    <input type="hidden" name="id" value="<%= p.getIdProdotto() %>">
    <button type="submit" class="btn-carrello">Aggiungi al Carrello</button>
</form>
                    </div>
        <%
                }
            } else {
        %>
                <p>Nessun prodotto trovato nel catalogo. <a href="home">Ricarica la pagina</a>.</p>
        <%
            }
        %>
    </div>

    <%@ include file="footer.jsp" %>

</body>
</html>
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
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/index.css">
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
                        <a href="dettaglio?id=<%= p.getIdProdotto() %>">
                            <img src="<%= p.getImmagine() %>" alt="<%= p.getNome() %>" style="width: 100%; height: 200px; object-fit: contain; margin-bottom: 15px; border-radius: 5px;">
                        </a>
                        <h3 style="margin-top: 0;"><a href="dettaglio?id=<%= p.getIdProdotto() %>"><%= p.getNome() %></a></h3>
                        <p style="margin-top: -5px;">Marca: <%= p.getMarca() %></p>
                        <p class="prezzo">€ <%= String.format("%.2f", p.getPrezzo() * 1.22) %></p>
                        
                        <a href="dettaglio?id=<%= p.getIdProdotto() %>" style="text-decoration: none;">
                            <button class="btn-carrello" style="background-color: #2F4F4F; color: white;">Scegli Taglia</button>
                        </a>
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
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
    <link rel="icon" type="image/png" href="assets/logo.png">
    <meta charset="UTF-8">
    <title>SneakPeak - Home</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/index.css">
</head>
<body>

    <%@ include file="header.jsp" %>

    <%
        String catParam = request.getParameter("categoria");
        String titoloPagina = "I nostri prodotti";
        if (catParam != null) {
            switch(catParam) {
                case "1": titoloPagina = "Catalogo Uomo"; break;
                case "2": titoloPagina = "Catalogo Donna"; break;
                case "3": titoloPagina = "Catalogo Bambino"; break;
                case "4": titoloPagina = "Catalogo Unisex"; break;
                default: titoloPagina = "Catalogo Categoria"; break;
            }
        }
    %>
    <h2 style="text-align:center; margin-top:30px;">
        <%= titoloPagina %>
    </h2>

    <div class="filter-bar" style="text-align: center; margin: 20px auto; background-color: #f4f4f4; padding: 15px; border-radius: 8px; width: 90%; max-width: 1000px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
        <form action="home" method="GET" style="display: flex; justify-content: center; gap: 20px; flex-wrap: wrap; align-items: center;">
            
            <% if (request.getParameter("categoria") != null) { %>
                <input type="hidden" name="categoria" value="<%= request.getParameter("categoria") %>">
            <% } %>

            <div>
                <label for="marca" style="font-weight: bold; margin-right: 5px;">Marca:</label>
                <select name="marca" id="marca" style="padding: 8px; border-radius: 4px; border: 1px solid #ccc; background-color: white;">
                    <option value="">Tutte le marche</option>
                    <%
                        List<String> marche = (List<String>) request.getAttribute("marcheDisponibili");
                        String selectedMarca = request.getParameter("marca");
                        if (marche != null) {
                            for (String m : marche) {
                    %>
                                <option value="<%= m %>" <%= (m.equalsIgnoreCase(selectedMarca)) ? "selected" : "" %>><%= m %></option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>

            <div>
                <label for="taglia" style="font-weight: bold; margin-right: 5px;">Taglia:</label>
                <select name="taglia" id="taglia" style="padding: 8px; border-radius: 4px; border: 1px solid #ccc; background-color: white;">
                    <option value="">Tutte le taglie</option>
                    <%
                        List<String> taglie = (List<String>) request.getAttribute("taglieDisponibili");
                        String selectedTaglia = request.getParameter("taglia");
                        if (taglie != null) {
                            for (String t : taglie) {
                    %>
                                <option value="<%= t %>" <%= (t.equalsIgnoreCase(selectedTaglia)) ? "selected" : "" %>><%= t %></option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>

            <div>
                <label for="ordinamento" style="font-weight: bold; margin-right: 5px;">Ordina per:</label>
                <select name="ordinamento" id="ordinamento" style="padding: 8px; border-radius: 4px; border: 1px solid #ccc; background-color: white;">
                    <% String selectedOrd = request.getParameter("ordinamento"); %>
                    <option value="">Nessun ordinamento</option>
                    <option value="prezzo_asc" <%= "prezzo_asc".equals(selectedOrd) ? "selected" : "" %>>Prezzo: Crescente</option>
                    <option value="prezzo_desc" <%= "prezzo_desc".equals(selectedOrd) ? "selected" : "" %>>Prezzo: Decrescente</option>
                    <option value="nome_asc" <%= "nome_asc".equals(selectedOrd) ? "selected" : "" %>>Nome: A-Z</option>
                    <option value="nome_desc" <%= "nome_desc".equals(selectedOrd) ? "selected" : "" %>>Nome: Z-A</option>
                </select>
            </div>

            <button type="submit" style="background-color: #337ab7; color: white; padding: 8px 15px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;">Applica Filtri</button>
            <a href="home" style="text-decoration: none; color: white; background-color: #d9534f; padding: 8px 15px; border-radius: 4px; font-weight: bold; font-size: 13.3333px;">Resetta</a>
        </form>
    </div>

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

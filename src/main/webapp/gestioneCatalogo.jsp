<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="sneakpeak.model.Prodotto" %>

<%
    List<Prodotto> listaProdotti = (List<Prodotto>) request.getAttribute("listaProdotti");
    if (listaProdotti == null) {
        response.sendRedirect("gestioneCatalogo");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestione Catalogo - Admin</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        table { width: 90%; margin: 30px auto; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: center; }
        th { background-color: #333; color: white; }
        .btn-update { background-color: #f0ad4e; color: white; border: none; padding: 5px 10px; cursor: pointer; border-radius: 3px; }
        .btn-delete { background-color: #d9534f; color: white; border: none; padding: 5px 10px; cursor: pointer; border-radius: 3px; }
        .btn-activate { background-color: #5cb85c; color: white; border: none; padding: 5px 10px; cursor: pointer; border-radius: 3px; }
        .badge-nascosto { background-color: #777; color: white; padding: 3px 8px; border-radius: 12px; font-size: 12px; }
        .badge-attivo { background-color: #5cb85c; color: white; padding: 3px 8px; border-radius: 12px; font-size: 12px; }
    </style>
</head>
<body>

    <jsp:include page="header.jsp" />

    <div style="text-align: center; margin-top: 30px;">
        <h2>🛠️ Gestione Completa Catalogo</h2>
        <a href="adminDashboard.jsp" style="text-decoration: none; color: #337ab7;">🔙 Torna alla Dashboard</a>
    </div>

    <table>
        <tr>
            <th>ID</th>
            <th>Nome Prodotto</th>
            <th>Marca</th>
            <th>Stato</th>
            <th>Modifica Imponibile (€)</th>
            <th>Azione</th>
        </tr>
        
        <% for (Prodotto p : listaProdotti) { %>
        <tr style="<%= (p.getIsDeleted() == 1) ? "background-color: #f9f9f9; color: #999;" : "" %>">
            <td><%= p.getIdProdotto() %></td>
            <td><strong><%= p.getNome() %></strong></td>
            <td><%= p.getMarca() %></td>
            
            <td>
                <% if (p.getIsDeleted() == 1) { %>
                    <span class="badge-nascosto">Nascosto</span>
                <% } else { %>
                    <span class="badge-attivo">Attivo</span>
                <% } %>
            </td>

            <td>
                <form action="gestioneCatalogo" method="POST" style="display:inline;">
                    <input type="hidden" name="action" value="modificaPrezzo">
                    <input type="hidden" name="idProdotto" value="<%= p.getIdProdotto() %>">
                    <input type="number" name="nuovoPrezzo" step="0.01" value="<%= p.getPrezzo() %>" style="width: 70px; padding: 3px;">
                    <button type="submit" class="btn-update">✏️ Salva</button>
                </form>
            </td>

            <td>
                <% if (p.getIsDeleted() == 0) { %>
                    <form action="gestioneCatalogo" method="POST" style="display:inline;" onsubmit="return confirm('Vuoi davvero nascondere questo prodotto dai clienti?');">
                        <input type="hidden" name="action" value="nascondi">
                        <input type="hidden" name="idProdotto" value="<%= p.getIdProdotto() %>">
                        <button type="submit" class="btn-delete">🗑️ Nascondi</button>
                    </form>
                <% } else { %>
                    <form action="gestioneCatalogo" method="POST" style="display:inline;">
                         <input type="hidden" name="action" value="riattiva">
                         <input type="hidden" name="idProdotto" value="<%= p.getIdProdotto() %>">
                         <button type="submit" class="btn-activate">👁️ Mostra</button>
                    </form>
                <% } %>
            </td>
        </tr>
        <% } %>
    </table>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="sneakpeak.model.Ordine" %>
<%@ page import="sneakpeak.model.Utente" %>

<%
    // Doppio controllo di sicurezza (anche se c'è il Filter)
    Utente admin = (Utente) session.getAttribute("utenteLoggato");
    if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getTipo())) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Ordine> listaOrdini = (List<Ordine>) request.getAttribute("listaOrdini");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestione Ordini - Admin</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        table { width: 95%; margin: 30px auto; border-collapse: collapse; text-align: center; }
        th, td { border: 1px solid #ddd; padding: 12px; }
        th { background-color: #333; color: white; }
        .btn-update { background-color: #5cb85c; color: white; border: none; padding: 6px 12px; cursor: pointer; border-radius: 4px; font-weight: bold; }
        .badge-stato { padding: 5px 10px; border-radius: 12px; font-size: 13px; font-weight: bold; color: white; }
    </style>
</head>
<body>

    <jsp:include page="header.jsp" />

    <div style="text-align: center; margin-top: 30px;">
        <h2>📦 Gestione Ordini Clienti</h2>
        <a href="adminDashboard.jsp" style="text-decoration: none; color: #337ab7; font-weight: bold;">🔙 Torna alla Dashboard</a>
    </div>

    <% if (listaOrdini == null || listaOrdini.isEmpty()) { %>
        <p style="text-align: center; margin-top: 30px; font-size: 18px;">Nessun ordine presente nel database al momento.</p>
    <% } else { %>
        <table>
            <tr>
                <th>N° Ordine</th>
                <th>Data</th>
                <th>ID Cliente</th>
                <th>Totale</th>
                <th>Stato Attuale</th>
                <th>Aggiorna Stato Spedizione</th>
            </tr>
            
            <% for (Ordine o : listaOrdini) { 
                // Assegniamo un colore diverso al badge in base allo stato
                String coloreBadge = "#f0ad4e"; // Giallo (In elaborazione)
                if ("Spedito".equalsIgnoreCase(o.getStato())) coloreBadge = "#337ab7"; // Blu
                if ("Consegnato".equalsIgnoreCase(o.getStato())) coloreBadge = "#5cb85c"; // Verde
                if ("Annullato".equalsIgnoreCase(o.getStato())) coloreBadge = "#d9534f"; // Rosso
            %>
            <tr>
                <td><strong>#<%= o.getIdOrdine() %></strong></td>
                <td><%= o.getDataOrdine() %></td>
                <td><%= o.getIdUtente() %></td>
                <td><strong><%= String.format("%.2f", o.getTotale()) %> €</strong></td>
                
                <td>
                    <span class="badge-stato" style="background-color: <%= coloreBadge %>;">
                        <%= (o.getStato() != null) ? o.getStato() : "In elaborazione" %>
                    </span>
                </td>
                
                <td>
                    <form action="gestioneOrdini" method="POST" style="margin: 0; display: flex; justify-content: center; gap: 10px;">
                        <input type="hidden" name="idOrdine" value="<%= o.getIdOrdine() %>">
                        
                        <select name="nuovoStato" style="padding: 5px; border-radius: 4px;">
                            <option value="In elaborazione" <%= "In elaborazione".equalsIgnoreCase(o.getStato()) ? "selected" : "" %>>In elaborazione</option>
                            <option value="Spedito" <%= "Spedito".equalsIgnoreCase(o.getStato()) ? "selected" : "" %>>Spedito</option>
                            <option value="Consegnato" <%= "Consegnato".equalsIgnoreCase(o.getStato()) ? "selected" : "" %>>Consegnato</option>
                            <option value="Annullato" <%= "Annullato".equalsIgnoreCase(o.getStato()) ? "selected" : "" %>>Annullato</option>
                        </select>
                        
                        <button type="submit" class="btn-update">Aggiorna</button>
                    </form>
                </td>
            </tr>
            <% } %>
        </table>
    <% } %>

</body>
</html>
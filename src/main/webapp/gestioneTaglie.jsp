<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="sneakpeak.model.Prodotto" %>
<%@ page import="sneakpeak.model.Variante" %>
<%@ page import="sneakpeak.model.Utente" %>
<%@ page import="java.util.List" %>
<%
    // Sicurezza: solo Admin
    Utente utente = (Utente) session.getAttribute("utenteLoggato");
    if (utente == null || !"ADMIN".equalsIgnoreCase(utente.getTipo())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Prodotto prodotto = (Prodotto) request.getAttribute("prodotto");
    if (prodotto == null) {
        response.sendRedirect("gestioneCatalogo");
        return;
    }
    
    List<Variante> varianti = prodotto.getVarianti();
%>
<!DOCTYPE html>
<html>
<head>
    <link rel="icon" type="image/png" href="assets/logo.png">
    <meta charset="UTF-8">
    <title>Gestione Taglie - <%= prodotto.getNome() %></title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/gestioneTaglie.css">
</head>
<body>
    <jsp:include page="header.jsp"/>
    <div class="container">
        <a href="gestioneCatalogo" style="text-decoration: none; color: #337ab7; font-weight: bold;">🔙 Torna al Catalogo</a>
        <h2>Gestione Taglie e Quantità</h2>
        <h3>Prodotto: <%= prodotto.getNome() %> (ID: <%= prodotto.getIdProdotto() %>)</h3>
        
        <table>
            <thead>
                <tr>
                    <th>Taglia</th>
                    <th>Quantità Disponibile</th>
                    <th>Azioni</th>
                </tr>
            </thead>
            <tbody>
                <% if (varianti != null && !varianti.isEmpty()) {
                    for (Variante v : varianti) { %>
                    <tr>
                        <form action="gestioneTaglie" method="POST">
                            <input type="hidden" name="azione" value="aggiorna">
                            <input type="hidden" name="idProdotto" value="<%= prodotto.getIdProdotto() %>">
                            <input type="hidden" name="idVariante" value="<%= v.getIdVariante() %>">
                            <td><%= v.getTaglia() %></td>
                            <td><input type="number" name="quantita" value="<%= v.getQuantita() %>" min="0" required></td>
                            <td>
                                <button type="submit" class="btn btn-update">Aggiorna</button>
                        </form>
                                <form action="gestioneTaglie" method="POST" style="display:inline;" onsubmit="requireConfirm(event, 'Sicuro di voler eliminare questa taglia?');">
                                    <input type="hidden" name="azione" value="elimina">
                                    <input type="hidden" name="idProdotto" value="<%= prodotto.getIdProdotto() %>">
                                    <input type="hidden" name="idVariante" value="<%= v.getIdVariante() %>">
                                    <button type="submit" class="btn btn-delete">Elimina</button>
                                </form>
                            </td>
                    </tr>
                <%  }
                   } else { %>
                    <tr><td colspan="3" style="text-align:center;">Nessuna taglia inserita per questo prodotto.</td></tr>
                <% } %>
            </tbody>
        </table>
        
        <div style="background: #f9f9f9; padding: 20px; border: 1px solid #ddd; border-radius: 5px;">
            <h3>Aggiungi Nuova Taglia</h3>
            <form action="gestioneTaglie" method="POST">
                <input type="hidden" name="azione" value="aggiungi">
                <input type="hidden" name="idProdotto" value="<%= prodotto.getIdProdotto() %>">
                <label>Taglia:</label>
                <input type="text" name="nuovaTaglia" required placeholder="es. 42">
                <label style="margin-left: 20px;">Quantità:</label>
                <input type="number" name="nuovaQuantita" required min="0" value="0">
                <button type="submit" class="btn btn-add" style="margin-left: 20px;">Aggiungi Taglia</button>
            </form>
        </div>
    </div>
    
    <jsp:include page="footer.jsp" />
</body>
</html>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="sneakpeak.model.Utente" %>
<%@ page import="sneakpeak.model.Categoria" %>
<%@ page import="java.util.List" %>

<%
    // Controllo di sicurezza
    Utente admin = (Utente) session.getAttribute("utenteLoggato");
    if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getTipo())) {
        response.sendRedirect("login.jsp?errore=accesso_negato");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <link rel="icon" type="image/png" href="assets/logo.png">
    <meta charset="UTF-8">
    <title>Aggiungi Prodotto - Admin</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/aggiungiProdotto.css">
</head>
<body>

    <jsp:include page="header.jsp" />

    <div style="width: 100%; max-width: 600px; margin: 50px auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px; background-color: #f9f9f9; box-sizing: border-box;">
        <h2 style="text-align: center; color: #333;">👟 Aggiungi Nuova Sneaker</h2>
        
        <% if ("true".equals(request.getParameter("successo"))) { %>
            <p style="color: green; font-weight: bold; text-align: center;">✅ Prodotto aggiunto con successo al catalogo!</p>
        <% } %>
        <% if ("true".equals(request.getParameter("errore"))) { %>
            <p style="color: red; font-weight: bold; text-align: center;">❌ Errore durante l'inserimento. Riprova.</p>
        <% } %>

        <form action="aggiungiProdotto" method="POST" enctype="multipart/form-data" style="margin-top: 20px;">
        
            <div style="margin-bottom: 15px;">
                <label style="font-weight: bold;">Foto del Prodotto:</label><br>
                <input type="file" name="immagine" accept="image/*" required style="width: 100%; padding: 10px; margin-top: 5px; background-color: #fff; border: 1px solid #ccc;">
           </div>
            
            <div style="margin-bottom: 15px;">
                <label style="font-weight: bold;">Nome Modello:</label><br>
                <input type="text" name="nome" placeholder="es. Air Jordan 1 High" required style="width: 100%; padding: 10px; margin-top: 5px;">
            </div>

            <div style="margin-bottom: 15px; display: flex; gap: 15px;">
                <div style="width: 50%;">
                    <label style="font-weight: bold;">Marca:</label><br>
                    <input type="text" name="marca" placeholder="es. Nike" required style="width: 100%; padding: 10px; margin-top: 5px;">
                </div>
                <div style="width: 50%;">
                    <label style="font-weight: bold;">Prezzo (€):</label><br>
                    <input type="number" name="prezzo" step="0.01" min="0" placeholder="es. 150.00" required style="width: 100%; padding: 10px; margin-top: 5px;">
                </div>
            </div>

            <div style="margin-bottom: 15px;">
                <label style="font-weight: bold;">Categoria:</label><br>
                <select name="idCategoria" required style="width: 100%; padding: 10px; margin-top: 5px; background-color: #fff; border: 1px solid #ccc;">
                    <option value="">Seleziona una categoria...</option>
                    <%
                        List<Categoria> categorie = (List<Categoria>) request.getAttribute("categorie");
                        if (categorie != null) {
                            for (Categoria c : categorie) {
                    %>
                                <option value="<%= c.getIdCategoria() %>"><%= c.getNome() %></option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>

            <div style="margin-bottom: 20px;">
                <label style="font-weight: bold;">Descrizione:</label><br>
                <textarea name="descrizione" rows="4" placeholder="Descrivi il prodotto..." required style="width: 100%; padding: 10px; margin-top: 5px;"></textarea>
            </div>

            <button type="submit" style="background-color: #337ab7; color: white; padding: 12px; width: 100%; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; font-weight: bold;">
                💾 Salva nel Database
            </button>
            
            <div style="text-align: center; margin-top: 15px;">
                <a href="adminDashboard.jsp" style="color: #666; text-decoration: none;">🔙 Torna alla Dashboard</a>
            </div>
        </form>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>

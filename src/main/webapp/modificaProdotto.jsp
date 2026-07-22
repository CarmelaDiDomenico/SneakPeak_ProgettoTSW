<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="sneakpeak.model.Utente" %>
<%@ page import="sneakpeak.model.Categoria" %>
<%@ page import="sneakpeak.model.Prodotto" %>
<%@ page import="java.util.List" %>

<%
    // Controllo di sicurezza
    Utente admin = (Utente) session.getAttribute("utenteLoggato");
    if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getTipo())) {
        response.sendRedirect("login.jsp?errore=accesso_negato");
        return;
    }
    
    Prodotto prodotto = (Prodotto) request.getAttribute("prodotto");
    if (prodotto == null) {
        response.sendRedirect("gestioneCatalogo");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Modifica Prodotto - Admin</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        /* Fix per evitare che input e textarea escano fuori dal contenitore a causa del padding */
        input[type="text"], input[type="number"], input[type="file"], select, textarea {
            box-sizing: border-box;
        }
        textarea {
            resize: vertical; /* Impedisce di allargare la textarea orizzontalmente rompendo il design */
        }
    </style>
</head>
<body>

    <jsp:include page="header.jsp" />

    <div style="width: 100%; max-width: 600px; margin: 50px auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px; background-color: #f9f9f9; box-sizing: border-box;">
        <h2 style="text-align: center; color: #333;">✏️ Modifica Dettagli Prodotto</h2>
        <h4 style="text-align: center; color: #666;">ID: <%= prodotto.getIdProdotto() %></h4>
        
        <% if ("true".equals(request.getParameter("successo"))) { %>
            <div style="background-color: #dff0d8; color: #3c763d; padding: 15px; border-radius: 4px; margin-bottom: 20px; text-align: center; font-weight: bold;">
                ✅ Prodotto aggiornato con successo!
            </div>
        <% } %>
        <% if ("true".equals(request.getParameter("errore"))) { %>
            <div style="background-color: #f2dede; color: #a94442; padding: 15px; border-radius: 4px; margin-bottom: 20px; text-align: center; font-weight: bold;">
                ❌ Errore durante l'aggiornamento. Riprova.
            </div>
        <% } %>

        <form action="modificaProdotto" method="POST" enctype="multipart/form-data" style="margin-top: 20px;">
            <input type="hidden" name="idProdotto" value="<%= prodotto.getIdProdotto() %>">
            
            <div style="margin-bottom: 15px; text-align: center;">
                <label style="font-weight: bold; display: block; margin-bottom: 10px;">Immagine Attuale:</label>
                <img src="<%= prodotto.getImmagine() %>" alt="<%= prodotto.getNome() %>" style="max-width: 200px; border-radius: 8px; border: 1px solid #ccc;">
            </div>

            <div style="margin-bottom: 15px; background-color: #eef; padding: 10px; border-radius: 4px;">
                <label style="font-weight: bold;">Sostituisci Immagine (Opzionale):</label><br>
                <p style="font-size: 0.85em; color: #555; margin: 5px 0;">Lascia vuoto per mantenere l'immagine attuale.</p>
                <input type="file" name="immagine" accept="image/*" style="width: 100%; padding: 10px; background-color: #fff; border: 1px solid #ccc;">
           </div>
            
            <div style="margin-bottom: 15px;">
                <label style="font-weight: bold;">Nome Modello:</label><br>
                <input type="text" name="nome" value="<%= prodotto.getNome().replace("\"", "&quot;") %>" required style="width: 100%; padding: 10px; margin-top: 5px;">
            </div>

            <div style="margin-bottom: 15px; display: flex; gap: 15px;">
                <div style="width: 50%;">
                    <label style="font-weight: bold;">Marca:</label><br>
                    <input type="text" name="marca" value="<%= prodotto.getMarca().replace("\"", "&quot;") %>" required style="width: 100%; padding: 10px; margin-top: 5px;">
                </div>
                <div style="width: 50%;">
                    <label style="font-weight: bold;">Prezzo (€):</label><br>
                    <input type="number" name="prezzo" step="0.01" min="0" value="<%= String.format(java.util.Locale.US, "%.2f", prodotto.getPrezzo()) %>" required style="width: 100%; padding: 10px; margin-top: 5px;">
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
                                String selected = (c.getIdCategoria() == prodotto.getIdCategoria()) ? "selected" : "";
                    %>
                                <option value="<%= c.getIdCategoria() %>" <%= selected %>><%= c.getNome() %></option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>

            <div style="margin-bottom: 20px;">
                <label style="font-weight: bold;">Descrizione:</label><br>
                <textarea name="descrizione" rows="4" required style="width: 100%; padding: 10px; margin-top: 5px;"><%= prodotto.getDescrizione() %></textarea>
            </div>

            <button type="submit" style="background-color: #f0ad4e; color: white; padding: 12px; width: 100%; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; font-weight: bold;">
                💾 Aggiorna Prodotto
            </button>
            
            <div style="text-align: center; margin-top: 15px;">
                <a href="gestioneCatalogo" style="color: #666; text-decoration: none;">🔙 Torna al Catalogo</a>
            </div>
        </form>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="sneakpeak.model.Prodotto" %>
<%@ page import="sneakpeak.model.Recensione" %>
<%@ page import="sneakpeak.model.Variante" %>
<%@ page import="java.util.List" %>
<%@ page import="sneakpeak.model.Utente" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dettaglio Prodotto - SneakPeak</title>
    
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/dettaglio.css">
</head>
<body>

    <%@ include file="header.jsp" %>

    <%
        // Recuperiamo il prodotto (o l'errore) che la Servlet ci ha mandato
        Prodotto p = (Prodotto) request.getAttribute("prodottoSingolo");
        String errore = (String) request.getAttribute("errore");
        
        List<Recensione> recensioni = null;
        if (request.getAttribute("listaRecensioni") != null) {
            recensioni = (List<Recensione>) request.getAttribute("listaRecensioni");
        }
        
        double mediaVoti = 0.0;
        if (request.getAttribute("mediaVoti") != null) {
            mediaVoti = (Double) request.getAttribute("mediaVoti");
        }
        
        if (errore != null) {
            // Se c'è stato un problema (es. ID sbagliato)
    %>
            <div style="text-align:center; padding:50px; color:red;">
                <h2>Ops! Qualcosa è andato storto.</h2>
                <p><%= errore %></p>
                <a href="home">Torna al catalogo</a>
            </div>
    <%
        } else if (p != null) {
            // Se il prodotto esiste, lo stampiamo!
    %>
            <div class="product-container">
                
                <div class="product-image">
                  <img src="<%= p.getImmagine() %>" alt="<%= p.getNome() %>" style="max-width: 100%; max-height: 100%; object-fit: contain; border-radius: 10px;">
                </div>

                <div class="product-info">
                    <h2><%= p.getNome() %></h2>
                    <p class="product-brand"><%= p.getMarca() %></p>
                    
                    <% if (recensioni != null && !recensioni.isEmpty()) { %>
                        <div style="margin-top: -10px; margin-bottom: 15px;">
                            <span class="stars">
                                <% for (int sIdx = 1; sIdx <= 5; sIdx++) { %>
                                    <%= (sIdx <= Math.round(mediaVoti)) ? "★" : "☆" %>
                                <% } %>
                            </span>
                            <span style="color: #666; font-size: 0.9em; margin-left: 5px;">(<%= String.format("%.1f", mediaVoti) %> / 5 da <%= recensioni.size() %> recensioni)</span>
                        </div>
                    <% } else { %>
                        <div style="margin-top: -10px; margin-bottom: 15px; color: #888; font-size: 0.9em;">
                            Nessuna recensione (Sii il primo a recensire!)
                        </div>
                    <% } %>
                    
                    <div class="product-price">€ <%= String.format("%.2f", p.getPrezzo() * 1.22) %></div>
                    <div style="font-size: 0.9em; color: #888; margin-top: -15px; margin-bottom: 20px;">
                        Imponibile: € <%= String.format("%.2f", p.getPrezzo()) %> + IVA (22%)
                    </div>
                    
                    <p class="product-desc"><%= p.getDescrizione() %></p>
                    
                    <%
                        List<Variante> varianti = p.getVarianti();
                        if (varianti != null && !varianti.isEmpty() && p.getQuantitaTotale() > 0) {
                    %>
                        <form action="aggiungiCarrello" method="POST">
                            <input type="hidden" name="id" value="<%= p.getIdProdotto() %>">
                            
                            <label style="display: block; font-weight: bold; margin-bottom: 5px;">Seleziona Taglia:</label>
                            <select name="taglia" required style="padding: 10px; font-size: 1em; border-radius: 5px; border: 1px solid #ccc; width: 100%; margin-bottom: 15px;">
                                <option value="">-- Scegli una taglia --</option>
                                <% for (Variante v : varianti) { 
                                    if (v.getQuantita() > 0) {
                                %>
                                    <option value="<%= v.getTaglia() %>">Taglia <%= v.getTaglia() %> (Disp: <%= v.getQuantita() %>)</option>
                                <%  } 
                                   } %>
                            </select>
                            
                            <button type="submit" class="btn-add" style="width: 100%;">Aggiungi al Carrello</button>
                        </form>
                    <% } else { %>
                        <div style="background-color: #ffcccc; color: #cc0000; padding: 15px; border-radius: 5px; text-align: center; font-weight: bold; margin-top: 15px;">
                            Prodotto Esaurito
                        </div>
                    <% } %>
                </div>
                
                <!-- SEZIONE RECENSIONI -->
                <div class="reviews-section">
                    <h3>Recensioni dei Clienti</h3>
                    
                    <% if (request.getParameter("erroreRecensione") != null) { %>
                        <div style="color: red; margin-bottom: 10px;"><%= request.getParameter("erroreRecensione") %></div>
                    <% } %>
                    <% if (request.getParameter("successoRecensione") != null) { %>
                        <div style="color: green; margin-bottom: 10px;"><%= request.getParameter("successoRecensione") %></div>
                    <% } %>
                    
                    <div style="display: flex; gap: 40px; flex-wrap: wrap;">
                        <div style="flex: 2; min-width: 300px;">
                            <% if (recensioni == null || recensioni.isEmpty()) { %>
                                <p style="color: #666;">Non ci sono ancora recensioni per questo prodotto.</p>
                            <% } else { 
                                for (Recensione r : recensioni) {
                            %>
                                <div class="review-card">
                                    <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                                        <span class="stars">
                                            <% for (int rIdx = 1; rIdx <= 5; rIdx++) { %>
                                                <%= (rIdx <= r.getValutazione()) ? "★" : "☆" %>
                                            <% } %>
                                        </span>
                                        <span style="color: #888; font-size: 0.9em;"><%= r.getDataRecensione() %></span>
                                    </div>
                                    <h4 style="margin: 0 0 10px 0;"><%= r.getTitolo() %></h4>
                                    <p style="margin: 0 0 10px 0; color: #444;"><%= r.getDescrizione() %></p>
                                    <div style="font-size: 0.8em; color: #888;">Da: <%= r.getNomeUtente() %> <%= r.getCognomeUtente() %></div>
                                </div>
                            <%  }
                               } %>
                        </div>
                        
                        <!-- FORM RECENSIONE -->
                        <div style="flex: 1; min-width: 300px; background: #f9f9f9; padding: 20px; border-radius: 8px; border: 1px solid #ddd; height: fit-content;">
                            <h4 style="margin-top: 0;">Scrivi una recensione</h4>
                            <% if (utenteLoggato != null) { %>
                                <form action="aggiungiRecensione" method="POST">
                                    <input type="hidden" name="idProdotto" value="<%= p.getIdProdotto() %>">
                                    
                                    <label style="display: block; margin-bottom: 5px; font-weight: bold;">Valutazione:</label>
                                    <select name="valutazione" required style="width: 100%; padding: 8px; margin-bottom: 15px; border: 1px solid #ccc; border-radius: 4px;">
                                        <option value="5">5 Stelle - Ottimo</option>
                                        <option value="4">4 Stelle - Buono</option>
                                        <option value="3">3 Stelle - Nella media</option>
                                        <option value="2">2 Stelle - Scarso</option>
                                        <option value="1">1 Stella - Pessimo</option>
                                    </select>
                                    
                                    <label style="display: block; margin-bottom: 5px; font-weight: bold;">Titolo:</label>
                                    <input type="text" name="titolo" required maxlength="100" style="width: 100%; padding: 8px; margin-bottom: 15px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;">
                                    
                                    <label style="display: block; margin-bottom: 5px; font-weight: bold;">La tua recensione:</label>
                                    <textarea name="descrizione" required rows="4" style="width: 100%; padding: 8px; margin-bottom: 15px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;"></textarea>
                                    
                                    <button type="submit" style="background-color: #2F4F4F; color: white; border: none; padding: 10px 20px; width: 100%; border-radius: 4px; cursor: pointer; font-weight: bold;">Invia Recensione</button>
                                </form>
                            <% } else { %>
                                <p style="color: #666; font-size: 0.9em;">Devi effettuare l'accesso per poter lasciare una recensione.</p>
                                <a href="login.jsp" style="display: block; text-align: center; background-color: #eee; color: #333; padding: 10px; text-decoration: none; border-radius: 4px; border: 1px solid #ddd;">Accedi</a>
                            <% } %>
                        </div>
                    </div>
                </div>
                
            </div>
    <%
        }
    %>

    <%@ include file="footer.jsp" %>

</body>
</html>
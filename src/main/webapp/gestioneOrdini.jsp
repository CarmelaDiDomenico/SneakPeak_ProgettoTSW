<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="sneakpeak.model.Ordine" %>
<%@ page import="sneakpeak.model.DettaglioOrdine" %>
<%@ page import="sneakpeak.model.Utente" %>

<%
    // Doppio controllo di sicurezza (anche se c'è il Filter)
    Utente admin = (Utente) session.getAttribute("utenteLoggato");
    if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getTipo())) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Ordine> listaOrdini = (List<Ordine>) request.getAttribute("listaOrdini");
    Map<Integer, List<DettaglioOrdine>> dettagliPerOrdine = (Map<Integer, List<DettaglioOrdine>>) request.getAttribute("dettagliPerOrdine");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestione Ordini - Admin</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/gestioneOrdini.css">
</head>
<body>

    <jsp:include page="header.jsp" />

    <div style="text-align: center; margin-top: 30px;">
        <h2>📦 Gestione Ordini Clienti</h2>
        <a href="adminDashboard.jsp" style="text-decoration: none; color: #337ab7; font-weight: bold;">🔙 Torna alla Dashboard</a>
    </div>

    <!-- FORM FILTRI (Requisito della checklist) -->
    <div style="width: 95%; margin: 20px auto; background: #f9f9f9; padding: 15px; border: 1px solid #ddd; border-radius: 5px; text-align: center;">
        <form action="gestioneOrdini" method="GET" style="display: flex; justify-content: center; gap: 20px; align-items: center;">
            <label><strong>Filtra per:</strong></label>
            
            <div>
                <label>Cliente (Nome/Cognome/Email):</label>
                <input type="text" name="clienteSearch" placeholder="Es. Mario Rossi" value="<%= request.getParameter("clienteSearch") != null ? request.getParameter("clienteSearch") : "" %>" style="padding: 5px; width: 180px;">
            </div>
            
            <div>
                <label>Da:</label>
                <input type="date" name="dataInizio" value="<%= request.getParameter("dataInizio") != null ? request.getParameter("dataInizio") : "" %>" style="padding: 5px;">
            </div>
            
            <div>
                <label>A:</label>
                <input type="date" name="dataFine" value="<%= request.getParameter("dataFine") != null ? request.getParameter("dataFine") : "" %>" style="padding: 5px;">
            </div>
            
            <button type="submit" style="background-color: #337ab7; color: white; border: none; padding: 7px 15px; cursor: pointer; border-radius: 4px;">Applica Filtri</button>
            <a href="gestioneOrdini" style="text-decoration: none; background-color: #d9534f; color: white; padding: 7px 15px; border-radius: 4px;">Resetta</a>
        </form>
    </div>

    <% if (listaOrdini == null || listaOrdini.isEmpty()) { %>
        <p style="text-align: center; margin-top: 30px; font-size: 18px;">Nessun ordine trovato con questi criteri.</p>
    <% } else { %>
        <div class="table-responsive">
            <table>
                <tr>
                <th>N° Ordine</th>
                <th>Data</th>
                <th>Cliente</th>
                <th>Totale</th>
                <th>Stato Attuale</th>
                <th>Aggiorna Stato Spedizione</th>
                <th>Dettagli Prodotti</th>
            </tr>
            
            <% for (Ordine o : listaOrdini) { 
                // Assegniamo un colore diverso al badge in base allo stato
                String coloreBadge = "#f0ad4e"; // Giallo (In elaborazione)
                if ("Spedito".equalsIgnoreCase(o.getStato())) coloreBadge = "#337ab7"; // Blu
                if ("Consegnato".equalsIgnoreCase(o.getStato())) coloreBadge = "#5cb85c"; // Verde
                if ("Annullato".equalsIgnoreCase(o.getStato())) coloreBadge = "#d9534f"; // Rosso
            %>
            <tr class="order-row" id="row-<%= o.getIdOrdine() %>">
                <td><strong>#<%= o.getIdOrdine() %></strong></td>
                <%
                    String dataFormattata = "";
                    if (o.getDataOrdine() != null) {
                        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
                        dataFormattata = sdf.format(o.getDataOrdine());
                    }
                %>
                <td><%= dataFormattata %></td>
                <td>
                    <strong><%= o.getNomeCliente() != null ? o.getNomeCliente() : "—" %></strong><br>
                    <span style="font-size:12px; color:#777;"><%= o.getEmailCliente() != null ? o.getEmailCliente() : "" %></span>
                </td>
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
                <td>
                    <button type="button" class="btn-update" style="background-color: #5bc0de; font-size: 12px; padding: 4px 8px;" onclick="document.getElementById('dett-<%= o.getIdOrdine() %>').style.display = document.getElementById('dett-<%= o.getIdOrdine() %>').style.display === 'none' ? 'table-row' : 'none'">Vedi Prodotti</button>
                </td>
            </tr>
            
            <tr class="details-row" id="dett-<%= o.getIdOrdine() %>" style="display:none; background-color: #f9f9f9;">
                <td colspan="7" style="text-align: left; padding: 15px; border-bottom: 2px solid #ccc;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                        <strong style="color: #333;">📦 Prodotti acquistati in questo ordine:</strong>
                        <button type="button" class="btn-print" onclick="printSingleOrderAdmin(<%= o.getIdOrdine() %>)">🖨️ Stampa Ricevuta</button>
                    </div>
                    <ul style="list-style-type: none; padding: 0; margin: 0;">
                        <% 
                        List<DettaglioOrdine> detts = (dettagliPerOrdine != null) ? dettagliPerOrdine.get(o.getIdOrdine()) : null;
                        if (detts != null && !detts.isEmpty()) {
                            for (DettaglioOrdine d : detts) {
                        %>
                            <li style="padding: 5px 0; border-bottom: 1px solid #ddd; font-size: 14px;">
                                👟 <strong><%= d.getNomeProdotto() %></strong> 
                                (Taglia: <strong><%= d.getTaglia() %></strong>) 
                                &nbsp;|&nbsp; Qtà: <strong><%= d.getQuantita() %></strong> 
                                &nbsp;|&nbsp; Prezzo unitario (IVA incl.): € <%= String.format("%.2f", d.getPrezzoLordo()) %>
                            </li>
                        <%  } 
                        } else { %>
                            <li style="padding: 5px 0; font-style: italic; color: #777;">Nessun dettaglio disponibile per questo ordine.</li>
                        <% } %>
                    </ul>
                </td>
            </tr>
            <% } %>
            </table>
        </div>
    <% } %>

    <!-- AREA STAMPA FATTURE (Nascosta a schermo, visibile solo in stampa tramite JS) -->
    <div id="print-area">
        <div class="container">
    <% if (listaOrdini != null) {
        for (Ordine o : listaOrdini) { 
            String dataF = "";
            if (o.getDataOrdine() != null) {
                SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
                dataF = sdf.format(o.getDataOrdine());
            }
            List<DettaglioOrdine> detts = (dettagliPerOrdine != null) ? dettagliPerOrdine.get(o.getIdOrdine()) : null;
            
            String colore = "#f0ad4e";
            String stato = (o.getStato() != null) ? o.getStato() : "In elaborazione";
            if ("Spedito".equalsIgnoreCase(stato))     colore = "#337ab7";
            if ("Consegnato".equalsIgnoreCase(stato))  colore = "#5cb85c";
            if ("Annullato".equalsIgnoreCase(stato))   colore = "#d9534f";
    %>
            <div class="ordine-card" id="fattura-<%= o.getIdOrdine() %>">
                <div class="ordine-header">
                    <span class="order-id"># <%= o.getIdOrdine() %></span>
                    <span class="order-meta">📅 <%= dataF %></span>
                    <span class="order-meta" style="margin-left: 10px;">👤 <%= o.getNomeCliente() != null ? o.getNomeCliente() : "—" %></span>
                    <span class="stato-badge" style="background-color: <%= colore %>"><%= stato %></span>
                    <span class="order-meta">Totale: <strong>€ <%= String.format("%.2f", o.getTotale()) %></strong></span>
                </div>
                <div class="ordine-body">
                    <% if (detts != null && !detts.isEmpty()) { %>
                        <table class="tabella-prodotti">
                            <thead>
                                <tr>
                                    <th>Prodotto</th>
                                    <th style="text-align:center;">Qtà</th>
                                    <th style="text-align:right;">Prezzo unitario (IVA incl.)</th>
                                    <th style="text-align:right;">Subtotale</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    double totaleCalcolato = 0;
                                    for (DettaglioOrdine d : detts) {
                                        totaleCalcolato += d.getSubtotale();
                                %>
                                <tr>
                                    <td><strong><%= d.getNomeProdotto() %> (Tg. <%= d.getTaglia() %>)</strong></td>
                                    <td style="text-align:center;"><%= d.getQuantita() %></td>
                                    <td class="num">€ <%= String.format("%.2f", d.getPrezzoLordo()) %></td>
                                    <td class="num"><strong>€ <%= String.format("%.2f", d.getSubtotale()) %></strong></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                        
                        <div class="ordine-summary">
                            <span>IVA inclusa (<%= String.format("%.0f", detts.get(0).getIvaAcquisto()) %>%)</span>
                            <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 10px;">
                                <span class="totale-finale">Totale ordine: € <%= String.format("%.2f", totaleCalcolato) %></span>
                            </div>
                        </div>
                    <% } else { %>
                        <p style="padding: 15px; color: #777;">Nessun dettaglio disponibile per questo ordine.</p>
                    <% } %>
                </div>
            </div>
    <% } } %>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
    
    <script>
        function printSingleOrderAdmin(idOrdine) {
            // Salva il titolo originale per rimetterlo dopo
            var originalTitle = document.title;
            // Imposta il titolo identico a quello dello storico (che diventa il nome del file PDF)
            document.title = "Storico Ordini - SneakPeak";
            
            document.body.classList.add('print-single-mode');
            var fattura = document.getElementById('fattura-' + idOrdine);
            if(fattura) fattura.classList.add('print-active');
            
            window.print();
            
            // Ripristina tutto dopo la stampa
            document.title = originalTitle;
            document.body.classList.remove('print-single-mode');
            if(fattura) fattura.classList.remove('print-active');
        }
    </script>
</body>
</html>
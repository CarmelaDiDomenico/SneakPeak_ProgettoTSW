<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="sneakpeak.model.Utente" %>
<%@ page import="sneakpeak.model.Ordine" %>
<%@ page import="sneakpeak.model.DettaglioOrdine" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    // Sicurezza: blocchiamo l'accesso se l'utente non è loggato
    Utente utente = (Utente) session.getAttribute("utenteLoggato");
    if (utente == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Storico Ordini - SneakPeak</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/storicoOrdini.css">
</head>
<body>

    <jsp:include page="header.jsp" />

    <div class="container">

        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px;">
            <h2 class="section-title" style="margin-bottom: 0;">I Tuoi Ordini</h2>
            <button class="btn-print" onclick="window.print()">🖨️ Stampa / Salva come PDF</button>
        </div>
        <br>

        <%
            @SuppressWarnings("unchecked")
            List<Ordine> ordiniCliente = (List<Ordine>) request.getAttribute("ordiniCliente");

            @SuppressWarnings("unchecked")
            Map<Integer, List<DettaglioOrdine>> dettagliPerOrdine =
                (Map<Integer, List<DettaglioOrdine>>) request.getAttribute("dettagliPerOrdine");

            if (ordiniCliente != null && !ordiniCliente.isEmpty()) {
                int cardIndex = 0;
                for (Ordine o : ordiniCliente) {
                    cardIndex++;

                    // Colore badge in base allo stato
                    String colore = "#f0ad4e"; // giallo = In elaborazione
                    String stato = (o.getStato() != null) ? o.getStato() : "In elaborazione";
                    if ("Spedito".equalsIgnoreCase(stato))     colore = "#337ab7";
                    if ("Consegnato".equalsIgnoreCase(stato))  colore = "#5cb85c";
                    if ("Annullato".equalsIgnoreCase(stato))   colore = "#d9534f";

                    List<DettaglioOrdine> dettagli =
                        (dettagliPerOrdine != null) ? dettagliPerOrdine.get(o.getIdOrdine()) : null;
        %>
            <div class="ordine-card">
                <%-- HEADER: clicca per espandere/collassare --%>
                <div class="ordine-header" id="header-<%= cardIndex %>" onclick="toggleCard(<%= cardIndex %>)">
                    <span class="order-id"># <%= o.getIdOrdine() %></span>
                    <span class="order-meta">📅 <%= o.getDataOrdine() %></span>
                    <span class="stato-badge" style="background-color: <%= colore %>"><%= stato %></span>
                    <span class="order-meta">Totale: <strong>€ <%= String.format("%.2f", o.getTotale()) %></strong></span>
                    <span class="toggle-icon">▼</span>
                </div>

                <%-- BODY: dettaglio prodotti acquistati --%>
                <div class="ordine-body" id="body-<%= cardIndex %>">
                    <% if (dettagli != null && !dettagli.isEmpty()) { %>
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
                                    for (DettaglioOrdine d : dettagli) {
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
                            <span>IVA inclusa (<%= String.format("%.0f", dettagli.get(0).getIvaAcquisto()) %>%)</span>
                            <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 10px;">
                                <span class="totale-finale">Totale ordine: € <%= String.format("%.2f", o.getTotale()) %></span>
                                <button type="button" class="btn-print" style="margin-top: 5px; font-size: 14px;" onclick="printSingleOrder(<%= cardIndex %>)">🖨️ Stampa questa Ricevuta</button>
                            </div>
                        </div>
                    <% } else { %>
                        <p style="color: #888; font-style: italic;">Nessun dettaglio disponibile per questo ordine.</p>
                    <% } %>
                </div>
            </div>
        <%
                }
            } else {
        %>
            <p>Non hai ancora effettuato nessun ordine. Vai al <a href="home">catalogo</a> per iniziare lo shopping!</p>
        <%
            }
        %>

        <a href="profilo" class="back-btn">← Torna al Profilo</a>
    </div>

    <jsp:include page="footer.jsp" />

    <script>
        function toggleCard(index) {
            var header = document.getElementById('header-' + index);
            var body   = document.getElementById('body-'   + index);
            header.classList.toggle('open');
            body.classList.toggle('open');
        }

        // Al caricamento, apri automaticamente il primo ordine (il più recente)
        document.addEventListener('DOMContentLoaded', function() {
            var firstHeader = document.getElementById('header-1');
            var firstBody   = document.getElementById('body-1');
            if (firstHeader && firstBody) {
                firstHeader.classList.add('open');
                firstBody.classList.add('open');
            }
        });
        function printSingleOrder(cardIndex) {
            // Aggiungi classe al body per avviare il css print-single-mode
            document.body.classList.add('print-single-mode');
            
            // Trova la card target e aggiungi print-active
            var allCards = document.querySelectorAll('.ordine-card');
            var targetCard = allCards[cardIndex - 1]; // cardIndex parte da 1
            if(targetCard) {
                targetCard.classList.add("print-active");
            }
            
            // Assicuriamoci che il body dell'ordine sia aperto
            var body = document.getElementById('body-' + cardIndex);
            var header = document.getElementById('header-' + cardIndex);
            
            var wasClosed = !body.classList.contains('open');
            if(wasClosed) {
                body.classList.add('open');
                header.classList.add('open');
            }

            // Manda in stampa
            window.print();
            
            // Ripristina tutto alla normalità
            document.body.classList.remove('print-single-mode');
            if(targetCard) {
                targetCard.classList.remove("print-active");
            }
            if(wasClosed) {
                body.classList.remove('open');
                header.classList.remove('open');
            }
        }
    </script>

</body>
</html>

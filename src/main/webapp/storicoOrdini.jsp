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
    <style>
        .container {
            width: 100%;
            box-sizing: border-box;
            max-width: 1000px;
            margin: 40px auto;
            background-color: #f9f9f9;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .section-title {
            color: #2F4F4F;
            border-bottom: 2px solid #39FF14;
            padding-bottom: 5px;
            margin-bottom: 25px;
        }

        /* --- CARD SINGOLO ORDINE --- */
        .ordine-card {
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 6px;
            margin-bottom: 20px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0,0,0,0.06);
        }
        .ordine-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #2F4F4F;
            color: white;
            padding: 12px 20px;
            cursor: pointer;
            user-select: none;
        }
        .ordine-header:hover {
            background-color: #3a6363;
        }
        .ordine-header .order-id {
            font-size: 1.1em;
            font-weight: bold;
        }
        .ordine-header .order-meta {
            font-size: 0.9em;
            opacity: 0.85;
        }
        .ordine-header .toggle-icon {
            font-size: 1.2em;
            transition: transform 0.3s;
        }
        .ordine-header.open .toggle-icon {
            transform: rotate(180deg);
        }

        /* Badge stato */
        .stato-badge {
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: bold;
            color: white;
            white-space: nowrap;
        }

        /* --- CORPO DELL'ORDINE (dettaglio prodotti) --- */
        .ordine-body {
            display: none;
            padding: 20px;
        }
        .ordine-body.open {
            display: block;
        }

        /* Tabella prodotti acquistati */
        .tabella-prodotti {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 15px;
        }
        .tabella-prodotti th {
            background-color: #f0f0f0;
            color: #333;
            padding: 10px 12px;
            text-align: left;
            font-size: 0.85em;
            border-bottom: 2px solid #ddd;
        }
        .tabella-prodotti td {
            padding: 10px 12px;
            border-bottom: 1px solid #eee;
            font-size: 0.9em;
        }
        .tabella-prodotti tr:last-child td {
            border-bottom: none;
        }
        .tabella-prodotti td.num {
            text-align: right;
        }

        /* Riepilogo totale nell'ordine */
        .ordine-summary {
            display: flex;
            justify-content: flex-end;
            gap: 30px;
            border-top: 1px solid #ddd;
            padding-top: 12px;
            font-size: 0.9em;
            color: #555;
        }
        .ordine-summary .totale-finale {
            font-weight: bold;
            font-size: 1.05em;
            color: #2F4F4F;
        }

        /* Pulsante stampa */
        .btn-print {
            display: inline-block;
            margin-top: 8px;
            padding: 7px 14px;
            background-color: #555;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.85em;
            font-weight: bold;
        }
        .btn-print:hover {
            background-color: #333;
        }

        .back-btn {
            display: inline-block;
            margin-top: 25px;
            padding: 10px 18px;
            background-color: #333;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-size: 0.95em;
        }
        .back-btn:hover {
            background-color: #555;
        }

        /* --- STILI PER LA STAMPA --- */
        @media print {
            @page { margin: 0; } /* Rimuove header/footer del browser (Data, URL) */
            body { 
                background-color: white; 
                color: black; 
                margin: 0; 
                padding: 0; 
            }
            .container { 
                width: 100%; 
                margin: 0; 
                padding: 1.5cm !important; /* Diamo spazio ai bordi fisici del foglio */
                box-sizing: border-box;
                box-shadow: none; 
                border-radius: 0; 
            }
            .back-btn, .btn-print, .nav, .header p, .footer, .toast-banner, .section-title { display: none !important; }
            
            /* Di default stampa tutto lo storico */
            .ordine-card { display: block; break-inside: avoid; margin-bottom: 20px; border: 1px solid #aaa; }
            
            /* SE stiamo stampando un singolo ordine tramite JS, nascondi tutte le altre card */
            body.print-single-mode .ordine-card:not(.print-active) { display: none !important; }
            
            /* Mostra TUTTE le card aperte in stampa (se non siamo in single-mode, apri tutto; se siamo in single-mode l'unica visibile sarà già aperta) */
            .ordine-body { display: block !important; }
            
            .ordine-header { background-color: #eee !important; color: black !important; cursor: default; }
            .toggle-icon { display: none; }
            .tabella-prodotti th { background-color: #ddd; }
            .tabella-prodotti th, .tabella-prodotti td { border: 1px solid #aaa !important; }
            .stato-badge { border: 1px solid #aaa; color: black !important; background-color: transparent !important; }
            
            /* Intestazione fattura dinamica */
            .container::before {
                content: "Storico Acquisti — SneakPeak";
                display: block;
                font-size: 22px;
                font-weight: bold;
                margin-bottom: 15px;
                text-align: center;
                border-bottom: 2px solid black;
                padding-bottom: 10px;
            }
            body.print-single-mode .container::before {
                content: "Ricevuta Ordine — SneakPeak";
            }
        }
    </style>
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

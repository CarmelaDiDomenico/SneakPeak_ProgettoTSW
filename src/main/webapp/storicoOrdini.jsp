<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="sneakpeak.model.Utente" %>
<%@ page import="sneakpeak.model.Ordine" %>
<%@ page import="java.util.List" %>
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
            width: 80%;
            margin: 20px auto;
            background-color: #f9f9f9;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .section-title {
            color: #2F4F4F;
            border-bottom: 2px solid #39FF14;
            padding-bottom: 5px;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: center;
        }
        th {
            background-color: #2F4F4F;
            color: #39FF14;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        .stato-badge {
            padding: 5px 10px;
            border-radius: 4px;
            font-weight: bold;
            color: white;
            background-color: #007bff; /* Blu generico, potremmo personalizzarlo per stato */
        }
        .back-btn {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 15px;
            background-color: #333;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }
        .back-btn:hover {
            background-color: #555;
        }

        /* --- STILI PER LA STAMPA (Requisito Fattura) --- */
        @media print {
            body { background-color: white; color: black; }
            .container { width: 100%; margin: 0; padding: 0; box-shadow: none; }
            .back-btn, .nav, .header p, .footer, .toast-banner { display: none !important; }
            .section-title { border-bottom: 2px solid black; color: black; }
            table, th, td { border: 1px solid black; }
            th { background-color: #eee; color: black; }
            .stato-badge { color: black; background-color: transparent; padding: 0; }
            
            /* Un po' di testo extra per sembrare una fattura */
            .container::before {
                content: "Ricevuta Acquisto - SneakPeak";
                display: block;
                font-size: 24px;
                font-weight: bold;
                margin-bottom: 20px;
                text-align: center;
            }
        }
    </style>
</head>
<body>

    <jsp:include page="header.jsp" />

    <div class="container">
        <h2 class="section-title">I Tuoi Ordini Passati</h2>

        <%
            List<Ordine> ordiniCliente = (List<Ordine>) request.getAttribute("ordiniCliente");
            if (ordiniCliente != null && !ordiniCliente.isEmpty()) {
        %>
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>N° Ordine</th>
                        <th>Data</th>
                        <th>Totale</th>
                        <th>Stato</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Ordine o : ordiniCliente) { %>
                        <tr>
                            <td>#<%= o.getIdOrdine() %></td>
                            <td><%= o.getDataOrdine() %></td>
                            <td>€ <%= String.format("%.2f", o.getTotale()) %></td>
                            <td><span class="stato-badge"><%= o.getStato() %></span></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
            </div>
        <%
            } else {
        %>
            <p>Non hai ancora effettuato nessun ordine. Vai al <a href="home">catalogo</a> per iniziare lo shopping!</p>
        <%
            }
        %>

        <a href="profilo" class="back-btn">← Torna al Profilo</a>
    </div>

    <jsp:include page="footer.jsp" />

</body>
</html>

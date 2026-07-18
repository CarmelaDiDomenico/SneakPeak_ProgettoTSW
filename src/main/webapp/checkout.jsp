<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="sneakpeak.model.Carrello" %>
<%@ page import="sneakpeak.model.Utente" %>
<%@ page import="sneakpeak.model.Indirizzo" %>
<%@ page import="sneakpeak.model.MetodoPagamento" %>
<%@ page import="java.util.List" %>

<%
    // Controllo utente loggato
    Utente utente = (Utente) session.getAttribute("utenteLoggato");
    if (utente == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Controllo carrello
    Carrello carrello = (Carrello) session.getAttribute("carrello");
    double totale = (carrello != null) ? carrello.getPrezzoTotale() : 0.0;
    
    if (carrello == null || carrello.getArticoli().isEmpty()) {
        response.sendRedirect("carrello.jsp");
        return;
    }
    
    // Recuperiamo le liste passate dalla CheckoutServlet
    List<Indirizzo> listaIndirizzi = (List<Indirizzo>) request.getAttribute("listaIndirizzi");
    List<MetodoPagamento> listaPagamenti = (List<MetodoPagamento>) request.getAttribute("listaPagamenti");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SneakPeak - Checkout</title>
    <link rel="stylesheet" href="css/style.css">
    
    <script>
        function toggleIndirizzo() {
            var select = document.getElementById("idIndirizzo");
            var formNuovo = document.getElementById("nuovo-indirizzo-fields");
            if (select.value === "nuovo") {
                formNuovo.style.display = "block";
                document.getElementById("nuovaVia").required = true;
                document.getElementById("nuovoCivico").required = true;
                document.getElementById("nuovaCitta").required = true;
                document.getElementById("nuovaProvincia").required = true;
                document.getElementById("nuovoCap").required = true;
                document.getElementById("nuovaNazione").required = true;
            } else {
                formNuovo.style.display = "none";
                document.getElementById("nuovaVia").required = false;
                document.getElementById("nuovoCivico").required = false;
                document.getElementById("nuovaCitta").required = false;
                document.getElementById("nuovaProvincia").required = false;
                document.getElementById("nuovoCap").required = false;
                document.getElementById("nuovaNazione").required = false;
            }
        }

        function togglePagamento() {
            var select = document.getElementById("idPagamento");
            var formNuovo = document.getElementById("nuovo-pagamento-fields");
            if (select.value === "nuovo") {
                formNuovo.style.display = "block";
                document.getElementById("nuovoIntestatario").required = true;
            } else {
                formNuovo.style.display = "none";
                document.getElementById("nuovoIntestatario").required = false;
            }
        }
    </script>
</head>
<body>

    <jsp:include page="header.jsp" />

    <div class="checkout-container" style="max-width: 600px; margin: 50px auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px; font-family: Arial, sans-serif;">
        <h2>Completamento Ordine</h2>
        <p>Benvenuto al checkout, <strong><%= utente.getNome() %></strong>. Controlla i tuoi dati prima di confermare.</p>
        
        <% if (request.getParameter("erroreDati") != null) { %>
            <p style="color: red; font-weight: bold;">C'è stato un errore nel salvataggio dei dati. Riprova.</p>
        <% } %>

        <hr>
        <div style="font-size: 1.1em; margin-bottom: 5px;">Imponibile: <span style="float: right;">€ <%= String.format("%.2f", carrello.getPrezzoNetto()) %></span></div>
        <div style="font-size: 1.1em; margin-bottom: 5px;">IVA (22%): <span style="float: right;">€ <%= String.format("%.2f", carrello.getIva()) %></span></div>
        <hr style="border: 0; border-top: 1px dashed #ccc; margin: 10px 0;">
        <h3 style="margin-top: 0;">Riepilogo Totale: <span style="float: right; color: #d9534f;"><%= String.format("%.2f", totale) %> €</span></h3>
        <hr>
        
        <form action="checkout" method="POST">
            
            <h3>Dati di Spedizione</h3>
            <div style="margin-bottom: 15px;">
                <label for="idIndirizzo">Scegli indirizzo di spedizione:</label><br>
                <select name="idIndirizzo" id="idIndirizzo" onchange="toggleIndirizzo()" style="width: 100%; padding: 8px; margin-top: 5px;">
                    <% if (listaIndirizzi != null && !listaIndirizzi.isEmpty()) { %>
                        <% for (Indirizzo ind : listaIndirizzi) { %>
                            <option value="<%= ind.getIdIndirizzo() %>">
                                <%= ind.getVia() %>, <%= ind.getCivico() %> - <%= ind.getCitta() %> (<%= ind.getProvincia() %>) - <%= ind.getCap() %>
                            </option>
                        <% } %>
                        <option value="nuovo">-- Inserisci un nuovo indirizzo --</option>
                    <% } else { %>
                        <option value="nuovo">Nessun indirizzo salvato. Inseriscine uno ora.</option>
                    <% } %>
                </select>
            </div>
            
            <div id="nuovo-indirizzo-fields" style="<%= (listaIndirizzi != null && !listaIndirizzi.isEmpty()) ? "display:none;" : "display:block;" %> background-color: #f9f9f9; padding: 15px; border-radius: 4px; margin-bottom: 20px;">
                <h4>Nuovo Indirizzo</h4>
                
                <div style="margin-bottom: 10px; display: flex; gap: 10px;">
                    <input type="text" name="nuovaVia" id="nuovaVia" placeholder="Via/Piazza (es. Via Roma)" style="width: 75%; padding: 8px;" <%= (listaIndirizzi == null || listaIndirizzi.isEmpty()) ? "required" : "" %>>
                    <input type="text" name="nuovoCivico" id="nuovoCivico" placeholder="Civico" style="width: 25%; padding: 8px;" <%= (listaIndirizzi == null || listaIndirizzi.isEmpty()) ? "required" : "" %>>
                </div>
                
                <div style="margin-bottom: 10px; display: flex; gap: 10px;">
                    <input type="text" name="nuovaCitta" id="nuovaCitta" placeholder="Città (es. Napoli)" style="width: 50%; padding: 8px;" <%= (listaIndirizzi == null || listaIndirizzi.isEmpty()) ? "required" : "" %>>
                    <input type="text" name="nuovaProvincia" id="nuovaProvincia" placeholder="Prov. (es. NA)" maxlength="2" style="width: 25%; padding: 8px;" <%= (listaIndirizzi == null || listaIndirizzi.isEmpty()) ? "required" : "" %>>
                    <input type="text" name="nuovoCap" id="nuovoCap" placeholder="CAP" maxlength="5" style="width: 25%; padding: 8px;" <%= (listaIndirizzi == null || listaIndirizzi.isEmpty()) ? "required" : "" %>>
                </div>
                
                <div style="margin-bottom: 10px;">
                    <input type="text" name="nuovaNazione" id="nuovaNazione" placeholder="Nazione" value="Italia" style="width: 100%; padding: 8px;" <%= (listaIndirizzi == null || listaIndirizzi.isEmpty()) ? "required" : "" %>>
                </div>
            </div>
            
            <hr>

            <h3>Metodo di Pagamento</h3>
            <div style="margin-bottom: 15px;">
                <label for="idPagamento">Scegli il metodo di pagamento:</label><br>
                <select name="idPagamento" id="idPagamento" onchange="togglePagamento()" style="width: 100%; padding: 8px; margin-top: 5px;">
                    <% if (listaPagamenti != null && !listaPagamenti.isEmpty()) { %>
                        <% for (MetodoPagamento mp : listaPagamenti) { %>
                            <option value="<%= mp.getIdPagamento() %>">
                                <%= mp.getTipo() %> - Intestatario: <%= mp.getIntestatario() %>
                            </option>
                        <% } %>
                        <option value="nuovo">-- Inserisci un nuovo metodo --</option>
                    <% } else { %>
                        <option value="nuovo">Nessun metodo salvato. Inseriscine uno ora.</option>
                    <% } %>
                </select>
            </div>
            
            <div id="nuovo-pagamento-fields" style="<%= (listaPagamenti != null && !listaPagamenti.isEmpty()) ? "display:none;" : "display:block;" %> background-color: #f9f9f9; padding: 15px; border-radius: 4px; margin-bottom: 20px;">
                <h4>Nuovo Metodo</h4>
                
                <div style="margin-bottom: 10px;">
                    <select name="nuovoTipo" id="nuovoTipo" style="width: 100%; padding: 8px;">
                        <option value="Carta di Credito">Carta di Credito</option>
                        <option value="Carta di Debito">Carta di Debito</option>
                        <option value="PayPal">PayPal</option>
                        <option value="Apple Pay">Apple Pay</option>
                        <option value="Google Pay">Google Pay</option>
                    </select>
                </div>
                
                <div style="margin-bottom: 10px;">
                    <input type="text" name="nuovoIntestatario" id="nuovoIntestatario" placeholder="Nome Intestatario" style="width: 100%; padding: 8px;" <%= (listaPagamenti == null || listaPagamenti.isEmpty()) ? "required" : "" %>>
                </div>
            </div>
            
            <button type="submit" style="background-color: #5cb85c; color: white; padding: 12px 20px; border: none; border-radius: 4px; cursor: pointer; width: 100%; font-size: 16px; font-weight: bold;">
                Conferma e Paga
            </button>
        </form>
    </div>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="sneakpeak.model.Carrello" %>
<%@ page import="sneakpeak.model.CartItem" %>
<%@ page import="sneakpeak.model.Prodotto" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Il tuo Carrello - SneakPeak</title>
    
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/carrello.css">
</head>
<body>

    <%@ include file="header.jsp" %>

    <h2 style="text-align:center; margin-top:30px;">Il tuo Carrello</h2>

    <%
        String erroreCarrello = (String) session.getAttribute("erroreCarrello");
        String messaggioSuccesso = (String) session.getAttribute("messaggioSuccesso");
        
        if (erroreCarrello != null) {
    %>
        <div style="background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 15px; border-radius: 5px; max-width: 800px; margin: 20px auto; text-align: center;">
            <strong>Attenzione!</strong> <%= erroreCarrello %>
        </div>
    <%
            session.removeAttribute("erroreCarrello");
        }
        
        if (messaggioSuccesso != null) {
    %>
        <div style="background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; padding: 15px; border-radius: 5px; max-width: 800px; margin: 20px auto; text-align: center;">
            <%= messaggioSuccesso %>
        </div>
    <%
            session.removeAttribute("messaggioSuccesso");
        }
    %>

    <div class="cart-wrapper">
        <%
            // Recuperiamo il carrello direttamente dalla sessione dell'utente
            Carrello carrello = (Carrello) session.getAttribute("carrello");
            
            // Caso 1: Il carrello non esiste nella sessione oppure esiste ma è vuoto
            if (carrello == null || carrello.isEmpty()) {
        %>
                <div style="text-align:center; width:100%; padding:50px 0;">
                    <p style="font-size:1.2em; color:#666;">Il tuo carrello è attualmente vuoto.</p>
                    <a href="home" style="color:#2F4F4F; font-weight:bold;">Torna al catalogo per aggiungere sneaker</a>
                </div>
        <%
            // Caso 2: Il carrello contiene almeno una scarpa
            } else {
        %>
                <div class="cart-items-list">
                    <%
                        for (CartItem item : carrello.getArticoli()) {
                            Prodotto p = item.getProdotto();
                            int qty = item.getQuantita();
                            String taglia = item.getTaglia();
                    %>
                            <div class="cart-item-row">
                                <div style="display: flex; align-items: center; flex-grow: 1;">
                                    <div style="margin-right: 20px;">
                                        <img src="<%= p.getImmagine() %>" alt="<%= p.getNome() %>" style="width: 80px; height: 80px; object-fit: contain; border-radius: 5px; border: 1px solid #ddd;">
                                    </div>
                                    <div class="item-info">
                                        <h4 style="margin: 0 0 5px 0;"><%= p.getNome() %> - Taglia <%= taglia %></h4>
                                        <p style="margin: 0; color: #666;">Marca: <%= p.getMarca() %></p>
                                    </div>
                                </div>
                                <div style="display:flex; align-items:center;">
                                    <form action="modificaCarrello" method="POST" style="display:flex; align-items:center; margin-right: 15px;">
                                        <input type="hidden" name="id" value="<%= p.getIdProdotto() %>">
                                        <input type="hidden" name="taglia" value="<%= taglia %>">
                                        <input type="hidden" id="hidden-qty-<%= p.getIdProdotto() %>-<%= taglia %>" name="quantita" value="<%= qty %>">
                                        <button type="button" class="btn-qty" <%= (qty <= 1) ? "disabled" : "" %> onclick="submitCartQty(<%= p.getIdProdotto() %>, '<%= taglia %>', <%= qty - 1 %>)">-</button>
                                        <input type="number" min="1" class="qty-input" value="<%= qty %>" onchange="submitCartQty(<%= p.getIdProdotto() %>, '<%= taglia %>', this.value)">
                                        <button type="button" class="btn-qty" onclick="submitCartQty(<%= p.getIdProdotto() %>, '<%= taglia %>', <%= qty + 1 %>)">+</button>
                                    </form>
                                    <span class="item-price">€ <%= String.format("%.2f", p.getPrezzo() * qty) %></span>
                                    <a href="rimuoviCarrello?id=<%= p.getIdProdotto() %>&taglia=<%= taglia %>" class="btn-remove">Rimuovi</a>
                                </div>
                            </div>
                    <%
                        }
                    %>
                </div>

                <div class="cart-summary-box">
                    <h3>Riepilogo Ordine</h3>
                    <p style="color:#555;">Numero articoli: <b><%= carrello.getArticoli().size() %></b></p>
                    <p style="color:#555; font-size: 0.9em;">Spedizione: <span style="color:green; font-weight:bold;">Gratuita</span></p>
                    
                    <div class="total-row" style="font-size: 1.1em; margin: 10px 0; font-weight: normal;">
                        <span>Imponibile:</span>
                        <span>€ <%= String.format("%.2f", carrello.getPrezzoNetto()) %></span>
                    </div>
                    <div class="total-row" style="font-size: 1.1em; margin: 10px 0; font-weight: normal;">
                        <span>IVA (22%):</span>
                        <span>€ <%= String.format("%.2f", carrello.getIva()) %></span>
                    </div>
                    <hr style="border: 0; border-top: 1px solid #ccc; margin: 15px 0;">
                    <div class="total-row">
                        <span>Totale:</span>
                        <span>€ <%= String.format("%.2f", carrello.getPrezzoTotale()) %></span>
                    </div>
                    
                    <a href="checkout" class="btn-checkout" style="display: block; text-align: center; background-color: #000; color: #fff; padding: 15px; text-decoration: none; font-weight: bold; margin-top: 15px;">
    Procedi all'acquisto</a>
                </div>
        <%
            }
        %>
    </div>

    <%@ include file="footer.jsp" %>

    <script>
        function submitCartQty(id, taglia, val) {
            var hiddenInput = document.getElementById("hidden-qty-" + id + "-" + taglia);
            if (hiddenInput) {
                var intVal = parseInt(val);
                if (!isNaN(intVal) && intVal >= 1) {
                    hiddenInput.value = intVal;
                    hiddenInput.form.submit();
                } else if (intVal === 0) {
                    // Se si imposta la quantità a 0, si reindirizza alla rimozione dell'articolo
                    window.location.href = "rimuoviCarrello?id=" + id + "&taglia=" + taglia;
                }
            }
        }
    </script>
</body>
</html>
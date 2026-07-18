<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="sneakpeak.model.Carrello" %>
<%@ page import="sneakpeak.model.Prodotto" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Il tuo Carrello - SneakPeak</title>
    
    <style>
        /* ==========================================================================
           GUIDA COMPLETA AL CSS DEL CARRELLO (Spiegata passo dopo passo)
           ========================================================================== */

        /* 1. CONTENITORE GENERALE ESTERNO
           Unisce la lista dei prodotti (sinistra) e il riepilogo del prezzo (destra). */
        .cart-wrapper {
            display: flex;            /* Attiva Flexbox: affianca la lista e il riepilogo in orizzontale */
            flex-wrap: wrap;          /* Se lo schermo è piccolo (es. smartphone), sposta il riepilogo sotto la lista */
            gap: 30px;                /* Crea un'intercapedine vuota di 30px tra le due colonne */
            max-width: 1200px;        /* Impedisce alla pagina di allargarsi oltre i 1200px su schermi enormi */
            margin: 40px auto;        /* 40px di spazio sopra/sotto il carrello; 'auto' centra tutto il blocco nella pagina */
            padding: 0 20px;          /* Crea un cuscinetto di 20px ai lati destro e sinistro per non far toccare i bordi */
        }

        /* 2. COLONNA DI SINISTRA (Lista dei prodotti)
           Deve occupare più spazio rispetto al riepilogo dei prezzi. */
        .cart-items-list {
            flex: 2;                  /* Proporzione 2:1. Dice al browser di dare a questa colonna il doppio dello spazio rispetto alla destra */
            min-width: 320px;         /* Impedisce alla lista di stringersi sotto i 320px, preservando la leggibilità */
        }

        /* 3. IL SINGOLO PRODOTTO DENTRO IL CARRELLO (La riga del prodotto) */
        .cart-item-row {
            display: flex;            /* Allinea in orizzontale gli elementi interni (Nome, Marca, Prezzo, Tasto Rimuovi) */
            align-items: center;      /* Centra verticalmente tutti gli elementi della riga sulla stessa linea immaginaria */
            justify-content: space-between; /* Spinge il nome tutto a sinistra e il prezzo/tasto tutto a destra, lasciando spazio in mezzo */
            border-bottom: 1px solid #E0E0E0; /* Disegna una linea grigia sottilissima sotto ogni prodotto per separarli visivamente */
            padding: 20px 0;          /* Aggiunge 20px di spazio vuoto sopra e sotto il prodotto per farlo "respirare" */
        }

        /* Dettagli testuali del prodotto */
        .item-info h4 {
            margin: 0 0 5px 0;        /* Azzera i margini, lasciando solo 5px di spazio sotto il titolo per staccarlo dalla marca */
            font-size: 1.2em;
            color: #2F4F4F;           /* Grigio fumo (colore del brand) */
        }
        .item-info p {
            margin: 0;                /* Rimuove i margini di default del paragrafo della marca */
            color: #888888;           /* Grigio chiaro per la marca */
            font-size: 0.9em;
        }

        /* Prezzo del singolo prodotto */
        .item-price {
            font-weight: bold;        /* Testo in grassetto */
            font-size: 1.1em;
            color: #000000;           /* Nero puro */
        }

        /* LINK / BOTTONE PER RIMUOVERE IL PRODOTTO */
        .btn-remove {
            color: #FF3B30;           /* Rosso vivo per comunicare un'azione di eliminazione/pericolo */
            text-decoration: none;    /* Toglie la sottolineatura classica dei link */
            font-size: 0.9em;
            font-weight: bold;
            margin-left: 20px;        /* Stacca il link di 20px dal prezzo per non farli accavallare */
        }
        .btn-remove:hover {
            text-decoration: underline; /* Fa comparire la sottolineatura solo quando l'utente ci passa sopra col mouse */
        }

        /* 4. COLONNA DI DESTRA (Il Box del Riepilogo Prezzi) */
        .cart-summary-box {
            flex: 1;                  /* Proporzione 1: prende meno spazio rispetto alla lista prodotti */
            min-width: 300px;         /* Non si stringerà mai sotto i 300px */
            background-color: #F9F9F9;/* Sfondo grigio chiarissimo per differenziarlo dallo sfondo bianco del sito */
            border: 1px solid #E0E0E0;/* Bordino grigio chiaro tutto intorno al box */
            border-radius: 8px;       /* Arrotonda gli angoli del box di 8 pixel (effetto moderno) */
            padding: 25px;            /* Spazio interno di sicurezza: impedisce ai testi dentro il box di toccare i suoi bordi */
            height: fit-content;      /* Il box è alto solo quanto i testi che contiene, non si allunga fino al fondo della pagina */
        }

        .cart-summary-box h3 {
            margin-top: 0;            /* Elimina lo spazio vuoto sopra il titolo "Riepilogo Ordine" */
            color: #2F4F4F;           /* Grigio fumo */
            border-bottom: 2px solid #2F4F4F; /* Linea spessa grigio fumo sotto il titolo del riepilogo */
            padding-bottom: 10px;     /* Spazio tra il titolo e la linea appena creata */
        }

        /* Riga del Totale all'interno del box */
        .total-row {
            display: flex;            /* Affianca la scritta "Totale" e la cifra del prezzo */
            justify-content: space-between; /* Spinge la parola "Totale" a sinistra e la cifra a destra */
            font-size: 1.4em;         /* Ingrandisce il testo del totale rispetto al resto */
            font-weight: bold;        /* Tutto in grassetto */
            margin: 25px 0;           /* Crea 25px di spazio vuoto sopra e sotto la riga del totale */
        }

        /* IL BOTTONE DI CHECKOUT (Procedi all'acquisto) */
        .btn-checkout {
            display: block;           /* Fa comportare il link come un blocco solido (come un rettangolo) */
            background-color: #39FF14;/* Verde neon (il colore d'azione principale del brand) */
            color: #000000;           /* Testo nero per garantire un contrasto perfetto e leggibile sul verde */
            text-align: center;       /* Centra la scritta "Procedi all'acquisto" dentro il rettangolo */
            padding: 15px;            /* Altrezza del bottone (spazio interno sopra e sotto la scritta) */
            text-decoration: none;    /* Elimina la sottolineatura del link */
            font-weight: bold;        /* Testo in grassetto */
            border-radius: 5px;       /* Arrotonda gli angoli del bottone */
            transition: 0.3s;         /* Rende l'animazione del cambio colore fluida e morbida (dura 0.3 secondi) */
        }
        .btn-checkout:hover {
            background-color: #32E012;/* Quando il mouse ci passa sopra, il verde diventa leggermente più scuro */
            box-shadow: 0px 4px 10px rgba(0,0,0,0.15); /* Aggiunge un'ombra sfumata sotto il bottone, facendolo sembrare "sollevato" */
        }
        
        /* Pulsanti e input di quantità */
        .btn-qty {
            background-color: #e0e0e0;
            border: none;
            border-radius: 4px;
            width: 30px;
            height: 30px;
            font-size: 1.1em;
            font-weight: bold;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: 0.2s;
        }
        .btn-qty:hover:not(:disabled) {
            background-color: #39FF14;
            color: #000;
        }
        .btn-qty:disabled {
            opacity: 0.4;
            cursor: not-allowed;
        }
        .qty-input {
            width: 45px;
            text-align: center;
            padding: 5px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 1.05em;
            font-weight: bold;
            margin: 0 5px;
        }
        /* Rimuove freccette standard input number */
        .qty-input::-webkit-outer-spin-button,
        .qty-input::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }
        .qty-input {
            -moz-appearance: textfield;
        }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <h2 style="text-align:center; margin-top:30px;">Il tuo Carrello</h2>

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
                        // Raggruppiamo gli articoli per calcolare la quantità e preservare l'ordine d'inserimento
                        java.util.Map<Prodotto, Integer> articoliQuantita = new java.util.LinkedHashMap<>();
                        for (Prodotto p : carrello.getArticoli()) {
                            articoliQuantita.put(p, articoliQuantita.getOrDefault(p, 0) + 1);
                        }

                        for (java.util.Map.Entry<Prodotto, Integer> entry : articoliQuantita.entrySet()) {
                            Prodotto p = entry.getKey();
                            int qty = entry.getValue();
                    %>
                            <div class="cart-item-row">
                                <div style="display: flex; align-items: center; flex-grow: 1;">
                                    <div style="margin-right: 20px;">
                                        <img src="<%= p.getImmagine() %>" alt="<%= p.getNome() %>" style="width: 80px; height: 80px; object-fit: contain; border-radius: 5px; border: 1px solid #ddd;">
                                    </div>
                                    <div class="item-info">
                                        <h4 style="margin: 0 0 5px 0;"><%= p.getNome() %></h4>
                                        <p style="margin: 0; color: #666;">Marca: <%= p.getMarca() %></p>
                                    </div>
                                </div>
                                <div style="display:flex; align-items:center;">
                                    <form action="modificaCarrello" method="POST" style="display:flex; align-items:center; margin-right: 15px;">
                                        <input type="hidden" name="id" value="<%= p.getIdProdotto() %>">
                                        <input type="hidden" id="hidden-qty-<%= p.getIdProdotto() %>" name="quantita" value="<%= qty %>">
                                        <button type="button" class="btn-qty" <%= (qty <= 1) ? "disabled" : "" %> onclick="submitCartQty(<%= p.getIdProdotto() %>, <%= qty - 1 %>)">-</button>
                                        <input type="number" min="1" class="qty-input" value="<%= qty %>" onchange="submitCartQty(<%= p.getIdProdotto() %>, this.value)">
                                        <button type="button" class="btn-qty" onclick="submitCartQty(<%= p.getIdProdotto() %>, <%= qty + 1 %>)">+</button>
                                    </form>
                                    <span class="item-price">€ <%= String.format("%.2f", p.getPrezzo() * qty) %></span>
                                    <a href="rimuoviCarrello?id=<%= p.getIdProdotto() %>" class="btn-remove">Rimuovi</a>
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
        function submitCartQty(id, val) {
            var hiddenInput = document.getElementById("hidden-qty-" + id);
            if (hiddenInput) {
                var intVal = parseInt(val);
                if (!isNaN(intVal) && intVal >= 1) {
                    hiddenInput.value = intVal;
                    hiddenInput.form.submit();
                } else if (intVal === 0) {
                    // Se si imposta la quantità a 0, si reindirizza alla rimozione dell'articolo
                    window.location.href = "rimuoviCarrello?id=" + id;
                }
            }
        }
    </script>
</body>
</html>
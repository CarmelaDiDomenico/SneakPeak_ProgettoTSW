<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="sneakpeak.model.Prodotto" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dettaglio Prodotto - SneakPeak</title>
    
    <style>
        /* =========================================================
           SPIEGAZIONE CSS:
           Ogni blocco definisce l'aspetto di un "pezzo" della pagina.
           ========================================================= */

        /* 1. IL CONTENITORE PRINCIPALE */
        .product-container {
            display: flex;         /* Attiva Flexbox. Dice al browser: "Metti i figli di questo div uno accanto all'altro in riga" */
            flex-wrap: wrap;       /* Se lo schermo è troppo piccolo (es. cellulare), manda gli elementi a capo invece di schiacciarli */
            justify-content: center; /* Centra tutto il blocco in mezzo allo schermo orizzontalmente */
            gap: 40px;             /* Crea uno spazio vuoto di 40 pixel tra l'immagine a sinistra e i testi a destra */
            max-width: 1000px;     /* Impedisce alla pagina di allargarsi all'infinito su schermi giganti. Si ferma a 1000px */
            margin: 50px auto;     /* margin: [Sopra/Sotto] [Destra/Sinistra]. 50px di spazio sopra/sotto, e 'auto' centra il div nello schermo */
            padding: 20px;         /* Spazio "cuscinetto" interno: evita che il testo tocchi i bordi del contenitore */
        }

        /* 2. LA SEZIONE IMMAGINE (Sinistra) */
        .product-image {
            flex: 1;               /* Dice al div di occupare 1 porzione di spazio disponibile. */
            min-width: 300px;      /* L'immagine non diventerà mai più stretta di 300px, nemmeno stringendo la finestra */
            background-color: #f5f5f5; /* Un grigio chiarissimo per simulare lo sfondo di uno studio fotografico */
            border-radius: 10px;   /* Arrotonda gli angoli del riquadro dell'immagine di 10 pixel (effetto moderno) */
            display: flex;         /* Attiviamo Flexbox anche qui per centrare il testo finto dell'immagine */
            align-items: center;   /* Centra il contenuto verticalmente */
            justify-content: center; /* Centra il contenuto orizzontalmente */
            height: 400px;         /* Altezza fissa del box immagine */
            border: 1px solid #ddd; /* Un bordino grigio molto sottile per delineare il contorno */
        }

        /* 3. LA SEZIONE DETTAGLI/TESTO (Destra) */
        .product-info {
            flex: 1;               /* Occupa un'altra porzione di spazio, diventando grande quanto l'immagine (layout 50-50) */
            min-width: 300px;      /* Non stringere i testi sotto i 300px */
            display: flex;         
            flex-direction: column; /* Importante: dice ai testi di mettersi in colonna (uno sotto l'altro), non in riga! */
            justify-content: center; /* Centra verticalmente il blocco di testi rispetto all'altezza dell'immagine */
        }

        /* 4. STILI PER I TESTI SPECIFICI */
        .product-info h2 {
            font-size: 2.2em;      /* Ingrandisce il titolo (nome scarpa). 'em' è relativo alla grandezza base del testo */
            margin-bottom: 5px;    /* Spazio sotto il titolo per staccarlo dalla marca */
            color: #2F4F4F;        /* Il tuo colore di design: Grigio fumo */
        }

        .product-brand {
            color: #888;           /* Grigio medio per far risaltare meno la marca rispetto al titolo */
            font-size: 1.1em;
            margin-top: 0;         /* Toglie lo spazio vuoto sopra, avvicinandolo al titolo */
        }

        .product-price {
            font-size: 1.8em;      /* Prezzo bello grande */
            font-weight: bold;     /* Testo in grassetto */
            color: #000;           /* Nero puro per massima leggibilità */
            margin: 20px 0;        /* 20px di spazio sopra e sotto il prezzo. 0 spazio a destra e sinistra */
        }

        .product-desc {
            line-height: 1.6;      /* Aumenta lo spazio tra una riga e l'altra del paragrafo, rendendo la lettura meno faticosa */
            color: #555;
        }

        /* 5. IL BOTTONE DI ACQUISTO */
        .btn-add {
            background-color: #39FF14; /* Il tuo colore di design: Verde neon */
            color: #000;           /* Testo nero per fare alto contrasto sul verde brillante */
            border: none;          /* Rimuove il bordino brutto che i browser mettono di default ai bottoni */
            padding: 15px 30px;    /* Ingrandisce il bottone. 15px di spazio interno verticale, 30px orizzontale */
            font-size: 1.1em;
            font-weight: bold;
            border-radius: 5px;    /* Arrotonda leggermente gli angoli del bottone */
            cursor: pointer;       /* Quando passi col mouse, la freccetta diventa una "manina" cliccabile */
            margin-top: 20px;      /* Lo spinge un po' in giù rispetto alla descrizione */
            transition: 0.3s;      /* Effetto morbido: le modifiche al colore (hover) avverranno gradualmente in 0.3 secondi */
        }

        /* 6. EFFETTO HOVER DEL BOTTONE (Quando il mouse ci passa sopra) */
        .btn-add:hover {
            background-color: #32E012; /* Un verde leggermente più scuro per dare l'illusione di averlo premuto */
            box-shadow: 0px 4px 8px rgba(0,0,0,0.2); /* Aggiunge un'ombra morbida sotto il bottone (nero al 20% di trasparenza) */
        }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <%
        // Recuperiamo il prodotto (o l'errore) che la Servlet ci ha mandato
        Prodotto p = (Prodotto) request.getAttribute("prodottoSingolo");
        String errore = (String) request.getAttribute("errore");

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
                    
                    <div class="product-price">€ <%= String.format("%.2f", p.getPrezzo()) %></div>
                    
                    <p class="product-desc"><%= p.getDescrizione() %></p>
                    
                    <form action="aggiungiCarrello" method="POST">
    <input type="hidden" name="id" value="<%= p.getIdProdotto() %>">
    <button type="submit" class="btn-add">Aggiungi al Carrello</button>
</form>
                </div>
                
            </div>
    <%
        }
    %>

    <%@ include file="footer.jsp" %>

</body>
</html>
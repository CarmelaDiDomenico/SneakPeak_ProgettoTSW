<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Aiuto e FAQ - SneakPeak</title>
        <style>
            .container {
                width: 100%;
                box-sizing: border-box;
                max-width: 800px;
                margin: 40px auto;
                padding: 20px;
                background-color: #f9f9f9;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            h2 {
                color: #333;
                border-bottom: 2px solid #ccc;
                padding-bottom: 10px;
            }

            h3 {
                color: #2F4F4F;
                margin-top: 25px;
            }

            p {
                line-height: 1.6;
                color: #555;
                font-size: 16px;
            }

            .faq-item {
                margin-bottom: 20px;
            }

            .faq-question {
                font-weight: bold;
                color: #000;
            }

            .faq-answer {
                color: #555;
                margin-top: 5px;
            }

            .contact-box {
                margin-top: 40px;
                padding: 15px;
                background-color: #e9ecef;
                border-radius: 5px;
                text-align: center;
            }
        </style>
    </head>

    <body>

        <jsp:include page="header.jsp" />

        <div class="container">
            <h2>Centro Assistenza e FAQ</h2>

            <p>Benvenuto nel centro di supporto di SneakPeak. Trova subito le risposte alle domande più frequenti qui
                sotto.</p>

            <h3>FAQ - Domande Frequenti</h3>

            <div class="faq-item">
                <div class="faq-question">1. Quanto tempo impiega la spedizione?</div>
                <div class="faq-answer">Le spedizioni avvengono solitamente entro 2-5 giorni lavorativi dalla data di
                    conferma dell'ordine.</div>
            </div>

            <div class="faq-item">
                <div class="faq-question">2. I prodotti sono 100% originali?</div>
                <div class="faq-answer">Assolutamente sì. Il nostro team verifica meticolosamente ogni prodotto per
                    garantirne l'autenticità. Tutte le sneaker provengono da fornitori ufficiali o rivenditori
                    autorizzati.</div>
            </div>

            <div class="faq-item">
                <div class="faq-question">3. Posso fare un reso o un cambio taglia?</div>
                <div class="faq-answer">Certamente. Offriamo la possibilità di restituire il prodotto o cambiare la
                    taglia entro 14 giorni dalla ricezione, purché le scarpe non siano state indossate e la scatola sia
                    integra.</div>
            </div>

            <div class="faq-item">
                <div class="faq-question">4. Quali metodi di pagamento accettate?</div>
                <div class="faq-answer">Attualmente accettiamo Carte di Credito/Debito, PayPal e bonifico bancario (su
                    richiesta).</div>
            </div>

            <div class="contact-box">
                <h4>Hai bisogno di ulteriore supporto?</h4>
                <p>Scrivici all'indirizzo email <strong>supporto@sneakpeak.it</strong> o chiamaci al numero <strong>+39
                        0123 456 789</strong>.</p>
            </div>
        </div>

        <jsp:include page="footer.jsp" />

    </body>

    </html>
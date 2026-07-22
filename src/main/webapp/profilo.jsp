<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="sneakpeak.model.Utente" %>
<%@ page import="sneakpeak.model.Indirizzo" %>
<%@ page import="sneakpeak.model.MetodoPagamento" %>
<%@ page import="java.util.List" %>
<%
    // Sicurezza: blocchiamo gli accessi diretti alla pagina senza login
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
    <title>Il tuo Profilo - SneakPeak</title>
    <style>
        .container {
            width: 100%;
            max-width: 800px;
            box-sizing: border-box;
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
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .container input[type="text"], .container input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .container input:focus {
            border-color: #39FF14;
            outline: none;
            box-shadow: 0 0 5px rgba(57, 255, 20, 0.5);
        }
        button {
            background-color: #39FF14;
            color: black;
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            font-size: 16px;
        }
        button:hover {
            background-color: #2eb80f;
            color: white;
        }
        .error {
            color: red;
            font-size: 14px;
            margin-top: 5px;
            display: block;
        }
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            font-weight: bold;
            text-align: center;
        }
        .alert-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        
        .indirizzo-card {
            background-color: white;
            border: 1px solid #ddd;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 4px;
        }
    </style>
</head>
<body>

    <!-- IL MENU (Inclusione fragment) -->
    <jsp:include page="header.jsp" />

    <div class="container">
        
        <% if ("true".equals(request.getParameter("successo"))) { %>
            <div class="alert alert-success">Profilo aggiornato con successo!</div>
        <% } else if ("true".equals(request.getParameter("errore"))) { %>
            <div class="alert alert-error">Errore durante l'aggiornamento. Riprova.</div>
        <% } %>

        <h2 class="section-title">I Tuoi Dati Personali</h2>
        
        <form action="profilo" method="POST" id="formProfilo">
            <div class="form-group">
                <label>Email (Non modificabile):</label>
                <input type="text" value="<%= utente.getEmail() %>" disabled style="background-color: #e9ecef;">
            </div>

            <div class="form-group">
                <label for="nome">Nome:</label>
                <input type="text" id="nome" name="nome" value="<%= utente.getNome() %>" placeholder="Inserisci il tuo nome">
                <span class="error" id="errorNome"></span>
            </div>

            <div class="form-group">
                <label for="cognome">Cognome:</label>
                <input type="text" id="cognome" name="cognome" value="<%= utente.getCognome() %>" placeholder="Inserisci il tuo cognome">
                <span class="error" id="errorCognome"></span>
            </div>

            <div class="form-group">
                <label for="password">Nuova Password (lascia vuoto per non cambiarla):</label>
                <input type="password" id="password" name="password" placeholder="Minimo 8 caratteri">
                <span class="error" id="errorPassword"></span>
            </div>

            <button type="submit">Salva Modifiche</button>
        </form>

        <br><br>

        <h2 class="section-title">I Tuoi Indirizzi di Spedizione</h2>
        
        <%
            // Questa lista ci arriva dalla ProfiloServlet
            List<Indirizzo> indirizzi = (List<Indirizzo>) request.getAttribute("listaIndirizzi");
            if (indirizzi != null && !indirizzi.isEmpty()) {
                for (Indirizzo ind : indirizzi) {
        %>
            <div class="indirizzo-card" style="position: relative;">
                <p><strong>Via/Piazza:</strong> <%= ind.getVia() %> <%= ind.getCivico() %></p>
                <p><strong>Città:</strong> <%= ind.getCitta() %> (<%= ind.getProvincia() %>) - <%= ind.getCap() %></p>
                <p><strong>Nazione:</strong> <%= ind.getNazione() %></p>
                <form action="eliminaIndirizzo" method="POST" style="position: absolute; top: 15px; right: 15px;" onsubmit="requireConfirm(event, 'Vuoi davvero eliminare questo indirizzo?');">
                    <input type="hidden" name="idIndirizzo" value="<%= ind.getIdIndirizzo() %>">
                    <button type="submit" style="background-color: transparent; color: #d9534f; border: 1px solid #d9534f; padding: 5px 10px; font-size: 12px;">Elimina</button>
                </form>
            </div>
        <%
                }
            } else {
        %>
            <p>Non hai ancora salvato nessun indirizzo. Potrai aggiungerne uno al tuo primo acquisto!</p>
        <%
            }
        %>

        <!-- FORM PER AGGIUNGERE UN NUOVO INDIRIZZO -->
        <div style="background-color: #fff; padding: 20px; border: 1px solid #ddd; border-radius: 4px; margin-top: 20px;">
            <h3 style="color: #2F4F4F; margin-top: 0;">Aggiungi un nuovo indirizzo</h3>
            <form action="aggiungiIndirizzo" method="POST" style="display: flex; flex-wrap: wrap; gap: 10px;">
                <div style="flex: 1 1 45%; min-width: 200px;">
                    <label>Via/Piazza:</label>
                    <input type="text" name="via" required style="width: 100%; padding: 8px;">
                </div>
                <div style="flex: 1 1 45%; min-width: 100px;">
                    <label>Civico:</label>
                    <input type="text" name="civico" required style="width: 100%; padding: 8px;">
                </div>
                <div style="flex: 1 1 45%; min-width: 200px;">
                    <label>Città:</label>
                    <input type="text" name="citta" required style="width: 100%; padding: 8px; box-sizing: border-box;" pattern="[A-Za-zÀ-ÿ\s]+" title="Solo lettere">
                </div>
                <div style="flex: 1 1 45%; min-width: 100px;">
                    <label>CAP:</label>
                    <input type="text" name="cap" required style="width: 100%; padding: 8px; box-sizing: border-box;" maxlength="5" pattern="\d{5}" title="Il CAP deve essere di 5 numeri">
                </div>
                <div style="flex: 1 1 45%; min-width: 200px;">
                    <label>Provincia (Es. MI):</label>
                    <input type="text" name="provincia" required style="width: 100%; padding: 8px; box-sizing: border-box;" maxlength="2" pattern="[A-Za-z]{2}" title="La provincia deve essere di 2 lettere (es. NA, MI)">
                </div>
                <div style="flex: 1 1 45%; min-width: 200px;">
                    <label>Nazione:</label>
                    <input type="text" name="nazione" required style="width: 100%; padding: 8px; box-sizing: border-box;" pattern="[A-Za-zÀ-ÿ\s]+" title="Solo lettere">
                </div>
                <div style="flex: 1 1 100%; margin-top: 10px;">
                    <button type="submit" style="width: 100%; background-color: #337ab7; color: white;">Aggiungi Indirizzo</button>
                </div>
            </form>
        </div>

        <br><br>

        <h2 class="section-title">I Tuoi Metodi di Pagamento</h2>
        
        <%
            List<MetodoPagamento> pagamenti = (List<MetodoPagamento>) request.getAttribute("listaPagamenti");
            if (pagamenti != null && !pagamenti.isEmpty()) {
                for (MetodoPagamento pag : pagamenti) {
        %>
            <div class="indirizzo-card" style="position: relative;">
                <p><strong>Intestatario:</strong> <%= pag.getIntestatario() %></p>
                <p><strong>Tipo:</strong> <%= pag.getTipo() %></p>
                <form action="eliminaPagamento" method="POST" style="position: absolute; top: 15px; right: 15px;" onsubmit="requireConfirm(event, 'Vuoi davvero eliminare questo metodo di pagamento?');">
                    <input type="hidden" name="idPagamento" value="<%= pag.getIdPagamento() %>">
                    <button type="submit" style="background-color: transparent; color: #d9534f; border: 1px solid #d9534f; padding: 5px 10px; font-size: 12px;">Elimina</button>
                </form>
            </div>
        <%
                }
            } else {
        %>
            <p>Non hai salvato nessun metodo di pagamento.</p>
        <%
            }
        %>


        <!-- Pulsante "Torna allo Storico Ordini" -->
        <br>
        <a href="storicoOrdini" style="display:inline-block; padding: 10px; background-color: #333; color: white; text-decoration: none; border-radius: 4px;">Vai allo Storico Ordini</a>

    </div>

    <!-- IL PIE' DI PAGINA (Inclusione fragment) -->
    <jsp:include page="footer.jsp" />

    <script>
        // VALIDAZIONE LATO CLIENT (Rispetta i requisiti della checklist!)
        document.getElementById('formProfilo').addEventListener('submit', function(event) {
            let formValido = true;

            // Pulisci vecchi errori
            document.getElementById('errorNome').innerText = "";
            document.getElementById('errorCognome').innerText = "";
            document.getElementById('errorPassword').innerText = "";

            const regexNomeCognome = /^[A-Za-zÀ-ÿ\s]{2,50}$/;

            // Controllo Nome
            const nome = document.getElementById('nome').value.trim();
            if (!regexNomeCognome.test(nome)) {
                document.getElementById('errorNome').innerText = "Inserisci un nome valido (solo lettere).";
                formValido = false;
            }

            // Controllo Cognome
            const cognome = document.getElementById('cognome').value.trim();
            if (!regexNomeCognome.test(cognome)) {
                document.getElementById('errorCognome').innerText = "Inserisci un cognome valido (solo lettere).";
                formValido = false;
            }

            // Controllo Password (solo se l'utente ha provato a scriverci qualcosa)
            const password = document.getElementById('password').value;
            if (password.length > 0 && password.length < 8) {
                document.getElementById('errorPassword').innerText = "La nuova password deve essere lunga almeno 8 caratteri.";
                formValido = false;
            }

            // Se c'è un errore blocco l'invio al server
            if (!formValido) {
                event.preventDefault();
            }
        });
    </script>
</body>
</html>

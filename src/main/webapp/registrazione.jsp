<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SneakPeak - Registrazione</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/registrazione.css">
</head>
<body>

    <%@ include file="header.jsp" %>

    <div class="container">
        <h2>Crea il tuo Account</h2>
        
        <%-- Messaggio di errore inviato dalla servlet (lato server) --%>
        <%
            String errore = (String) request.getAttribute("errore");
            if (errore != null) {
        %>
                <div style="background-color: #ffcccc; color: #cc0000; padding: 10px; border-radius: 4px; margin-bottom: 20px; text-align: center; font-weight: bold; font-size: 0.9em;">
                    <%= errore %>
                </div>
        <%
            }
        %>

        <form id="registrationForm" action="registrazione" method="POST" onsubmit="return validateForm(event)">
            <div class="form-group">
                <label for="nome">Nome</label>
                <input type="text" id="nome" name="nome">
                <span class="error-message" id="error-nome"></span>
            </div>
            
            <div class="form-group">
                <label for="cognome">Cognome</label>
                <input type="text" id="cognome" name="cognome">
                <span class="error-message" id="error-cognome"></span>
            </div>
            
            <div class="form-group">
                <label for="email">Indirizzo Email</label>
                <input type="text" id="email" name="email">
                <span class="error-message" id="error-email"></span>
            </div>
            
            <div class="form-group">
                <label for="password">Password (minimo 6 caratteri)</label>
                <input type="password" id="password" name="password">
                <span class="error-message" id="error-password"></span>
            </div>
            
            <div class="form-group">
                <label for="confermaPassword">Conferma Password</label>
                <input type="password" id="confermaPassword" name="confermaPassword">
                <span class="error-message" id="error-confermaPassword"></span>
            </div>
            
            <button type="submit" class="btn-submit">Registrati</button>
        </form>
        
        <div class="link-login">
            Hai già un account? <a href="login.jsp">Accedi qui</a>
        </div>
    </div>

    <%@ include file="footer.jsp" %>

    <script>
        // Stato della validità dell'email tramite AJAX
        let emailValid = false;

        // 1. AJAX per il controllo email duplicata in tempo reale
        document.getElementById('email').addEventListener('blur', function() {
            let emailInput = this.value.trim();
            let errorSpan = document.getElementById('error-email');
            
            if (emailInput === "") {
                errorSpan.textContent = "Il campo Email è obbligatorio.";
                errorSpan.style.color = "red";
                emailValid = false;
                return;
            }
            
            // Regex base per la sintassi dell'email
            let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(emailInput)) {
                errorSpan.textContent = "Inserisci un indirizzo email valido.";
                errorSpan.style.color = "red";
                emailValid = false;
                return;
            }
            
            // Chiamata AJAX con Fetch API
            fetch('checkEmail?email=' + encodeURIComponent(emailInput))
                .then(response => {
                    if (!response.ok) {
                        throw new Error("Errore di rete");
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.disponibile) {
                        errorSpan.textContent = "Email disponibile!";
                        errorSpan.style.color = "green";
                        emailValid = true;
                    } else {
                        errorSpan.textContent = "Questa email è già associata a un account.";
                        errorSpan.style.color = "red";
                        emailValid = false;
                    }
                })
                .catch(error => {
                    console.error("Errore controllo email:", error);
                    errorSpan.textContent = "Impossibile verificare l'email in questo momento.";
                    errorSpan.style.color = "orange";
                    emailValid = false;
                });
        });

        // 2. Validazione di tutti i campi JavaScript prima dell'invio del form (lato client)
        function validateForm(event) {
            let isValid = true;
            
            // Recupero dei valori
            let nome = document.getElementById('nome').value.trim();
            let cognome = document.getElementById('cognome').value.trim();
            let email = document.getElementById('email').value.trim();
            let password = document.getElementById('password').value;
            let confermaPassword = document.getElementById('confermaPassword').value;
            
            // Reset dei messaggi di errore
            document.getElementById('error-nome').textContent = "";
            document.getElementById('error-cognome').textContent = "";
            document.getElementById('error-email').textContent = "";
            document.getElementById('error-password').textContent = "";
            document.getElementById('error-confermaPassword').textContent = "";
            
            // Validazione Nome
            if (nome === "") {
                document.getElementById('error-nome').textContent = "Il nome è obbligatorio.";
                isValid = false;
            }
            
            // Validazione Cognome
            if (cognome === "") {
                document.getElementById('error-cognome').textContent = "Il cognome è obbligatorio.";
                isValid = false;
            }
            
            // Validazione Email
            if (email === "") {
                document.getElementById('error-email').textContent = "L'email è obbligatoria.";
                isValid = false;
            } else {
                let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    document.getElementById('error-email').textContent = "Inserisci un indirizzo email valido.";
                    isValid = false;
                } else if (!emailValid) {
                    document.getElementById('error-email').textContent = "L'email inserita non è disponibile o non verificata.";
                    isValid = false;
                }
            }
            
            // Validazione Password
            if (password.length < 6) {
                document.getElementById('error-password').textContent = "La password deve contenere almeno 6 caratteri.";
                isValid = false;
            }
            
            // Validazione Conferma Password
            if (confermaPassword === "") {
                document.getElementById('error-confermaPassword').textContent = "Conferma la tua password.";
                isValid = false;
            } else if (password !== confermaPassword) {
                document.getElementById('error-confermaPassword').textContent = "Le password non coincidono.";
                isValid = false;
            }
            
            // Se qualcosa non va bene, blocchiamo l'invio del form
            if (!isValid) {
                event.preventDefault();
            }
            
            return isValid;
        }
    </script>
</body>
</html>

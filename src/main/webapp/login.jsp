<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <link rel="icon" type="image/png" href="assets/logo.png">
    <meta charset="UTF-8">
    <title>SneakPeak - Login</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/login.css">
</head>
<body>

    <%@ include file="header.jsp" %>

    <div class="container">
        <h2>Accedi al tuo Account</h2>
        
        <%-- Messaggio di successo se proviene da registrazione avvenuta --%>
        <%
            String registrato = request.getParameter("registrato");
            if ("true".equals(registrato)) {
        %>
                <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 4px; margin-bottom: 20px; text-align: center; font-weight: bold; font-size: 0.9em;">
                    Registrazione completata con successo! Inserisci le tue credenziali per accedere.
                </div>
        <%
            }
        %>
        
        <%-- Messaggio di errore se il login fallisce --%>
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

        <form id="loginForm" action="login" method="POST" onsubmit="return validateLogin(event)">
            <div class="form-group">
                <label for="email">Indirizzo Email</label>
                <input type="text" id="email" name="email">
                <span class="error-message" id="error-email"></span>
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password">
                <span class="error-message" id="error-password"></span>
            </div>
            
            <button type="submit" class="btn-submit">Accedi</button>
        </form>
        
        <div class="link-registrati">
            Non hai ancora un account? <a href="registrazione.jsp">Registrati qui</a>
        </div>
    </div>

    <%@ include file="footer.jsp" %>

    <script>
        function validateLogin(event) {
            let isValid = true;
            let email = document.getElementById('email').value.trim();
            let password = document.getElementById('password').value;
            
            // Reset degli errori
            document.getElementById('error-email').textContent = "";
            document.getElementById('error-password').textContent = "";
            
            // Validazione Email
            if (email === "") {
                document.getElementById('error-email').textContent = "L'email è obbligatoria.";
                isValid = false;
            } else {
                let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    document.getElementById('error-email').textContent = "Inserisci un formato email valido.";
                    isValid = false;
                }
            }
            
            // Validazione Password
            if (password === "") {
                document.getElementById('error-password').textContent = "La password è obbligatoria.";
                isValid = false;
            }
            
            if (!isValid) {
                event.preventDefault();
            }
            return isValid;
        }
    </script>
</body>
</html>


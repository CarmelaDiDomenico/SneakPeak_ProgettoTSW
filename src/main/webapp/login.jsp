<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SneakPeak - Login</title>
    <style>
        .container {
            max-width: 450px;
            margin: 50px auto;
            background-color: #f9f9f9;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        .container h2 {
            text-align: center;
            color: #2F4F4F;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
            color: #333;
        }
        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 1em;
        }
        .form-group input:focus {
            border-color: #2F4F4F;
            outline: none;
        }
        .error-message {
            font-size: 0.85em;
            color: red;
            display: block;
            margin-top: 5px;
            min-height: 1.2em;
        }
        .btn-submit {
            background-color: #39FF14;
            color: black;
            border: none;
            padding: 12px;
            width: 100%;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            font-size: 1.1em;
            margin-top: 10px;
        }
        .btn-submit:hover {
            background-color: #32E012;
        }
        .link-registrati {
            text-align: center;
            margin-top: 15px;
            font-size: 0.9em;
        }
        .link-registrati a {
            color: #2F4F4F;
            text-decoration: none;
            font-weight: bold;
        }
        .link-registrati a:hover {
            text-decoration: underline;
        }
    </style>
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

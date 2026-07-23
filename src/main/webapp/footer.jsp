<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div style="background-color: #2F4F4F; text-align: center; padding: 15px; margin-top: auto;">
    <p style="color: white; margin: 0;">&copy; 2026 SneakPeak - Progetto d'Esame TSW | Salvatore Valente & Carmela Di Domenico</p>
</div>

<!-- MODAL CUSTOM GLOBALE PER LE CONFERME (Sostituisce window.confirm nativo del browser) -->
<link rel="stylesheet" href="css/footer.css">

<div class="custom-modal-overlay" id="globalConfirmModal">
    <div class="custom-modal-box">
        <p id="globalConfirmMessage">Sei sicuro?</p>
        <button class="custom-modal-btn btn-cancel" type="button" onclick="closeCustomConfirm()">Annulla</button>
        <button class="custom-modal-btn btn-confirm" type="button" id="globalConfirmBtn">Conferma</button>
    </div>
</div>

<script>
    let formToSubmit = null;

    function showCustomConfirm(message, formElement) {
        document.getElementById('globalConfirmMessage').innerText = message;
        formToSubmit = formElement;
        document.getElementById('globalConfirmModal').style.display = 'flex';
    }

    function closeCustomConfirm() {
        document.getElementById('globalConfirmModal').style.display = 'none';
        formToSubmit = null;
    }

    document.getElementById('globalConfirmBtn').addEventListener('click', function() {
        if (formToSubmit) {
            formToSubmit.submit();
        }
        closeCustomConfirm();
    });

    // Funzione da usare negli onsubmit dei form per bloccare l'invio e mostrare il modale
    function requireConfirm(event, message) {
        event.preventDefault(); // Blocca l'invio nativo del form
        showCustomConfirm(message, event.target);
    }
</script>
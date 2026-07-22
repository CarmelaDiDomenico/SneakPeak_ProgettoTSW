<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div style="background-color: #2F4F4F; color: white; text-align: center; padding: 15px; margin-top: auto;">
    <p>&copy; 2026 SneakPeak - Progetto d'Esame TSW | Salvatore Valente & Carmela Di Domenico</p>
</div>

<!-- MODAL CUSTOM GLOBALE PER LE CONFERME (Sostituisce window.confirm nativo del browser) -->
<style>
    .custom-modal-overlay {
        display: none;
        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(0, 0, 0, 0.5); z-index: 100000;
        justify-content: center; align-items: center;
    }
    .custom-modal-box {
        background: white; padding: 25px 30px; border-radius: 8px;
        text-align: center; max-width: 400px; width: 90%;
        box-shadow: 0 4px 15px rgba(0,0,0,0.3); font-family: Arial, sans-serif;
    }
    .custom-modal-box p { font-size: 16px; margin-bottom: 25px; color: #333; line-height: 1.5; }
    .custom-modal-btn { padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; font-size: 14px; margin: 0 5px; transition: 0.2s; }
    .btn-cancel { background: #e0e0e0; color: #333; }
    .btn-cancel:hover { background: #ccc; }
    .btn-confirm { background: #d9534f; color: white; }
    .btn-confirm:hover { background: #c9302c; }
</style>

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
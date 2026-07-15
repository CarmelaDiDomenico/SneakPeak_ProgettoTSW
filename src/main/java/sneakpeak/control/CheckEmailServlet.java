package sneakpeak.control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sneakpeak.model.Utente;
import sneakpeak.model.UtenteDAO;

/**
 * Questa Servlet gestisce le richieste AJAX per verificare se un'email è già in uso.
 * Risponde in formato JSON: {"disponibile": true} o {"disponibile": false}.
 */
@WebServlet("/checkEmail")
public class CheckEmailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Impostiamo il tipo di risposta come JSON e la codifica UTF-8
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // 2. Leggiamo l'email inviata tramite AJAX (es. /checkEmail?email=test@test.com)
        String email = request.getParameter("email");
        boolean disponibile = true;
        
        if (email != null && !email.trim().isEmpty()) {
            UtenteDAO utenteDAO = new UtenteDAO();
            // Cerca se esiste già un utente con questa email
            Utente utente = utenteDAO.doRetrieveByEmail(email);
            
            // Se l'utente esiste già, allora l'email NON è disponibile!
            if (utente != null) {
                disponibile = false;
            }
        }
        
        // 3. Rispondiamo inviando un oggetto JSON come testo
        response.getWriter().write("{\"disponibile\": " + disponibile + "}");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}

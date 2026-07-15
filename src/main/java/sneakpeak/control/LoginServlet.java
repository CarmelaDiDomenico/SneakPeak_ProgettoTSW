package sneakpeak.control;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sneakpeak.model.Utente;
import sneakpeak.model.UtenteDAO;

/**
 * Servlet che gestisce la procedura di Login dell'utente.
 * Mappa l'indirizzo "/login" e gestisce le richieste POST per convalidare
 * le credenziali inserite dall'utente.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Se si accede a /login in GET, rimandiamo semplicemente alla pagina del form
        response.sendRedirect("login.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Recupero dei parametri inseriti dall'utente nel form
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // 2. Controllo preliminare di sicurezza (campi non vuoti)
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errore", "Inserire sia l'email che la password.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("/login.jsp");
            dispatcher.forward(request, response);
            return;
        }
        
        email = email.trim();
        
        // 3. Chiamata al DAO per controllare se le credenziali corrispondono nel DB
        UtenteDAO utenteDAO = new UtenteDAO();
        Utente utente = utenteDAO.doRetrieveByEmailAndPassword(email, password);
        
        if (utente != null) {
            // 4. Login Riuscito! Recuperiamo la sessione HTTP dell'utente (o ne creiamo una nuova)
            HttpSession session = request.getSession(true);
            
            // Inseriamo il Bean dell'utente in sessione col nome "utenteLoggato"
            session.setAttribute("utenteLoggato", utente);
            
            // Reindirizziamo l'utente alla Home Page
            response.sendRedirect("home");
        } else {
            // 5. Login Fallito! Impostiamo un messaggio di errore
            request.setAttribute("errore", "Credenziali errate. Riprova.");
            
            // Rimandiamo alla pagina di login mostrando l'errore
            RequestDispatcher dispatcher = request.getRequestDispatcher("/login.jsp");
            dispatcher.forward(request, response);
        }
    }
}

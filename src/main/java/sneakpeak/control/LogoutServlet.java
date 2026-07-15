package sneakpeak.control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet che gestisce il Logout dell'utente.
 * Mappa l'indirizzo "/logout" e invalida la sessione corrente dell'utente.
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Recuperiamo la sessione corrente dell'utente, senza crearne una nuova se non esiste (false)
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // 2. Invalida la sessione: cancella tutti gli attributi salvati in memoria per questa sessione
            session.invalidate();
        }
        
        // 3. Reindirizza l'utente alla Home Page dopo il logout
        response.sendRedirect("home");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}

package sneakpeak.control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sneakpeak.model.IndirizzoDAO;
import sneakpeak.model.Utente;

@WebServlet("/eliminaIndirizzo")
public class EliminaIndirizzoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");
        
        if (utente == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int idIndirizzo = Integer.parseInt(request.getParameter("idIndirizzo"));
            IndirizzoDAO dao = new IndirizzoDAO();
            
            // Passiamo anche idUtente per sicurezza: l'utente può eliminare solo i propri indirizzi
            boolean eliminato = dao.doDelete(idIndirizzo, utente.getIdUtente());
            
            if (eliminato) {
                response.sendRedirect("profilo?successo=true");
            } else {
                response.sendRedirect("profilo?errore=true");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("profilo?errore=true");
        }
    }
}

package sneakpeak.control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sneakpeak.model.MetodoPagamentoDAO;
import sneakpeak.model.Utente;

@WebServlet("/eliminaPagamento")
public class EliminaPagamentoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");
        
        if (utente == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int idPagamento = Integer.parseInt(request.getParameter("idPagamento"));
            MetodoPagamentoDAO dao = new MetodoPagamentoDAO();
            
            // Sicurezza: l'utente loggato può eliminare solo un metodo che gli appartiene
            boolean eliminato = dao.doDelete(idPagamento, utente.getIdUtente());
            
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

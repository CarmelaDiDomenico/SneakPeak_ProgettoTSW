package sneakpeak.control;

import java.io.IOException;
import java.sql.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sneakpeak.model.Recensione;
import sneakpeak.model.RecensioneDAO;
import sneakpeak.model.Utente;

@WebServlet("/aggiungiRecensione")
public class AggiungiRecensioneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");
        
        String idProdottoStr = request.getParameter("idProdotto");
        
        if (utente == null) {
            response.sendRedirect("login.jsp?errore=Effettua il login per lasciare una recensione");
            return;
        }
        
        if (idProdottoStr == null || idProdottoStr.trim().isEmpty()) {
            response.sendRedirect("home");
            return;
        }
        
        try {
            int idProdotto = Integer.parseInt(idProdottoStr);
            String titolo = request.getParameter("titolo");
            String descrizione = request.getParameter("descrizione");
            int valutazione = Integer.parseInt(request.getParameter("valutazione"));
            
            // Validazione base
            if (valutazione < 1 || valutazione > 5) {
                response.sendRedirect("dettaglio?id=" + idProdotto + "&erroreRecensione=Valutazione non valida");
                return;
            }
            
            Recensione recensione = new Recensione();
            recensione.setIdUtente(utente.getIdUtente());
            recensione.setIdProdotto(idProdotto);
            recensione.setTitolo(titolo);
            recensione.setDescrizione(descrizione);
            recensione.setValutazione(valutazione);
            recensione.setDataRecensione(new Date(System.currentTimeMillis()));
            
            RecensioneDAO dao = new RecensioneDAO();
            boolean salvato = dao.doSave(recensione);
            
            if (salvato) {
                response.sendRedirect("dettaglio?id=" + idProdotto + "&successoRecensione=Recensione aggiunta con successo");
            } else {
                response.sendRedirect("dettaglio?id=" + idProdotto + "&erroreRecensione=Errore durante il salvataggio della recensione");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("home");
        }
    }
}

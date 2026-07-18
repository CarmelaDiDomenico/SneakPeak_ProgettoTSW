package sneakpeak.control;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sneakpeak.model.Indirizzo;
import sneakpeak.model.IndirizzoDAO;
import sneakpeak.model.Utente;

@WebServlet("/aggiungiIndirizzo")
public class AggiungiIndirizzoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");
        
        // Controllo di sicurezza
        if (utente == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Recuperiamo i dati dal form della pagina profilo
        String via = request.getParameter("via");
        String civico = request.getParameter("civico");
        String citta = request.getParameter("citta");
        String cap = request.getParameter("cap");
        String provincia = request.getParameter("provincia");
        String nazione = request.getParameter("nazione");
        
        // Creiamo il nuovo oggetto Indirizzo
        Indirizzo nuovoInd = new Indirizzo();
        nuovoInd.setIdUtente(utente.getIdUtente());
        nuovoInd.setVia(via);
        nuovoInd.setCivico(civico);
        nuovoInd.setCitta(citta);
        nuovoInd.setCap(cap);
        nuovoInd.setProvincia(provincia);
        nuovoInd.setNazione(nazione);
        
        // Salviamo nel DB
        IndirizzoDAO indDAO = new IndirizzoDAO();
        int idGenerato = indDAO.doSave(nuovoInd);
        
        // Se è andato a buon fine (idGenerato > 0), torniamo al profilo con successo
        if (idGenerato > 0) {
            session.setAttribute("messaggioSuccesso", "Nuovo indirizzo salvato correttamente!");
            response.sendRedirect("profilo");
        } else {
            response.sendRedirect("profilo?errore=true");
        }
    }
}

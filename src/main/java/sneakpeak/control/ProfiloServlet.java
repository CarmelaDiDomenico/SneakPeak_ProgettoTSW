package sneakpeak.control;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sneakpeak.model.Indirizzo;
import sneakpeak.model.IndirizzoDAO;
import sneakpeak.model.Utente;
import sneakpeak.model.UtenteDAO;
import sneakpeak.util.PasswordHelper;

@WebServlet("/profilo")
public class ProfiloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");
        
        // Controllo di sicurezza: se non sei loggato, non puoi vedere il profilo
        if (utente == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        IndirizzoDAO indirizzoDAO = new IndirizzoDAO();
        List<Indirizzo> listaIndirizzi = indirizzoDAO.doRetrieveByUtente(utente.getIdUtente());
        
        sneakpeak.model.MetodoPagamentoDAO pagamentoDAO = new sneakpeak.model.MetodoPagamentoDAO();
        List<sneakpeak.model.MetodoPagamento> listaPagamenti = pagamentoDAO.doRetrieveByUtente(utente.getIdUtente());
        
        request.setAttribute("listaIndirizzi", listaIndirizzi);
        request.setAttribute("listaPagamenti", listaPagamenti);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("profilo.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");
        
        if (utente == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        //Recuperiamo i nuovi dati dal form
        String nuovoNome = request.getParameter("nome");
        String nuovoCognome = request.getParameter("cognome");
        String nuovaPassword = request.getParameter("password");
        
        //Aggiorniamo l'oggetto Utente
        utente.setNome(nuovoNome);
        utente.setCognome(nuovoCognome);
        
        // Controlliamo se l'utente vuole cambiare la password
        if (nuovaPassword != null && !nuovaPassword.trim().isEmpty()) {
            // Se ha scritto qualcosa, la cifriamo prima di salvarla
            String passwordCifrata = PasswordHelper.hashPassword(nuovaPassword);
            utente.setPassword(passwordCifrata);
        }
        // Se ha lasciato vuoto, la password rimane quella vecchia (che è già cifrata in sessione)
        
        UtenteDAO dao = new UtenteDAO();
        boolean aggiornato = dao.doUpdate(utente);
        
        if (aggiornato) {
            // Aggiorniamo la sessione con i nuovi dati
            session.setAttribute("utenteLoggato", utente);
            response.sendRedirect("profilo?successo=true");
        } else {
            response.sendRedirect("profilo?errore=true");
        }
    }
}

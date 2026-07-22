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

    // Metodo GET: il Cameriere porta il menu al tavolo
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");
        
        // Controllo di sicurezza: se non sei loggato, non puoi vedere il profilo
        if (utente == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Il collega ha già creato IndirizzoDAO! Lo usiamo per prendere gli indirizzi dell'utente
        IndirizzoDAO indirizzoDAO = new IndirizzoDAO();
        List<Indirizzo> listaIndirizzi = indirizzoDAO.doRetrieveByUtente(utente.getIdUtente());
        
        sneakpeak.model.MetodoPagamentoDAO pagamentoDAO = new sneakpeak.model.MetodoPagamentoDAO();
        List<sneakpeak.model.MetodoPagamento> listaPagamenti = pagamentoDAO.doRetrieveByUtente(utente.getIdUtente());
        
        // Passiamo le liste alla JSP
        request.setAttribute("listaIndirizzi", listaIndirizzi);
        request.setAttribute("listaPagamenti", listaPagamenti);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("profilo.jsp");
        dispatcher.forward(request, response);
    }

    // Metodo POST: il Cameriere prende l'ordinazione (i dati modificati)
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");
        
        if (utente == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 1. Recuperiamo i nuovi dati dal form
        String nuovoNome = request.getParameter("nome");
        String nuovoCognome = request.getParameter("cognome");
        String nuovaPassword = request.getParameter("password");
        
        // 2. Aggiorniamo l'oggetto Utente
        utente.setNome(nuovoNome);
        utente.setCognome(nuovoCognome);
        
        // Controlliamo se l'utente vuole cambiare la password
        if (nuovaPassword != null && !nuovaPassword.trim().isEmpty()) {
            // Se ha scritto qualcosa, la cifriamo con il nostro aiutante prima di salvarla
            String passwordCifrata = PasswordHelper.hashPassword(nuovaPassword);
            utente.setPassword(passwordCifrata);
        }
        // Se ha lasciato vuoto, la password rimane quella vecchia (che è già cifrata in sessione)
        
        // 3. Chiamiamo il Cuoco (DAO) per salvare i cambiamenti nel Database
        UtenteDAO dao = new UtenteDAO();
        boolean aggiornato = dao.doUpdate(utente);
        
        if (aggiornato) {
            // Aggiorniamo la sessione con i nuovi dati
            session.setAttribute("utenteLoggato", utente);
            // Torniamo alla pagina profilo ricaricandola con successo
            response.sendRedirect("profilo?successo=true");
        } else {
            response.sendRedirect("profilo?errore=true");
        }
    }
}

package sneakpeak.control;

import java.io.IOException;
import java.sql.Date;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sneakpeak.model.Carrello;
import sneakpeak.model.Indirizzo;
import sneakpeak.model.IndirizzoDAO;
import sneakpeak.model.MetodoPagamento;
import sneakpeak.model.MetodoPagamentoDAO;
import sneakpeak.model.Ordine;
import sneakpeak.model.OrdineDAO;
import sneakpeak.model.Utente;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");
        
        if (utente == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        
        IndirizzoDAO indDAO = new IndirizzoDAO();
        MetodoPagamentoDAO pagDAO = new MetodoPagamentoDAO();
        
        List<Indirizzo> listaIndirizzi = indDAO.doRetrieveByUtente(utente.getIdUtente());
        List<MetodoPagamento> listaPagamenti = pagDAO.doRetrieveByUtente(utente.getIdUtente());
        
        
        request.setAttribute("listaIndirizzi", listaIndirizzi);
        request.setAttribute("listaPagamenti", listaPagamenti);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("checkout.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");
        
        if (utente == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        Carrello carrello = (Carrello) session.getAttribute("carrello");
        if (carrello == null || carrello.getArticoli().isEmpty()) {
            response.sendRedirect("carrello.jsp");
            return;
        }
        
        // 1. GESTIONE INDIRIZZO
        int idIndirizzoFinal = -1;
        String idIndirizzoSelezionato = request.getParameter("idIndirizzo");
        
        if (idIndirizzoSelezionato == null || idIndirizzoSelezionato.equals("nuovo")) {
            // L'utente ha inserito un nuovo indirizzo nel form
            Indirizzo nuovoInd = new Indirizzo();
            nuovoInd.setIdUtente(utente.getIdUtente());
            nuovoInd.setVia(request.getParameter("nuovaVia"));
            nuovoInd.setCivico(request.getParameter("nuovoCivico"));
            nuovoInd.setCitta(request.getParameter("nuovaCitta"));
            nuovoInd.setCap(request.getParameter("nuovoCap"));
            nuovoInd.setProvincia(request.getParameter("nuovaProvincia"));
            nuovoInd.setNazione(request.getParameter("nuovaNazione"));
            
            IndirizzoDAO indDAO = new IndirizzoDAO();
            idIndirizzoFinal = indDAO.doSave(nuovoInd); // Salva su DB 
        } else {
            // L'utente ha selezionato un indirizzo già salvato
            idIndirizzoFinal = Integer.parseInt(idIndirizzoSelezionato);
        }
        
        // 2. GESTIONE PAGAMENTO
        int idPagamentoFinal = -1;
        String idPagamentoSelezionato = request.getParameter("idPagamento");
        
        if (idPagamentoSelezionato == null || idPagamentoSelezionato.equals("nuovo")) {
            // L'utente ha inserito una nuova carta nel form
            MetodoPagamento nuovoPag = new MetodoPagamento();
            nuovoPag.setIdUtente(utente.getIdUtente());
            nuovoPag.setTipo(request.getParameter("nuovoTipo"));
            nuovoPag.setIntestatario(request.getParameter("nuovoIntestatario"));
            
            MetodoPagamentoDAO pagDAO = new MetodoPagamentoDAO();
            idPagamentoFinal = pagDAO.doSave(nuovoPag); // Salva su DB 
        } else {
            // L'utente ha selezionato una carta già salvata
            idPagamentoFinal = Integer.parseInt(idPagamentoSelezionato);
        }
        
        
        if (idIndirizzoFinal == -1 || idPagamentoFinal == -1) {
            response.sendRedirect("checkout.jsp?erroreDati=true");
            return;
        }
        
        // 3. CREAZIONE ORDINE
        Ordine ordine = new Ordine();
        ordine.setIdUtente(utente.getIdUtente());
        ordine.setTotale(carrello.getPrezzoTotale());
        ordine.setDataOrdine(new Date(System.currentTimeMillis()));
        ordine.setIdIndirizzo(idIndirizzoFinal); 
        ordine.setIdPagamento(idPagamentoFinal); 
        
        OrdineDAO ordineDAO = new OrdineDAO();
        boolean success = ordineDAO.salvaOrdineCompleto(ordine, carrello);
        
        if (success) {
            session.removeAttribute("carrello"); // Svuota carrello
            response.sendRedirect("confermaOrdine.jsp");
        } else {
            response.sendRedirect("carrello.jsp?erroreCheckout=true");
        }
    }
}
package sneakpeak.control;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sneakpeak.model.DettaglioOrdine;
import sneakpeak.model.Ordine;
import sneakpeak.model.OrdineDAO;
import sneakpeak.model.Utente;

@WebServlet("/storicoOrdini")
public class StoricoOrdiniServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utente = (Utente) session.getAttribute("utenteLoggato");
        
        // Controllo sicurezza
        if (utente == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        OrdineDAO ordineDAO = new OrdineDAO();

        // 1. Recupera tutti gli ordini dell'utente (già ordinati per data DESC)
        List<Ordine> ordiniCliente = ordineDAO.doRetrieveByUtente(utente.getIdUtente());

        // 2. Per ogni ordine, recupera i prodotti acquistati e costruisce una mappa
        //    LinkedHashMap preserva l'ordine di inserimento (= data ordine DESC)
        Map<Integer, List<DettaglioOrdine>> dettagliPerOrdine = new LinkedHashMap<>();
        for (Ordine o : ordiniCliente) {
            List<DettaglioOrdine> dettagli = ordineDAO.doRetrieveDettagliByOrdine(o.getIdOrdine());
            dettagliPerOrdine.put(o.getIdOrdine(), dettagli);
        }

        // 3. Passa entrambe le strutture alla JSP
        request.setAttribute("ordiniCliente", ordiniCliente);
        request.setAttribute("dettagliPerOrdine", dettagliPerOrdine);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("storicoOrdini.jsp");
        dispatcher.forward(request, response);
    }
}

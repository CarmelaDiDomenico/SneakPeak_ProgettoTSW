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

@WebServlet("/gestioneOrdini")
public class GestioneOrdiniServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente admin = (Utente) session.getAttribute("utenteLoggato");
        
        // Controllo di sicurezza
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getTipo())) {
            response.sendRedirect("login.jsp?errore=accesso_negato");
            return;
        }

        OrdineDAO dao = new OrdineDAO();
        List<Ordine> listaOrdini;
        
        // Lettura parametri di filtro
        String clienteSearch = request.getParameter("clienteSearch");
        String dataInizioStr = request.getParameter("dataInizio");
        String dataFineStr = request.getParameter("dataFine");
        
        java.sql.Date dataInizio = null;
        java.sql.Date dataFine = null;
        
        boolean hasFilters = false;

        if (clienteSearch != null && !clienteSearch.trim().isEmpty()) {
            hasFilters = true;
        }
        
        if (dataInizioStr != null && !dataInizioStr.trim().isEmpty()) {
            try {
                dataInizio = java.sql.Date.valueOf(dataInizioStr); // Formato YYYY-MM-DD
                hasFilters = true;
            } catch (IllegalArgumentException e) {
                
            }
        }
        
        if (dataFineStr != null && !dataFineStr.trim().isEmpty()) {
            try {
                dataFine = java.sql.Date.valueOf(dataFineStr);
                hasFilters = true;
            } catch (IllegalArgumentException e) {
                
            }
        }
        
        if (hasFilters) {
            listaOrdini = dao.doRetrieveFiltered(clienteSearch, dataInizio, dataFine);
        } else {
            listaOrdini = dao.doRetrieveAll();
        }
        
        Map<Integer, List<DettaglioOrdine>> dettagliPerOrdine = new LinkedHashMap<>();
        if (listaOrdini != null) {
            for (Ordine o : listaOrdini) {
                List<DettaglioOrdine> dettagli = dao.doRetrieveDettagliByOrdine(o.getIdOrdine());
                dettagliPerOrdine.put(o.getIdOrdine(), dettagli);
            }
        }
        
        request.setAttribute("listaOrdini", listaOrdini);
        request.setAttribute("dettagliPerOrdine", dettagliPerOrdine);
        RequestDispatcher dispatcher = request.getRequestDispatcher("gestioneOrdini.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente admin = (Utente) session.getAttribute("utenteLoggato");
        
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getTipo())) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int idOrdine = Integer.parseInt(request.getParameter("idOrdine"));
        String nuovoStato = request.getParameter("nuovoStato");
        
        OrdineDAO dao = new OrdineDAO();
        dao.updateStato(idOrdine, nuovoStato);
        
        response.sendRedirect("gestioneOrdini");
    }
}
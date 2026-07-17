package sneakpeak.filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sneakpeak.model.Utente;

// pagine e servlet da proteggere
@WebFilter(urlPatterns = {
	    "/adminDashboard.jsp", 
	    "/aggiungiProdotto.jsp", 
	    "/aggiungiProdotto",       // Servlet
	    "/gestioneCatalogo.jsp", 
	    "/gestioneCatalogo",       // Servlet
	    "/gestioneOrdini.jsp", 
	    "/gestioneOrdini"          // Servlet
	})
public class AdminFilter implements Filter {

    public void init(FilterConfig fConfig) throws ServletException {}

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        
        boolean isLoggato = (session != null && session.getAttribute("utenteLoggato") != null);
        
        if (isLoggato) {
            Utente utente = (Utente) session.getAttribute("utenteLoggato");
            
            // Se è loggato E il suo tipo è ADMIN, lo lascia passare
            if ("ADMIN".equalsIgnoreCase(utente.getTipo())) {
                chain.doFilter(request, response);
                return;
            }
        }
        
        // Se non è loggato, oppure è un semplice CLIENTE, lo rimandiamo al login con un errore
        res.sendRedirect(req.getContextPath() + "/login.jsp?errore=accesso_negato");
    }

    public void destroy() {}
}
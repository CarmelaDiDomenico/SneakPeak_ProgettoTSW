package sneakpeak.control;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sneakpeak.model.Prodotto;
import sneakpeak.model.ProdottoDAO;

// Questa Servlet risponderà all'URL "/dettaglio"
@WebServlet("/dettaglio")
public class ProdottoDettaglioServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Leggiamo l'ID dall'URL. request.getParameter legge tutto come testo (String)
        String idStringa = request.getParameter("id");
        
        if (idStringa != null) {
            try {
                // 2. Convertiamo il testo in un numero intero (int)
                int idProdotto = Integer.parseInt(idStringa);
                
                // 3. Chiamiamo il DAO per cercare la scarpa
                ProdottoDAO dao = new ProdottoDAO();
                Prodotto prodotto = dao.doRetrieveById(idProdotto);
                
                // 4. Mettiamo il prodotto trovato nella "valigia" (request) per mandarlo alla JSP
                request.setAttribute("prodottoSingolo", prodotto);
                
            } catch (NumberFormatException e) {
                // Se qualcuno manomette l'URL scrivendo lettere al posto del numero (es. dettaglio?id=ciao)
                request.setAttribute("errore", "ID prodotto non valido.");
            }
        } else {
            request.setAttribute("errore", "Nessun ID prodotto specificato.");
        }
        
        // 5. Passiamo il controllo alla pagina HTML/JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/dettaglio.jsp");
        dispatcher.forward(request, response);
    }
}
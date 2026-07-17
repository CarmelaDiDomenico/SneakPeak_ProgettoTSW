package sneakpeak.control;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import sneakpeak.model.Prodotto;
import sneakpeak.model.ProdottoDAO;
import sneakpeak.model.Utente;

@WebServlet("/aggiungiProdotto")
public class AggiungiProdottoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("aggiungiProdotto.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        //Controllo Sicurezza 
        HttpSession session = request.getSession();
        Utente admin = (Utente) session.getAttribute("utenteLoggato");
        
        if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getTipo())) {
            response.sendRedirect("login.jsp?errore=accesso_negato");
            return;
        }

        //Recupero Parametri dal form
        String nome = request.getParameter("nome");
        String marca = request.getParameter("marca");
        String descrizione = request.getParameter("descrizione");
        
        
        double prezzo = 0;
        int idCategoria = 0;
        try {
            prezzo = Double.parseDouble(request.getParameter("prezzo"));
            idCategoria = Integer.parseInt(request.getParameter("idCategoria"));
        } catch (NumberFormatException e) {
            response.sendRedirect("aggiungiProdotto.jsp?errore=true");
            return;
        }

        //Creazione del Bean Prodotto
        Prodotto nuovoProdotto = new Prodotto();
        nuovoProdotto.setNome(nome);
        nuovoProdotto.setMarca(marca);
        nuovoProdotto.setDescrizione(descrizione);
        nuovoProdotto.setPrezzo(prezzo);
        nuovoProdotto.setIdCategoria(idCategoria); 
        

        // Salvataggio su Database
        ProdottoDAO dao = new ProdottoDAO();
        boolean salvato = dao.doSave(nuovoProdotto);

        // 5. Reindirizzamento
        if (salvato) {
            response.sendRedirect("aggiungiProdotto.jsp?successo=true");
        } else {
            response.sendRedirect("aggiungiProdotto.jsp?errore=true");
        }
    }
}
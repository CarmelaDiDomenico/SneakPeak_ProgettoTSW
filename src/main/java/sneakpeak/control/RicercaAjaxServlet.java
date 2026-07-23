package sneakpeak.control;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sneakpeak.model.Prodotto;
import sneakpeak.model.ProdottoDAO;

@WebServlet("/ricercaAjax")
public class RicercaAjaxServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("q");
        
        // Impostiamo che la risposta sarà un file JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (query == null || query.trim().isEmpty()) {
            out.print("[]"); // JSON Array vuoto
            return;
        }

        ProdottoDAO dao = new ProdottoDAO();
        List<Prodotto> risultati = dao.doSearch(query);

        // Costruiamo la stringa JSON a mano in modo semplice.
        // Esempio: [ {"id": 1, "nome": "Scarpa", "prezzo": 100.0, "immagine": "img/a.jpg"}, {...} ]
        StringBuilder json = new StringBuilder();
        json.append("[");
        
        for (int i = 0; i < risultati.size(); i++) {
            Prodotto p = risultati.get(i);
            json.append("{");
            json.append("\"id\": ").append(p.getIdProdotto()).append(", ");
            json.append("\"nome\": \"").append(p.getNome().replace("\"", "\\\"")).append("\", ");
            json.append("\"prezzo\": ").append(p.getPrezzo()).append(", ");
            json.append("\"immagine\": \"").append(p.getImmagine()).append("\"");
            json.append("}");
            
            // Aggiungi la virgola se non è l'ultimo elemento
            if (i < risultati.size() - 1) {
                json.append(", ");
            }
        }
        
        json.append("]");
        
        // Inviamo il JSON al browser
        out.print(json.toString());
        out.flush();
    }
}

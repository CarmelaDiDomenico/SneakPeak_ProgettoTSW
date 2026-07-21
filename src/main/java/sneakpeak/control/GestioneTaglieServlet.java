package sneakpeak.control;

import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import sneakpeak.model.Prodotto;
import sneakpeak.model.ProdottoDAO;
import sneakpeak.model.Variante;
import sneakpeak.model.VarianteDAO;

@WebServlet("/gestioneTaglie")
public class GestioneTaglieServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("idProdotto");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("gestioneCatalogo");
            return;
        }

        try {
            int idProdotto = Integer.parseInt(idStr);
            ProdottoDAO pDao = new ProdottoDAO();
            Prodotto prodotto = pDao.doRetrieveById(idProdotto);
            
            if (prodotto == null) {
                response.sendRedirect("gestioneCatalogo");
                return;
            }
            
            VarianteDAO vDao = new VarianteDAO();
            List<Variante> varianti = vDao.doRetrieveByProdotto(idProdotto);
            prodotto.setVarianti(varianti);
            
            request.setAttribute("prodotto", prodotto);
            RequestDispatcher rd = request.getRequestDispatcher("gestioneTaglie.jsp");
            rd.forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("gestioneCatalogo");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String azione = request.getParameter("azione");
        String idProdottoStr = request.getParameter("idProdotto");
        
        if (idProdottoStr == null || idProdottoStr.isEmpty()) {
            response.sendRedirect("gestioneCatalogo");
            return;
        }

        int idProdotto = Integer.parseInt(idProdottoStr);
        VarianteDAO vDao = new VarianteDAO();

        try {
            if ("aggiungi".equals(azione)) {
                String taglia = request.getParameter("nuovaTaglia");
                String qtyStr = request.getParameter("nuovaQuantita");
                
                if (taglia != null && !taglia.trim().isEmpty() && qtyStr != null && !qtyStr.isEmpty()) {
                    Variante v = new Variante();
                    v.setIdProdotto(idProdotto);
                    v.setTaglia(taglia.trim());
                    v.setQuantita(Integer.parseInt(qtyStr));
                    
                    // Simple logic to add, ignoring unique constraint errors for now (could be handled gracefully)
                    vDao.doSave(v);
                }
            } else if ("aggiorna".equals(azione)) {
                String idVarianteStr = request.getParameter("idVariante");
                String qtyStr = request.getParameter("quantita");
                
                if (idVarianteStr != null && qtyStr != null) {
                    int idVariante = Integer.parseInt(idVarianteStr);
                    int qty = Integer.parseInt(qtyStr);
                    vDao.doUpdateQuantita(idVariante, qty);
                }
            } else if ("elimina".equals(azione)) {
                String idVarianteStr = request.getParameter("idVariante");
                if (idVarianteStr != null) {
                    int idVariante = Integer.parseInt(idVarianteStr);
                    vDao.doDelete(idVariante);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("gestioneTaglie?idProdotto=" + idProdotto);
    }
}

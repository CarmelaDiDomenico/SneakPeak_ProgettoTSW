package sneakpeak.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Carrello implements Serializable {
    private static final long serialVersionUID = 1L;

    private List<Prodotto> articoli;

    public Carrello() {
        articoli = new ArrayList<>();
    }

    // Aggiunta di una scarpa al carrello
    public void addProdotto(Prodotto p) {
        articoli.add(p);
    }

    // Rimozione di una scarpa dal carrello tramite ID
    public void removeProdotto(int idProdotto) {
        for (int i = 0; i < articoli.size(); i++) {
            if (articoli.get(i).getIdProdotto() == idProdotto) {
                articoli.remove(i);
                break;
            }
        }
    }

    // Lista di tutti i prodotti nel carrello
    public List<Prodotto> getArticoli() {
        return articoli;
    }

    // Somma dei prezzi di tutte le scarpe nel carrello
    public double getPrezzoTotale() {
        double totale = 0;
        for (Prodotto p : articoli) {
            totale += p.getPrezzo();
        }
        return totale;
    }

    // Verifica se il carrello è vuoto
    public boolean isEmpty() {
        return articoli.isEmpty();
    }
}
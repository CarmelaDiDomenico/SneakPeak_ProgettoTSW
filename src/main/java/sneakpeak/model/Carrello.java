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

    // Rimozione di tutte le occorrenze di una scarpa dal carrello tramite ID
    public void removeProdotto(int idProdotto) {
        articoli.removeIf(p -> p.getIdProdotto() == idProdotto);
    }

    // Aggiornamento della quantità di un prodotto nel carrello
    public void updateQuantita(int idProdotto, int nuovaQuantita) {
        if (nuovaQuantita <= 0) {
            removeProdotto(idProdotto);
            return;
        }

        // Calcoliamo la quantità attuale
        int qtyAttuale = 0;
        Prodotto protRef = null;
        for (Prodotto p : articoli) {
            if (p.getIdProdotto() == idProdotto) {
                qtyAttuale++;
                protRef = p;
            }
        }

        if (protRef == null) {
            return; // Il prodotto non è presente nel carrello
        }

        if (nuovaQuantita > qtyAttuale) {
            // Aggiungiamo la differenza
            int daAggiungere = nuovaQuantita - qtyAttuale;
            for (int i = 0; i < daAggiungere; i++) {
                articoli.add(protRef);
            }
        } else if (nuovaQuantita < qtyAttuale) {
            // Rimuoviamo la differenza
            int daRimuovere = qtyAttuale - nuovaQuantita;
            int rimossi = 0;
            for (int i = articoli.size() - 1; i >= 0; i--) {
                if (articoli.get(i).getIdProdotto() == idProdotto) {
                    articoli.remove(i);
                    rimossi++;
                    if (rimossi == daRimuovere) {
                        break;
                    }
                }
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
package sneakpeak.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class Carrello implements Serializable {
    private static final long serialVersionUID = 1L;

    private List<CartItem> articoli;

    public Carrello() {
        articoli = new ArrayList<>();
    }

    // Aggiunta di una scarpa al carrello con la taglia selezionata
    public void addProdotto(Prodotto p, String taglia) {
        // Cerca se esiste già la stessa scarpa con la STESSA taglia
        Optional<CartItem> itemOpt = articoli.stream()
                .filter(item -> item.getProdotto().getIdProdotto() == p.getIdProdotto() && item.getTaglia().equals(taglia))
                .findFirst();

        if (itemOpt.isPresent()) {
            CartItem item = itemOpt.get();
            item.setQuantita(item.getQuantita() + 1);
        } else {
            articoli.add(new CartItem(p, 1, taglia));
        }
    }

    // Rimozione di un prodotto specifico per una certa taglia
    public void removeProdotto(int idProdotto, String taglia) {
        articoli.removeIf(item -> item.getProdotto().getIdProdotto() == idProdotto && item.getTaglia().equals(taglia));
    }

    // Aggiornamento della quantità
    public void updateQuantita(int idProdotto, String taglia, int nuovaQuantita) {
        if (nuovaQuantita <= 0) {
            removeProdotto(idProdotto, taglia);
            return;
        }

        articoli.stream()
                .filter(item -> item.getProdotto().getIdProdotto() == idProdotto && item.getTaglia().equals(taglia))
                .findFirst()
                .ifPresent(item -> item.setQuantita(nuovaQuantita));
    }

    public List<CartItem> getArticoli() {
        return articoli;
    }

    public double getPrezzoNetto() {
        double totale = 0;
        for (CartItem item : articoli) {
            totale += (item.getProdotto().getPrezzo() * item.getQuantita());
        }
        return totale;
    }

    public double getIva() {
        return getPrezzoNetto() * 0.22;
    }

    public double getPrezzoTotale() {
        return getPrezzoNetto() + getIva();
    }

    public boolean isEmpty() {
        return articoli.isEmpty();
    }
}
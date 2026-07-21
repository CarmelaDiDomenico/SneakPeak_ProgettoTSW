package sneakpeak.model;

import java.io.Serializable;
import java.util.Objects;

public class CartItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private Prodotto prodotto;
    private int quantita;
    private String taglia;

    public CartItem(Prodotto prodotto, int quantita, String taglia) {
        this.prodotto = prodotto;
        this.quantita = quantita;
        this.taglia = taglia;
    }

    public Prodotto getProdotto() {
        return prodotto;
    }

    public void setProdotto(Prodotto prodotto) {
        this.prodotto = prodotto;
    }

    public int getQuantita() {
        return quantita;
    }

    public void setQuantita(int quantita) {
        this.quantita = quantita;
    }

    public String getTaglia() {
        return taglia;
    }

    public void setTaglia(String taglia) {
        this.taglia = taglia;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CartItem cartItem = (CartItem) o;
        return prodotto.getIdProdotto() == cartItem.getProdotto().getIdProdotto() &&
               Objects.equals(taglia, cartItem.taglia);
    }

    @Override
    public int hashCode() {
        return Objects.hash(prodotto.getIdProdotto(), taglia);
    }
}

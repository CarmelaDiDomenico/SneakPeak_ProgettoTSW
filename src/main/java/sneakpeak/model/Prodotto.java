package sneakpeak.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Prodotto implements Serializable {
    private static final long serialVersionUID = 1L; 

    // Variabili di istanza
    private int idProdotto;
    private String nome;
    private String descrizione;
    private double prezzo;
    private String marca;
    private int isDeleted;
    private int idCategoria;
    private String immagine;
    
    // Lista delle varianti (taglie e quantità) associate al prodotto
    private List<Variante> varianti = new ArrayList<>();

    public Prodotto() {
    }

    // Metodo di utilità per calcolare la quantità totale
    public int getQuantitaTotale() {
        int tot = 0;
        if (varianti != null) {
            for (Variante v : varianti) {
                tot += v.getQuantita();
            }
        }
        return tot;
    }

    public List<Variante> getVarianti() {
        return varianti;
    }

    public void setVarianti(List<Variante> varianti) {
        this.varianti = varianti;
    }


    public int getIdProdotto() {
        return idProdotto;
    }

    public void setIdProdotto(int idProdotto) {
        this.idProdotto = idProdotto;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public double getPrezzo() {
        return prezzo;
    }

    public void setPrezzo(double prezzo) {
        this.prezzo = prezzo;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public int getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(int isDeleted) {
        this.isDeleted = isDeleted;
    }

    public int getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(int idCategoria) {
        this.idCategoria = idCategoria;
    }
    
    public String getImmagine() 
    { return immagine; }
    
    public void setImmagine(String immagine) 
    { this.immagine = immagine; }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Prodotto other = (Prodotto) obj;
        return idProdotto == other.idProdotto;
    }

    @Override
    public int hashCode() {
        return java.util.Objects.hash(idProdotto);
    }
}
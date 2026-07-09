package sneakpeak.model;

import java.io.Serializable;

/**
 * Questo Java Bean rappresenta la tabella PRODOTTO del database.
 * Ogni oggetto di questa classe conterrà i dati di una singola sneaker.
 */
public class Prodotto implements Serializable {
    private static final long serialVersionUID = 1L; // Necessario per l'interfaccia Serializable

    // Variabili di istanza che rispecchiano le colonne della tabella nel Database
    private int idProdotto;
    private String nome;
    private String descrizione;
    private double prezzo;
    private String marca;
    private int isDeleted;
    private int idCategoria;

    // 1. Costruttore vuoto di default (Obbligatorio per i Java Bean)
    public Prodotto() {
    }

    // 2. Metodi Getter (per leggere i dati) e Setter (per scriverci dentro)

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
}
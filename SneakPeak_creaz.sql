-- Creazione del database per l'applicazione
CREATE DATABASE IF NOT EXISTS sneakpeak;
USE sneakpeak;

-- 1. Tabella Categoria (Uomo, Donna, Bambini, ecc.)
CREATE TABLE CATEGORIA (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

-- 2. Tabella Prodotto (Le nostre sneakers)
CREATE TABLE PRODOTTO (
    id_prodotto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descrizione TEXT,
    prezzo DECIMAL(10,2) NOT NULL,
    marca VARCHAR(50),
    immagine VARCHAR(255) DEFAULT 'img/default.jpg', -- Percorso relativo all'immagine del prodotto
    is_deleted INT DEFAULT 0, -- 0 significa attivo, 1 significa nascosto/eliminato logicamente
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES CATEGORIA(id_categoria) ON DELETE SET NULL
);

-- 3. Tabella Utente (Clienti e Amministratori)
CREATE TABLE UTENTE (
    id_utente INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Verrà salvata cifrata per motivi di sicurezza
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    tipo VARCHAR(20) DEFAULT 'CLIENTE' -- Può essere 'CLIENTE' oppure 'ADMIN'
);

-- 4. Tabella Indirizzo (Un utente può salvare più indirizzi)
CREATE TABLE INDIRIZZO (
    id_indirizzo INT AUTO_INCREMENT PRIMARY KEY,
    via VARCHAR(100) NOT NULL,
    civico VARCHAR(10) NOT NULL,
    cap VARCHAR(10) NOT NULL,
    citta VARCHAR(50) NOT NULL,
    provincia VARCHAR(5) NOT NULL,
    nazione VARCHAR(50) NOT NULL,
    id_utente INT,
    FOREIGN KEY (id_utente) REFERENCES UTENTE(id_utente) ON DELETE CASCADE
);

-- 5. Tabella Metodo di Pagamento
CREATE TABLE METODO_PAGAMENTO (
    id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL, -- Es: "Carta di Credito", "PayPal"
    intestatario VARCHAR(100) NOT NULL,
    id_utente INT,
    FOREIGN KEY (id_utente) REFERENCES UTENTE(id_utente) ON DELETE CASCADE
);

-- 6. Tabella Ordine (La testa dell'ordine con i dati generali)
CREATE TABLE ORDINE (
    id_ordine INT AUTO_INCREMENT PRIMARY KEY,
    stato VARCHAR(30) DEFAULT 'In elaborazione',
    data_ordine DATE NOT NULL,
    totale DECIMAL(10,2) NOT NULL,
    id_utente INT,
    id_indirizzo INT,
    id_pagamento INT,
    FOREIGN KEY (id_utente) REFERENCES UTENTE(id_utente) ON DELETE SET NULL,
    FOREIGN KEY (id_indirizzo) REFERENCES INDIRIZZO(id_indirizzo) ON DELETE SET NULL,
    FOREIGN KEY (id_pagamento) REFERENCES METODO_PAGAMENTO(id_pagamento) ON DELETE SET NULL
);

-- 7. Tabella Dettaglio Ordine (Integrità storica: memorizza quantità e prezzo bloccato al momento dell'acquisto)
CREATE TABLE DETTAGLIO_ORDINE (
    id_ordine INT,
    id_prodotto INT,
    quantita INT NOT NULL,
    prezzo_acquisto DECIMAL(10,2) NOT NULL, -- Prezzo di vendita in quel preciso istante
    PRIMARY KEY (id_ordine, id_prodotto),
    FOREIGN KEY (id_ordine) REFERENCES ORDINE(id_ordine) ON DELETE CASCADE,
    FOREIGN KEY (id_prodotto) REFERENCES PRODOTTO(id_prodotto) -- Mantiene il vincolo
);

-- 8. Tabella Recensione
CREATE TABLE RECENSIONE (
    id_recensione INT AUTO_INCREMENT PRIMARY KEY,
    titolo VARCHAR(100),
    descrizione TEXT,
    valutazione INT NOT NULL CHECK (valutazione BETWEEN 1 AND 5),
    data_recensione DATE NOT NULL,
    id_utente INT,
    id_prodotto INT,
    FOREIGN KEY (id_utente) REFERENCES UTENTE(id_utente) ON DELETE CASCADE,
    FOREIGN KEY (id_prodotto) REFERENCES PRODOTTO(id_prodotto) ON DELETE CASCADE
);
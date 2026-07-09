USE sneakpeak;

-- ==========================================
-- 1. POPOLAZIONE TABELLA CATEGORIA
-- ==========================================
INSERT INTO CATEGORIA (nome) VALUES 
('Uomo'),
('Donna'),
('Unisex'),
('Bambini');

-- ==========================================
-- 2. POPOLAZIONE TABELLA PRODOTTO
-- ==========================================
-- Inseriamo alcune sneaker popolari. 
-- id_categoria fa riferimento agli ID creati sopra (1=Uomo, 2=Donna, 3=Unisex, 4=Bambini)
-- is_deleted è 0 di default (prodotto visibile e attivo)
INSERT INTO PRODOTTO (nome, descrizione, prezzo, marca, id_categoria) VALUES 
('Nike Air Jordan 1 High', 'L''iconica scarpa da basket che ha fatto la storia dello streetwear. Colore Chicago.', 180.00, 'Nike', 1),
('Adidas Yeezy Boost 350', 'Sneaker dal design innovativo con suola ammortizzata Boost. Colore Onyx.', 230.00, 'Adidas', 3),
('Nike Dunk Low Panda', 'Versatile e popolarissima, perfetta per l''uso quotidiano. Bianco e nero.', 120.00, 'Nike', 2),
('New Balance 550', 'Stile retrò anni 80, ottima per un look casual. Bianco e verde neon.', 140.00, 'New Balance', 1),
('Puma Suede Classic', 'Un classico intramontabile in pelle scamosciata per i più piccoli.', 60.00, 'Puma', 4);

-- ==========================================
-- 3. POPOLAZIONE TABELLA UTENTE
-- ==========================================
-- NOTA SULLA PASSWORD: Nel database reale, le password non vanno MAI salvate in chiaro 
-- (come 'admin123'). Più avanti nel progetto Java useremo una funzione per cifrarle (es. SHA-256).
-- Per ora, ai fini del test, le inseriamo testuali.
INSERT INTO UTENTE (email, password, nome, cognome, tipo) VALUES 
('admin@sneakpeak.it', 'admin123', 'Salvatore', 'Valente', 'ADMIN'),
('mario.rossi@email.it', 'cliente123', 'Mario', 'Rossi', 'CLIENTE');

-- ==========================================
-- 4. POPOLAZIONE TABELLA INDIRIZZO (Opzionale)
-- ==========================================
-- Inseriamo un indirizzo di spedizione per il cliente Mario Rossi (id_utente = 2)
INSERT INTO INDIRIZZO (via, civico, cap, citta, provincia, nazione, id_utente) VALUES 
('Via Roma', '10', '84100', 'Salerno', 'SA', 'Italia', 2);
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
-- id_categoria: 1=Uomo, 2=Donna, 3=Unisex, 4=Bambini
-- is_deleted è 0 di default (prodotto visibile e attivo)
-- Le immagini sono nella cartella src/main/webapp/img/
INSERT INTO PRODOTTO (nome, descrizione, prezzo, marca, immagine, id_categoria) VALUES 
('Nike Air Jordan 1 High', 'L''iconica scarpa da basket che ha fatto la storia dello streetwear. Colore Chicago.', 180.00, 'Nike', 'img/jordan1-chicago.jpg', 1),
('Adidas Yeezy Boost 350', 'Sneaker dal design innovativo con suola ammortizzata Boost. Colore Onyx.', 230.00, 'Adidas', 'img/yeezy-onyx.jpeg', 3),
('Nike Dunk Low Panda', 'Versatile e popolarissima, perfetta per l''uso quotidiano. Bianco e nero.', 120.00, 'Nike', 'img/dunk-panda.jpeg', 2),
('New Balance 550', 'Stile retrò anni 80, ottima per un look casual. Bianco e verde neon.', 140.00, 'New Balance', 'img/nb550.jpeg', 1),
('Puma Suede Classic', 'Un classico intramontabile in pelle scamosciata per i più piccoli.', 60.00, 'Puma', 'img/puma-suede.jpeg', 4);

-- ==========================================
-- 3. POPOLAZIONE TABELLA UTENTE
-- ==========================================
-- NOTA SULLA PASSWORD: Le password nel database reale vanno salvate cifrate in SHA-256.
-- Le password in chiaro di test corrispondenti sono:
-- 'admin@sneakpeak.it' -> 'admin123'
-- 'mario.rossi@email.it' -> 'cliente123'
INSERT INTO UTENTE (email, password, nome, cognome, tipo) VALUES 
('admin@sneakpeak.it', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'Salvatore', 'Valente', 'ADMIN'),
('mario.rossi@email.it', '09a31a7001e261ab1e056182a71d3cf57f582ca9a29cff5eb83be0f0549730a9', 'Mario', 'Rossi', 'CLIENTE');

-- ==========================================
-- 4. POPOLAZIONE TABELLA INDIRIZZO (Opzionale)
-- ==========================================
-- Inseriamo un indirizzo di spedizione per il cliente Mario Rossi (id_utente = 2)
INSERT INTO INDIRIZZO (via, civico, cap, citta, provincia, nazione, id_utente) VALUES 
('Via Roma', '10', '84100', 'Salerno', 'SA', 'Italia', 2);
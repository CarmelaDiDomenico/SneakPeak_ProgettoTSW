USE sneakpeak;
ALTER TABLE PRODOTTO ADD COLUMN immagine VARCHAR(255) DEFAULT 'img/default.jpg';

-- 1. Nike Air Jordan 1 High (Chicago)
UPDATE PRODOTTO 
SET immagine = 'img/jordan1-chicago.jpg' 
WHERE id_prodotto = 1;

-- 2. Adidas Yeezy Boost 350 (Onyx)
UPDATE PRODOTTO 
SET immagine = 'img/yeezy-onyx.jpeg' 
WHERE id_prodotto = 2;

-- 3. Nike Dunk Low Panda
UPDATE PRODOTTO 
SET immagine = 'img/dunk-panda.jpeg' 
WHERE id_prodotto = 3;

-- 4. New Balance 550 (Bianco e verde)
UPDATE PRODOTTO 
SET immagine = 'img/nb550.jpeg' 
WHERE id_prodotto = 4;

-- 5. Puma Suede Classic
UPDATE PRODOTTO 
SET immagine = 'img/puma-suede.jpeg' 
WHERE id_prodotto = 5;
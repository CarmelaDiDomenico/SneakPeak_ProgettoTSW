# SneakPeak

SneakPeak è un progetto universitario sviluppato per l'esame del corso di Tecnologie Web (TSW). 
Si tratta di un finto e-commerce specializzato nella vendita di sneakers, strutturato con architettura MVC.

## Tecnologie utilizzate
- **Linguaggi:** Java (Servlet, JSP), HTML, CSS, JavaScript
- **Database:** MySQL
- **Server:** Apache Tomcat (v9.0+)
- **Architettura:** MVC con DAO pattern per il database

## Funzionalità principali
- **Lato Utente (Cliente):** 
  - Navigazione catalogo con filtri per categoria (Uomo, Donna, Bambino, Unisex).
  - Registrazione, Login e gestione del profilo personale.
  - Carrello della spesa (gestito tramite sessioni).
  - Checkout e visualizzazione dello storico ordini con aggiornamento dello stato di spedizione.
  - Inserimento recensioni sui prodotti acquistati.
- **Lato Admin:** 
  - Dashboard amministrativa.
  - Gestione del catalogo (aggiunta, modifica, "soft-delete" dei prodotti).
  - Gestione taglie e giacenze di magazzino per ogni singolo modello.
  - Monitoraggio di tutti gli ordini ricevuti e modifica dello stato della spedizione.

## Come avviare il progetto
1. **Configurazione Database:** 
   - Crea un database in locale usando PhpMyAdmin o workbench.
   - Esegui lo script `database/SneakPeak_creaz.sql` per generare lo schema e le tabelle.
   - Esegui `database/popolazione_completa.sql` per caricare un set di dati di prova pronto all'uso (include già utenti, prodotti, immagini e ordini).
2. **Connessione DB:** 
   - Modifica se necessario il file `src/main/java/sneakpeak/model/ConPool.java` in modo che username e password corrispondano a quelli del tuo server MySQL locale.
3. **Deploy:** 
   - Clona il repository.
   - Importa il progetto nel tuo IDE (Eclipse Enterprise o IntelliJ).
   - Aggiungi il progetto al server Tomcat e avvialo.
   - Apri il browser e vai su `http://localhost:8080/SneakPeak_ProgettoTSW/home`.



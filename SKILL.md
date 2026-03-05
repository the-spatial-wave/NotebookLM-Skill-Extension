---
name: thespatialwave-system-os
version: 2.0.0
description: The Spatial Wave — Pipeline completa NotebookLM + AntiGravity. Da topic o notebook esistente genera documenti markdown, audio, infografica, quiz, flashcards, slide deck e dashboard HTML offline-ready (Lyra palette). Tutto in locale, tutto dalla chat.
author: The Spatial Wave
triggers:
  - "lancia pipeline TSW"
  - "crea pacchetto su"
  - "analizza competitor"
  - "content pack"
  - "marketing intel"
  - "nuovo notebook su"
  - "genera documenti da"
  - "usa notebook"
  - "tsw mode"
requires:
  - notebooklm-py >= 0.3.3 (CLI nel PATH)
  - notebooklm autenticato
---

# THE SPATIAL WAVE — SYSTEM OS v2.0
## Skill per AntiGravity — Pipeline NotebookLM completa

---

## ISTRUZIONI PER L'AGENTE

Quando l'utente ti attiva con uno dei trigger, esegui questa procedura SENZA chiedere conferma ad ogni step. Chiedi solo le informazioni mancanti all'inizio, poi esegui tutto in autonomia.

---

## STEP 0 — RACCOLTA INPUT

Chiedi all'utente (in un'unica domanda):

> "Dimmi:
> 1. MODE: CONTENT_PACK / MARKETING_INTEL / MEETING_PREP
> 2. TOPIC o NOTEBOOK ESISTENTE (se hai già un notebook, dammi l'ID o il nome)
> 3. Cosa vuoi generare: TUTTO / solo documenti / solo media (audio, infografica, slide)
> 4. Note aggiuntive (opzionale): tono, industry, competitor, piattaforma target"

Poi imposta queste variabili:
- `MODE` = CONTENT_PACK | MARKETING_INTEL | MEETING_PREP
- `TOPIC` = stringa topic
- `NOTEBOOK_ID` = ID notebook esistente (oppure null → crea nuovo)
- `OUTPUT` = TUTTO | DOCS_ONLY | MEDIA_ONLY
- `RUN_FOLDER` = `C:\Users\admin\Dev\ai-skill-notebook-knowledge\TSW-[MODE]-[TOPIC]` # Senza spazi o [ ] per compatibilità PowerShell

---

## STEP 1 — VERIFICA PREREQUISITI

Prima di tutto verifica che il CLI sia disponibile:

```bash
notebooklm --version
```

Se fallisce:
```bash
$env:PATH += ";C:\Users\admin\AppData\Roaming\Python\Python313\Scripts"
notebooklm --version
```

Se ancora fallisce: avvisa l'utente e fermati.

---

## STEP 2 — NOTEBOOK SETUP

### CASO A — Notebook esistente (NOTEBOOK_ID fornito):

```bash
notebooklm use [NOTEBOOK_ID]
notebooklm status
notebooklm source list
```

Mostra all'utente quante fonti ha il notebook, poi procedi al Phase 3.

### CASO B — Topic nuovo (NOTEBOOK_ID = null):

Esegui la pipeline completa partendo dal Phase 0.

---

# PIPELINE COMPLETA (solo per CASO B — topic nuovo)

## Phase 0 — Pre-Research & Seed Data

### 0.1 — Discovery Web

Usa web search per trovare 10-25 fonti su `[TOPIC]`:
- Documentazione ufficiale / siti autorevoli
- Tutorial e case study
- Community: Reddit, forum, Discord, Skool, Facebook Groups
- Competitor (corsi, tool, community) — soprattutto se MODE=MARKETING_INTEL

Crea cartella e file discovery:
```bash
mkdir "[RUN_FOLDER]"
mkdir "[RUN_FOLDER]\sources"
```

Scrivi `[RUN_FOLDER]\00_DISCOVERY_SOURCES.md` con tabella:
| Titolo | URL | Perché conta | Cosa estrarre |

Scrivi `[RUN_FOLDER]\sources\urls.txt` con 3-12 "gold URL" (uno per riga).

### 0.2 — Seed Profile

Sintetizza tutto in `[RUN_FOLDER]\00_SEED_PROFILE.md` (max 2 pagine):
- Obiettivo della run
- Target utente + livello
- Pain point principali (con evidenze trovate)
- Lista fonti gold (max 12 URL)
- Artifact da generare (checklist)
- Competitor lista breve (se MODE=MARKETING_INTEL)
- Note speciali dall'utente

Questo file è la fonte text per NotebookLM.

---

## Phase 1 — Creazione Notebook

```bash
# Crea notebook
notebooklm create "TSW - [MODE] - [TOPIC]"

# Attiva il nuovo notebook (usa l'ID restituito)
notebooklm use [NUOVO_ID]

# Aggiungi seed profile come fonte text
notebooklm source add --text "$(cat '[RUN_FOLDER]\00_SEED_PROFILE.md')" --title "TSW SEED PROFILE - [TOPIC]" --wait

# Aggiungi gold URLs (uno alla volta, con --wait)
# Leggi sources/urls.txt e aggiungi ogni URL
notebooklm source add "https://url1.com" --wait
notebooklm source add "https://url2.com" --wait
# ... continua per ogni URL in urls.txt
```

---

## Phase 2 — Deep Research

```bash
# Avvia deep research
notebooklm source add-research "[TOPIC] best practices tutorial errori comuni competitor community pain points 2025 2026" --mode deep --no-wait

# Aspetta completamento
notebooklm research wait
```

### Import batch (CRITICO — mai importare tutto insieme):

```bash
# Controlla quante fonti ha trovato
notebooklm source list

# Importa in batch da 20 — attendi 3 secondi tra batch
# (notebooklm source add-research gestisce questo automaticamente se usi --wait)
```

---

## Phase 3 — Generazione Documenti

Crea la cartella run se non esiste:
```bash
mkdir "[RUN_FOLDER]"
```

### 3.1 — Master Brief

```bash
notebooklm ask "Scrivi un MASTER BRIEF completo in italiano con queste sezioni: 1) Obiettivo (1 riga), 2) Target (chi è, livello, pain point principali con evidenze dalle fonti), 3) Promessa (cosa ottiene), 4) Differenziatori (rispetto ai competitor), 5) Struttura contenuti consigliata, 6) CTA principale, 7) KPI da monitorare. Stile chiaro, operativo, senza fluff." > "[RUN_FOLDER]\01_MASTER_BRIEF.md"
```

### 3.2 — Main Document

```bash
notebooklm ask "Scrivi il documento principale in italiano, struttura step-by-step: Perché (1 riga), Prerequisiti, Passaggi numerati con istruzioni precise, Errori comuni da evitare, Check finale, Risultato atteso. Se il topic è tecnico includi comandi in blocchi code. Scrivi in modo che un principiante possa seguire." > "[RUN_FOLDER]\02_MAIN_DOC.md"
```

### 3.3 — Script Lyra

```bash
notebooklm ask "Scrivi lo script completo per la voce Lyra in italiano. Tono: autorevole, calmo, architettonico. Niente puntini di sospensione, niente commenti meta tipo 'ora parliamo di...'. Deve spiegare il contenuto del documento principale come se stessi insegnando a voce a qualcuno di intelligente. Fluente e naturale." > "[RUN_FOLDER]\03_SCRIPT_LYRA.md"
```

### 3.4 — Checklist

```bash
notebooklm ask "Genera una checklist operativa in italiano con: task specifico, tempo stimato, output richiesto, check di verifica. Segui l'ordine logico del MAIN_DOC. Aggiungi step 'carica screenshot + 3 righe nel Lab' dove appropriato." > "[RUN_FOLDER]\04_CHECKLIST.md"
```

### 3.5 — Solo se MODE=MARKETING_INTEL:

```bash
notebooklm ask "Crea una mappa competitor con tabella: Nome, Posizionamento, Punti di forza, Punti deboli, Nostro vantaggio differenziale." > "[RUN_FOLDER]\05_MARKET_MAP.md"

notebooklm ask "Crea 2-4 personas target con: Nome, Età, Ruolo, Pain point principale (con citazione da fonti), Obiettivo, Obiezione tipica, Come raggiungerlo." > "[RUN_FOLDER]\06_TARGET_PERSONAS.md"

notebooklm ask "Tabella pain point → evidenza trovata nelle fonti → implicazione strategica per noi. Almeno 8 righe." > "[RUN_FOLDER]\07_PAINPOINTS_EVIDENCE.md"

# NOTA: in MARKETING_INTEL i file 09-11 sono riservati ai documenti strategici
# Gli artifact media usano 12-16 per evitare conflitti

notebooklm ask "Scrivi UVP (Unique Value Proposition), reason-to-believe con 3 prove concrete, positioning statement. Poi tagline breve (max 8 parole)." > "[RUN_FOLDER]\08_OFFER_POSITIONING.md"

notebooklm ask "Funnel TOFU/MOFU/BOFU completo: per ogni fase indica contenuti consigliati, piattaforma, CTA, KPI. Formato tabella." > "[RUN_FOLDER]\09_FUNNEL_BLUEPRINT.md"

notebooklm ask "10 angoli ads con: Angolo, Headline principale, Hook per video/reel, Formato consigliato. Basati sui pain point reali trovati nelle fonti." > "[RUN_FOLDER]\10_ADS_ANGLES.md"

notebooklm ask "Content calendar 4 settimane: data, piattaforma, tipo contenuto, topic specifico, CTA, note produzione. Formato tabella." > "[RUN_FOLDER]\11_CONTENT_CALENDAR.md"
```

---

## Phase 4 — Artifact Media

Avvia in background senza aspettare:

```bash
notebooklm generate audio --no-wait
notebooklm generate infographic --orientation portrait --no-wait
notebooklm generate quiz --difficulty medium --no-wait
notebooklm generate flashcards --no-wait
notebooklm generate slide-deck --no-wait
```

Aspetta completamento:
```bash
notebooklm artifact list
# Ripeti ogni 2 minuti finché tutti sono completed
```

Scarica quando pronti:
```bash
# Se MODE=CONTENT_PACK o MEETING_PREP:
notebooklm download quiz "[RUN_FOLDER]\07_QUIZ.md"
notebooklm download flashcards "[RUN_FOLDER]\08_FLASHCARDS.md"
notebooklm download audio "[RUN_FOLDER]\09_AUDIO_BRIEF.mp3"
notebooklm download infographic "[RUN_FOLDER]\10_INFOGRAPHIC.png"
notebooklm download slide-deck "[RUN_FOLDER]\11_SLIDE_DECK.pdf"

# Se MODE=MARKETING_INTEL (numeri 12-16 per evitare conflitto con docs strategici):
notebooklm download quiz "[RUN_FOLDER]\12_QUIZ.md"
notebooklm download flashcards "[RUN_FOLDER]\13_FLASHCARDS.md"
notebooklm download audio "[RUN_FOLDER]\14_AUDIO_BRIEF.mp3"
notebooklm download infographic "[RUN_FOLDER]\15_INFOGRAPHIC.png"
notebooklm download slide-deck "[RUN_FOLDER]\16_SLIDE_DECK.pdf"
```

**Fallback flashcards** — se il file ha meno di 8 Q&A:
```bash
# CONTENT_PACK/MEETING_PREP:
notebooklm ask "Genera 10 flashcard Q&A in italiano sul topic [TOPIC]. Formato esatto: Q: [domanda] / A: [risposta]. Una per riga." >> "[RUN_FOLDER]\08_FLASHCARDS.md"
# MARKETING_INTEL:
notebooklm ask "Genera 10 flashcard Q&A in italiano sul topic [TOPIC]. Formato esatto: Q: [domanda] / A: [risposta]. Una per riga." >> "[RUN_FOLDER]\13_FLASHCARDS.md"
```

---

## Phase 5 — Dashboard HTML

Leggi il template da:
`C:\Users\admin\Dev\NotebookLM-Skill-Extension-CLEAN\templates\dashboard_template.html`

Sostituisci TUTTI i placeholder con il contenuto reale:
- `{{TOPIC}}` → topic della run
- `{{MODE}}` → mode usato
- `{{DATE}}` → data odierna
- `{{NOTEBOOK_ID}}` → ID del notebook
- `{{NOTEBOOK_URL}}` → `https://notebooklm.google.com/notebook/[ID]`
- `{{CONTENT_BRIEF}}` → contenuto completo di 01_MASTER_BRIEF.md
- `{{CONTENT_DOC}}` → contenuto completo di 02_MAIN_DOC.md
- `{{CONTENT_SCRIPT}}` → contenuto completo di 03_SCRIPT_LYRA.md
- `{{CONTENT_CHECKLIST}}` → contenuto completo di 04_CHECKLIST.md
- `{{CONTENT_QUIZ_RAW}}` → contenuto completo di 07_QUIZ.md
- `{{CONTENT_FLASHCARDS_RAW}}` → contenuto completo di 08_FLASHCARDS.md
- `{{SOURCES_LIST}}` → contenuto di sources/urls.txt formattato come HTML list
- `{{FILE_COUNT}}` → numero file generati
- `{{TOTAL_SIZE}}` → dimensione totale cartella

Salva come `[RUN_FOLDER]\index.html`.

---

## Phase 6 — Index File

Crea `[RUN_FOLDER]\00_INDEX.md`:

```markdown
# TSW — [MODE]: [TOPIC]
**Data:** [DATA]
**Notebook:** https://notebooklm.google.com/notebook/[ID]

## File Generati
| File | Tipo | Descrizione |
[tabella con tutti i file]

## Come usare
1. Apri index.html nel browser
2. Ascolta 09_AUDIO_BRIEF.mp3
3. Studia con 07_QUIZ.md e 08_FLASHCARDS.md
4. Presenta con 11_SLIDE_DECK.pdf
```

---

## FAIL GRACEFULLY

- Se infografica fallisce → continua, segna "PENDING" nell'index
- Se audio > 10 min → segna "GENERATING" e continua
- Se flashcards < 8 Q&A → usa fallback query
- La dashboard deve funzionare anche senza i file media
- Mai bloccarsi su un singolo step

---

## VINCOLI NON NEGOZIABILI

1. Mai importare 100+ fonti in un colpo — chunk da 20
2. Mai inserire credenziali o token nell'output
3. Notebook isolato per ogni run
4. Output sempre in italiano salvo diversa indicazione
5. Chiedi i parametri UNA VOLTA all'inizio — poi esegui tutto da solo

---

## STRUTTURA OUTPUT FINALE

```
TSW - [MODE] - [TOPIC]/
├── 00_INDEX.md
├── 00_DISCOVERY_SOURCES.md      ← solo se notebook nuovo
├── 00_SEED_PROFILE.md           ← solo se notebook nuovo
├── 01_MASTER_BRIEF.md
├── 02_MAIN_DOC.md
├── 03_SCRIPT_LYRA.md
├── 04_CHECKLIST.md
│
│   ── CONTENT_PACK / MEETING_PREP:
├── 07_QUIZ.md
├── 08_FLASHCARDS.md
├── 09_AUDIO_BRIEF.mp3
├── 10_INFOGRAPHIC.png
├── 11_SLIDE_DECK.pdf
│
│   ── MARKETING_INTEL (aggiuntivi):
├── 05_MARKET_MAP.md
├── 06_TARGET_PERSONAS.md
├── 07_PAINPOINTS_EVIDENCE.md
├── 08_OFFER_POSITIONING.md
├── 09_FUNNEL_BLUEPRINT.md
├── 10_ADS_ANGLES.md
├── 11_CONTENT_CALENDAR.md
├── 12_QUIZ.md
├── 13_FLASHCARDS.md
├── 14_AUDIO_BRIEF.mp3
├── 15_INFOGRAPHIC.png
├── 16_SLIDE_DECK.pdf
├── index.html                   ← dashboard con tutto embedded
└── sources/
    └── urls.txt
```
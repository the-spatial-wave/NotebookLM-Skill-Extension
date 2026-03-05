---
name: thespatialwave-system-os
version: 1.0.0
description: The Spatial Wave — Sistema operativo per pipeline NotebookLM + AntiGravity. Genera documenti markdown, audio overview, infografica, quiz, flashcards, slide deck e dashboard HTML glassmorphic (Lyra palette) da qualsiasi topic.
author: The Spatial Wave
license: MIT
requires:
  - notebooklm-py >= 0.3.3
  - notebooklm-mcp
triggers:
  - "crea un pacchetto contenuti"
  - "genera documentazione su"
  - "analizza competitor"
  - "meeting prep per"
  - "lancia pipeline TSW"
  - "tsw mode"
  - "content pack"
  - "marketing intel"
---

# THE SPATIAL WAVE — SYSTEM OS
## NotebookLM Skill per AntiGravity

Questo file istruisce AntiGravity su come eseguire la pipeline TSW completa:
**Topic grezzo → NotebookLM → Documenti + Media + Dashboard HTML**

---

## PREREQUISITI (verifica prima di ogni run)

```bash
# Verifica auth NotebookLM
notebooklm list

# Se "command not found", aggiungi al PATH:
$env:PATH += ";C:\Users\admin\AppData\Roaming\Python\Python313\Scripts"

# Se "not authenticated":
notebooklm login
```

> ⚠️ Il CLI `notebooklm` deve essere nel PATH e autenticato prima di ogni pipeline.
> Il PATH va aggiunto manualmente ad ogni sessione PowerShell (o configurato permanentemente).

---

## MODES DISPONIBILI

| Mode | Trigger | Output |
|------|---------|--------|
| `CONTENT_PACK` | "crea contenuti su [topic]" | Brief + Doc + Script + Checklist + Media |
| `MARKETING_INTEL` | "analizza competitor [topic]" | Market Map + Personas + Funnel + Ads |
| `MEETING_PREP` | "meeting prep per [azienda]" | Brief + Intel + Quiz + Flashcards |

---

## PIPELINE COMPLETA

### Phase 0 — Input parsing

Quando ricevi una richiesta, estrai:
- `MODE`: CONTENT_PACK / MARKETING_INTEL / MEETING_PREP
- `TOPIC`: argomento principale
- `NOTEBOOK_EXISTING`: se l'utente menziona un notebook esistente, usalo
- `OUTPUT_DIR`: cartella output (default: `TSW - [MODE] - [TOPIC]/`)

---

### Phase 1 — Notebook Setup

**Caso A — Notebook esistente:**
```bash
notebooklm list
notebooklm use [ID_PARZIALE]
notebooklm status
```

**Caso B — Notebook nuovo:**
```bash
notebooklm create "TSW - [MODE] - [TOPIC]"
notebooklm use [ID_NUOVO]

# Aggiungi fonti gold (3-12 URL)
notebooklm source add "https://url1.com" --wait
notebooklm source add "https://url2.com" --wait

# Deep research
notebooklm source add-research "[TOPIC] best practices competitors pain points 2025 2026" --mode deep --no-wait
notebooklm research wait
```

> ⚠️ CRITICO: Se deep research ritorna 40+ fonti, non importare tutto in una volta.
> Usa `notebooklm source list` e importa in batch di 20.

---

### Phase 2 — Generazione Documenti (notebook_query via CLI)

Crea la cartella output e genera tutti i documenti markdown:

```bash
mkdir "TSW - [MODE] - [TOPIC]"
cd "TSW - [MODE] - [TOPIC]"
```

**01_MASTER_BRIEF.md:**
```bash
notebooklm ask "Scrivi un MASTER BRIEF in italiano con: Obiettivo, Target, Pain Point principali (con evidenze), Promessa, Differenziatori, Struttura contenuti, CTA consigliata, KPI suggeriti. Stile chiaro e operativo." > 01_MASTER_BRIEF.md
```

**02_MAIN_DOC.md:**
```bash
notebooklm ask "Scrivi il documento principale in italiano, step-by-step: Perché (1 riga), Prerequisiti, Passaggi numerati, Errori comuni, Check finale, Risultato atteso. Se tecnico, includi comandi in blocchi code." > 02_MAIN_DOC.md
```

**03_SCRIPT_LYRA.md:**
```bash
notebooklm ask "Scrivi lo script completo per Lyra in italiano: scorrevole, senza puntini di sospensione e senza commenti meta. Tono: autorevole e calmo. Spiega il contenuto del documento principale in modo semplice." > 03_SCRIPT_LYRA.md
```

**04_CHECKLIST.md:**
```bash
notebooklm ask "Genera una checklist operativa con: task, tempo stimato, output richiesto, check finale. Inserisci anche: carica screenshot + 3 righe nel Lab quando appropriato." > 04_CHECKLIST.md
```

**Solo se MODE=MARKETING_INTEL, aggiungi:**
```bash
notebooklm ask "Crea una mappa competitor: nome, posizionamento, punti di forza, punti deboli, nostro vantaggio." > 05_MARKET_MAP.md
notebooklm ask "Crea 2-4 personas target con: nome, età, pain point principale, obiettivo, obiezione tipica." > 06_TARGET_PERSONAS.md
notebooklm ask "Tabella pain point → evidenza trovata nelle fonti → implicazione strategica." > 07_PAINPOINTS_EVIDENCE.md
notebooklm ask "UVP + reason-to-believe + positioning statement per questo prodotto/servizio." > 08_OFFER_POSITIONING.md
notebooklm ask "Funnel TOFU/MOFU/BOFU: contenuti consigliati, CTA, KPI per ogni fase." > 09_FUNNEL_BLUEPRINT.md
notebooklm ask "10 angoli ads con headline e hook per ogni angolo. Formato tabella." > 10_ADS_ANGLES.md
notebooklm ask "Content calendar 2-4 settimane: data, piattaforma, tipo contenuto, topic, CTA." > 11_CONTENT_CALENDAR.md
```

---

### Phase 3 — Generazione Artifact Media

```bash
# Audio Overview
notebooklm generate audio --no-wait
# ... lavora su altro ...
notebooklm artifact poll --type audio
notebooklm download audio ./09_AUDIO_BRIEF.mp3

# Infografica
notebooklm generate infographic --orientation portrait --detail-level detailed --no-wait
notebooklm artifact poll --type infographic
notebooklm download infographic ./10_INFOGRAPHIC.png

# Quiz
notebooklm generate quiz --difficulty medium --no-wait
notebooklm artifact poll --type quiz
notebooklm download quiz --format markdown ./07_QUIZ.md

# Flashcards
notebooklm generate flashcards --no-wait
notebooklm artifact poll --type flashcards
notebooklm download flashcards --format markdown ./08_FLASHCARDS.md

# Slide Deck
notebooklm generate slide-deck --no-wait
notebooklm artifact poll --type slide-deck
notebooklm download slide-deck ./11_SLIDE_DECK.pdf
```

> ⚠️ FAIL GRACEFULLY:
> - Se infografica fallisce: continua, annota in 00_INDEX.md
> - Se audio > 5 min: annota "generating" e prosegui
> - Se flashcards < 8 Q&A: esegui `notebooklm ask "Genera 10 flashcard Q&A in italiano. Formato: Q: ... / A: ..."` e appendi

---

### Phase 4 — Index

Crea `00_INDEX.md` con:
- Tabella file generati + descrizione
- Contatore fonti NotebookLM
- Link al notebook: `https://notebooklm.google.com/notebook/[ID]`
- Istruzioni: "Apri index.html nel browser per la dashboard completa"

---

### Phase 5 — Dashboard HTML

Copia il template da `templates/dashboard_template.html` nella cartella run come `index.html`.
Sostituisci i placeholder:
- `{{TOPIC}}` → topic della run
- `{{MODE}}` → mode usato
- `{{DATE}}` → data odierna
- `{{NOTEBOOK_URL}}` → link al notebook

La dashboard carica i `.md` dinamicamente via `fetch()` — assicurati che i file siano nella stessa cartella.

---

## VINCOLI NON NEGOZIABILI

1. **Batch import**: mai 100+ fonti in un colpo — chunk da 20
2. **Sicurezza**: mai credenziali/token in output
3. **Notebook isolato**: ogni run = notebook separato (o usa esistente se esplicitamente richiesto)
4. **Fail gracefully**: la dashboard deve funzionare anche senza media
5. **Lingua**: output sempre in italiano salvo diversa indicazione

---

## STRUTTURA OUTPUT ATTESA

```
TSW - [MODE] - [TOPIC]/
├── 00_INDEX.md
├── 01_MASTER_BRIEF.md
├── 02_MAIN_DOC.md
├── 03_SCRIPT_LYRA.md
├── 04_CHECKLIST.md
├── 07_QUIZ.md
├── 08_FLASHCARDS.md
├── 09_AUDIO_BRIEF.mp3
├── 10_INFOGRAPHIC.png
├── 11_SLIDE_DECK.pdf
└── index.html
```
---
name: thespatialwave-system-os
version: 2.5.0-CLEAN
description: The Spatial Wave — Pipeline completa NotebookLM + AntiGravity. Da topic o notebook esistente genera documenti markdown, audio, infografica, quiz, flashcards, slide deck e dashboard HTML offline-ready. Self-healing nativo + assemblaggio HTML autonomo.
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

# THE SPATIAL WAVE — SYSTEM OS v2.5.0
## Skill per AntiGravity — Pipeline NotebookLM completa

---

## ISTRUZIONI PER L'AGENTE

Quando l'utente ti attiva con uno dei trigger, esegui questa procedura SENZA chiedere conferma ad ogni step. Chiedi solo le informazioni mancanti all'inizio, poi esegui tutto in autonomia.

---

## REGOLA DI SELF-HEALING — OBBLIGATORIA PER OGNI FILE MD GENERATO

> **Dopo ogni `notebooklm ask` che genera un file `.md`, prima di procedere al passo successivo:**
>
> 1. Leggi il file appena creato
> 2. Controlla se contiene righe che iniziano con: `Conversation:`, `Resumed`, `Continuing conversation`, `Answer:`, oppure blocchi che iniziano con un backtick isolato seguito da `**3.` o `**Step`
> 3. Se trovi queste righe/blocchi — rimuovili e riscrivi il file pulito
> 4. Verifica che il file risultante abbia contenuto significativo (almeno 200 caratteri)
> 5. Solo dopo la validazione, procedi al passo successivo
>
> **Questo è il tuo controllo qualità. Non delegarlo a script esterni.**

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
- `RUN_FOLDER` = `C:\Users\admin\Dev\ai-skill-notebook-knowledge\TSW-[MODE]-[TOPIC_SAFE]`
  dove `TOPIC_SAFE` = topic senza spazi e caratteri speciali (es. "Lyra-Hub", "XR-Reset")
  **⚠️ Mai usare spazi, parentesi [ ] o trattini nel percorso cartella — causano errori PowerShell**

```powershell
$TOPIC_SAFE = "Lyra Hub — positioning e funnel" -replace "[^a-zA-Z0-9]", "-" -replace "-+", "-"
$RUN_FOLDER = "C:\Users\admin\Dev\ai-skill-notebook-knowledge\TSW-CONTENT_PACK-$TOPIC_SAFE"
```

---

## STEP 1 — VERIFICA PREREQUISITI

```powershell
notebooklm --version
```

Se fallisce:
```powershell
$env:PATH += ";C:\Users\admin\AppData\Roaming\Python\Python313\Scripts"
notebooklm --version
```

Se ancora fallisce: avvisa l'utente e fermati.

---

## STEP 2 — NOTEBOOK SETUP

### CASO A — Notebook esistente (NOTEBOOK_ID fornito):

```powershell
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

### ⚠️ PRIMA DI TUTTO — Rilevamento tipo di topic

Valuta se il TOPIC è:

**A) Topic pubblico** (tecnologia, mercato, strategia, tool esistenti)
→ Esegui Discovery Web normalmente (Step 0.1)

**B) Brand personale / prodotto inventato** (es. "Lyra Hub", "XR Reset", brand TSW)
→ NON cercare sul web — troveresti aziende omonime sbagliate
→ Esegui Step 0.0 (raccolta materiali dall'utente)

**Come riconoscere un brand personale:**
- Non ha sito ufficiale indicizzato
- È un nome inventato / unico
- L'utente lo descrive come "mio prodotto", "mia community", "mio brand"
- Non ci sono risultati web affidabili nelle prime 3 ricerche

---

### Step 0.0 — SOLO per brand personali — Raccolta materiali utente

Chiedi all'utente in un'unica domanda:

> "Questo topic sembra un tuo brand/prodotto personale. Per creare contenuti accurati ho bisogno dei tuoi materiali originali. Incollami:
> 1. **Descrizione del prodotto/brand** (anche informale — cosa fa, per chi, quanto costa, cosa lo rende unico)
> 2. **Script o testi già scritti** (video, audio, post, email — qualsiasi testo esistente)
> 3. **Target reale** (chi compra, che problema risolve, che livello ha)
> 4. **URL tuoi** se hai sito, landing page, profili social, Skool community"

Usa le risposte come **fonte primaria** per il Seed Profile.
Non cercare sul web per fonti gold — usa solo i materiali forniti dall'utente + eventualmente ricerca su competitor (non sul brand stesso).

---

### Step 0.1 — Discovery Web (solo per topic pubblici)

Usa web search per trovare 10-25 fonti su `[TOPIC]`:
- Documentazione ufficiale / siti autorevoli
- Tutorial e case study
- Community: Reddit, forum, Discord, Skool, Facebook Groups
- Competitor (corsi, tool, community) — soprattutto se MODE=MARKETING_INTEL

**⚠️ IMPORTANTE:** Se i primi risultati non corrispondono al topic, fermati e tratta il topic come brand personale → vai a Step 0.0.

```powershell
mkdir "[RUN_FOLDER]"
mkdir "[RUN_FOLDER]\sources"
```

Scrivi `[RUN_FOLDER]\00_DISCOVERY_SOURCES.md` con tabella:
| Titolo | URL | Perché conta | Cosa estrarre |

Scrivi `[RUN_FOLDER]\sources\urls.txt` con 3-12 "gold URL" (uno per riga).

---

### Step 0.2 — Seed Profile

```powershell
mkdir "[RUN_FOLDER]"
mkdir "[RUN_FOLDER]\sources"
```

Sintetizza tutto in `[RUN_FOLDER]\00_SEED_PROFILE.md` (max 2 pagine):
- Obiettivo della run
- Target utente REALE + livello
- Pain point principali (con evidenze)
- Lista fonti gold (max 12 URL) — OPPURE testo seed se brand personale
- Artifact da generare (checklist)
- Competitor lista breve (se MODE=MARKETING_INTEL)
- Note speciali dall'utente
- Tono e voice del brand

---

### Step 0.2b — Website Scrape & Enrichment Avanzato (solo MEETING_PREP o MARKETING_INTEL competitor)

Se MODE=MEETING_PREP o si analizza un competitor corporate, cerca proattivamente:
- Sito ufficiale: About, Product/Service, Pricing, Team, Press, Careers
- LinkedIn company page (employee count, post recenti, hiring activity)
- Crunchbase / PitchBook (funding rounds, investors, valuation)
- News ultimi 6 mesi (TechCrunch, Il Sole 24 Ore, settore specifico)
- Wikipedia (se esiste)
- Glassdoor (segnali cultura aziendale)
- YouTube (video fondatori / pitch / demo)

Output: aggiungi URL trovati a `sources/urls.txt` e annota in `00_DISCOVERY_SOURCES.md`.

---

## Phase 1 — Creazione Notebook

```powershell
notebooklm create "TSW - [MODE] - [TOPIC]"
notebooklm use [NUOVO_ID]

$seedText = Get-Content -LiteralPath "$RUN_FOLDER\00_SEED_PROFILE.md" -Raw -Encoding utf8
notebooklm source add --text $seedText --title "TSW SEED PROFILE - $TOPIC" --wait

$urls = Get-Content -LiteralPath "$RUN_FOLDER\sources\urls.txt" | Where-Object { $_.Trim() -ne "" }
foreach ($url in $urls) {
    notebooklm source add $url.Trim() --wait
    Start-Sleep -Seconds 2
}
```

---

## Phase 2 — Deep Research

```powershell
# Per topic PUBBLICI:
notebooklm source add-research "$TOPIC best practices tutorial errori comuni competitor community pain points 2025 2026" --mode deep --no-wait

# Per BRAND PERSONALI — cerca il MERCATO, mai il nome del brand:
# notebooklm source add-research "[SETTORE DEL BRAND] creator italiano community Skool 2025 2026" --mode deep --no-wait

notebooklm research wait
```

**⚠️ Mai importare 100+ fonti in un colpo — batch da 20 massimo**

---

## Phase 3 — Generazione Documenti

```powershell
mkdir "[RUN_FOLDER]"
```

### 3.1 — Master Brief

```powershell
notebooklm ask "Scrivi un MASTER BRIEF completo in italiano con queste sezioni: 1) Obiettivo (1 riga), 2) Target (chi è, livello, pain point principali con evidenze dalle fonti), 3) Promessa (cosa ottiene), 4) Differenziatori (rispetto ai competitor), 5) Struttura contenuti consigliata, 6) CTA principale, 7) KPI da monitorare. Stile chiaro, operativo, senza fluff." > "[RUN_FOLDER]\01_MASTER_BRIEF.md"
```

> **SELF-HEALING:** Leggi `01_MASTER_BRIEF.md`. Rimuovi eventuali righe `Conversation:`, `Resumed`, `Continuing conversation`, `Answer:` e blocchi backtick orfani. Verifica che il file contenga almeno 200 caratteri di contenuto reale. Se è vuoto o corrotto, rigenera.

---

### 3.2 — Main Document

```powershell
notebooklm ask "Scrivi il documento principale in italiano, struttura step-by-step: Perché (1 riga), Prerequisiti, Passaggi numerati con istruzioni precise, Errori comuni da evitare, Check finale, Risultato atteso. Se il topic è tecnico includi comandi in blocchi code. Scrivi in modo che un principiante possa seguire." > "[RUN_FOLDER]\02_MAIN_DOC.md"
```

> **SELF-HEALING:** Leggi `02_MAIN_DOC.md`. Rimuovi pollution CLI. Verifica contenuto minimo 200 caratteri.

---

### 3.3 — Script Lyra

```powershell
notebooklm ask "Scrivi lo script completo per la voce Lyra in italiano. Tono: autorevole, calmo, architettonico. Niente puntini di sospensione, niente commenti meta tipo 'ora parliamo di...'. Deve spiegare il contenuto del documento principale come se stessi insegnando a voce a qualcuno di intelligente. Fluente e naturale." > "[RUN_FOLDER]\03_SCRIPT_LYRA.md"
```

> **SELF-HEALING:** Leggi `03_SCRIPT_LYRA.md`. Rimuovi pollution CLI. Verifica contenuto minimo 200 caratteri.

---

### 3.4 — Checklist

```powershell
notebooklm ask "Genera una checklist operativa in italiano con: task specifico, tempo stimato, output richiesto, check di verifica. Segui l'ordine logico del MAIN_DOC. Aggiungi step 'carica screenshot + 3 righe nel Lab' dove appropriato." > "[RUN_FOLDER]\04_CHECKLIST.md"
```

> **SELF-HEALING:** Leggi `04_CHECKLIST.md`. Rimuovi pollution CLI. Verifica contenuto minimo 200 caratteri.

---

### 3.5 — Solo se MODE=MEETING_PREP

```powershell
notebooklm ask "Scrivi un briefing pre-meeting completo in italiano: 1) Company Overview (background, dimensioni, leadership, business model), 2) Landscape Competitivo, 3) Opportunità di Mercato (dati e cifre specifiche), 4) Key Talking Points (numerati, azionabili), 5) Gestione Obiezioni (tabella Obiezione/Risposta), 6) Next Steps consigliati." > "$RUN_FOLDER\05_MEETING_BRIEF.md"

notebooklm ask "Crea schede bio per i partecipanti al meeting: Nome, Ruolo, Background, Interessi professionali, Come approcciarli. Basati sulle fonti LinkedIn/web trovate." > "$RUN_FOLDER\06_PARTICIPANT_BIOS.md"

notebooklm ask "Analisi trimestrale: performance recente dell'azienda, KPI pubblici disponibili, trend del settore, rischi e opportunità per i prossimi 90 giorni." > "$RUN_FOLDER\07_QUARTERLY_INTEL.md"

notebooklm ask "Mappa dei potenziali punti di frizione: cosa potrebbe bloccare la collaborazione, obiezioni probabili, aree di disaccordo e come gestirle proattivamente." > "$RUN_FOLDER\08_FRICTION_MAP.md"
```

> **SELF-HEALING:** Leggi ognuno dei 4 file appena generati. Rimuovi pollution CLI da ciascuno. Verifica che nessuno sia vuoto o corrotto.

---

### 3.6 — Solo se MODE=MARKETING_INTEL

```powershell
notebooklm ask "Crea una mappa competitor con tabella: Nome, Posizionamento, Punti di forza, Punti deboli, Nostro vantaggio differenziale." > "[RUN_FOLDER]\05_MARKET_MAP.md"

notebooklm ask "Crea 2-4 personas target con: Nome, Età, Ruolo, Pain point principale (con citazione da fonti), Obiettivo, Obiezione tipica, Come raggiungerlo." > "[RUN_FOLDER]\06_TARGET_PERSONAS.md"

notebooklm ask "Tabella pain point → evidenza trovata nelle fonti → implicazione strategica per noi. Almeno 8 righe." > "[RUN_FOLDER]\07_PAINPOINTS_EVIDENCE.md"

notebooklm ask "Scrivi UVP (Unique Value Proposition), reason-to-believe con 3 prove concrete, positioning statement. Poi tagline breve (max 8 parole)." > "[RUN_FOLDER]\08_OFFER_POSITIONING.md"

notebooklm ask "Funnel TOFU/MOFU/BOFU completo: per ogni fase indica contenuti consigliati, piattaforma, CTA, KPI. Formato tabella." > "[RUN_FOLDER]\09_FUNNEL_BLUEPRINT.md"

notebooklm ask "10 angoli ads con: Angolo, Headline principale, Hook per video/reel, Formato consigliato. Basati sui pain point reali trovati nelle fonti." > "[RUN_FOLDER]\10_ADS_ANGLES.md"

notebooklm ask "Content calendar 4 settimane: data, piattaforma, tipo contenuto, topic specifico, CTA, note produzione. Formato tabella." > "[RUN_FOLDER]\11_CONTENT_CALENDAR.md"
```

> **SELF-HEALING:** Leggi ognuno dei 7 file appena generati. Rimuovi pollution CLI da ciascuno. Verifica che nessuno sia vuoto o corrotto.

---

## Phase 4 — Artifact Media

### ⚠️ ORDINE CRITICO per MARKETING_INTEL
Se MODE=MARKETING_INTEL, verifica che `11_CONTENT_CALENDAR.md` esista prima di procedere. Gli artifact usano prefissi 12-16 per evitare conflitti con i documenti strategici.

```powershell
notebooklm generate audio --no-wait
notebooklm generate infographic --orientation portrait --detail-level detailed --no-wait
notebooklm generate quiz --difficulty medium --question-count 8 --no-wait
notebooklm generate flashcards --difficulty medium --no-wait
notebooklm generate slide-deck --format detailed_deck --no-wait

# Parametri MCP equivalenti (se usi notebooklm-mcp invece del CLI):
# mcp: studio_create → artifact_type: "infographic", orientation: "portrait", detail_level: "detailed"
# mcp: studio_create → artifact_type: "audio", audio_format: "brief", audio_length: "short"
# mcp: studio_create → artifact_type: "quiz", question_count: 8, difficulty: "medium"
# mcp: studio_create → artifact_type: "flashcards", difficulty: "medium"
# mcp: studio_create → artifact_type: "slide_deck", slide_format: "detailed_deck"
```

Aspetta completamento (ripeti ogni 2 min):
```powershell
notebooklm artifact list
```

Scarica quando pronti:
```powershell
# CONTENT_PACK / MEETING_PREP:
notebooklm download quiz "[RUN_FOLDER]\07_QUIZ.md"
notebooklm download flashcards "[RUN_FOLDER]\08_FLASHCARDS.md"
notebooklm download audio "[RUN_FOLDER]\09_AUDIO_BRIEF.mp3"
notebooklm download infographic "[RUN_FOLDER]\10_INFOGRAPHIC.png"
notebooklm download slide-deck "[RUN_FOLDER]\11_SLIDE_DECK.pdf"

# MARKETING_INTEL (numeri 12-16 per evitare conflitto con docs strategici):
notebooklm download quiz "[RUN_FOLDER]\12_QUIZ.md"
notebooklm download flashcards "[RUN_FOLDER]\13_FLASHCARDS.md"
notebooklm download audio "[RUN_FOLDER]\14_AUDIO_BRIEF.mp3"
notebooklm download infographic "[RUN_FOLDER]\15_INFOGRAPHIC.png"
notebooklm download slide-deck "[RUN_FOLDER]\16_SLIDE_DECK.pdf"
```

> **SELF-HEALING Flashcards:** Apri il file flashcards scaricato. Conta le coppie Q:/A:. Se sono meno di 8, rigenera:
> ```powershell
> notebooklm ask "Genera 10 flashcard Q&A in italiano sul topic [TOPIC]. Formato esatto: Q: [domanda] / A: [risposta]. Una per riga." >> "[RUN_FOLDER]\08_FLASHCARDS.md"
> ```
> Poi leggi il file risultante, rimuovi pollution CLI, verifica che ci siano almeno 8 coppie Q:/A: valide.

---

## Phase 5 — Dashboard HTML (Assemblaggio Autonomo)

### ⚠️ REGOLE ASSOLUTE — NON NEGOZIABILI

1. **NON creare mai un nuovo file HTML da zero.**
2. **USA SEMPRE e SOLO il template:** `C:\Users\admin\Dev\NotebookLM-Skill-Extension-CLEAN\templates\dashboard_template.html`
3. **NON usare PowerShell per leggere e iniettare i file MD** — usa le tue capacità native (Python in memoria o file editing diretto) per evitare problemi di encoding e regex fragili.

Se il template non esiste, fermati e avvisa l'utente.

### Procedura Autonoma (metodo preferito):

1. **Leggi in memoria** il contenuto di `dashboard_template.html`
2. **Leggi i file `.md` già puliti** da Phase 3 (encoding UTF-8 rigoroso):
   - `01_MASTER_BRIEF.md`, `02_MAIN_DOC.md`, `03_SCRIPT_LYRA.md`, `04_CHECKLIST.md`
   - `07_QUIZ.md`, `08_FLASHCARDS.md` (o 12/13 per MARKETING_INTEL)
3. **Esegui un'ultima passata di pulizia in memoria** su ogni variabile letta: rimuovi qualsiasi occorrenza di `Conversation:`, `Resumed`, `Continuing conversation`, `Answer:`
4. **Sostituisci i placeholder nel template:**
   - `{{TOPIC}}` → topic corrente
   - `{{MODE}}` → MODE corrente
   - `{{DATE}}` → data odierna dd/MM/yyyy
   - `{{NOTEBOOK_ID}}` → ID notebook
   - `{{NOTEBOOK_URL}}` → `https://notebooklm.google.com/notebook/[NOTEBOOK_ID]`
   - `{{PRIORITY_PLATFORM}}` → piattaforma prioritaria (default: Instagram)
   - `{{CONTENT_BRIEF}}` → contenuto `01_MASTER_BRIEF.md`
   - `{{CONTENT_DOC}}` → contenuto `02_MAIN_DOC.md`
   - `{{CONTENT_SCRIPT}}` → contenuto `03_SCRIPT_LYRA.md`
   - `{{CONTENT_CHECKLIST}}` → contenuto `04_CHECKLIST.md`
   - `{{CONTENT_QUIZ_RAW}}` → contenuto quiz `.md`
   - `{{CONTENT_FLASHCARDS_RAW}}` → contenuto flashcards `.md`
5. **Genera `{{SOURCES_LIST}}`:** leggi `sources/urls.txt`, costruisci HTML lista con `<div class='source-item'>` per ogni URL
6. **Calcola `{{FILE_COUNT}}`** (numero file nella cartella) e **`{{TOTAL_SIZE}}`** (dimensione totale in MB)
7. **Salva** il file compilato in `[RUN_FOLDER]\index.html` — encoding rigorosamente UTF-8
8. **Verifica finale:** `index.html` deve esistere e pesare più di 50 KB. Se pesa meno, ripeti dall'inizio di Phase 5.

### Fallback PowerShell (solo se il metodo autonomo fallisce):

```powershell
$template = [System.IO.File]::ReadAllText("C:\Users\admin\Dev\NotebookLM-Skill-Extension-CLEAN\templates\dashboard_template.html", [System.Text.Encoding]::UTF8)
$brief      = [System.IO.File]::ReadAllText("$RUN_FOLDER\01_MASTER_BRIEF.md", [System.Text.Encoding]::UTF8)
$doc        = [System.IO.File]::ReadAllText("$RUN_FOLDER\02_MAIN_DOC.md", [System.Text.Encoding]::UTF8)
$script     = [System.IO.File]::ReadAllText("$RUN_FOLDER\03_SCRIPT_LYRA.md", [System.Text.Encoding]::UTF8)
$checklist  = [System.IO.File]::ReadAllText("$RUN_FOLDER\04_CHECKLIST.md", [System.Text.Encoding]::UTF8)
$quiz       = [System.IO.File]::ReadAllText("$RUN_FOLDER\07_QUIZ.md", [System.Text.Encoding]::UTF8)
$flashcards = [System.IO.File]::ReadAllText("$RUN_FOLDER\08_FLASHCARDS.md", [System.Text.Encoding]::UTF8)

$html = $template
$html = $html.Replace("{{TOPIC}}", $TOPIC)
$html = $html.Replace("{{MODE}}", $MODE)
$html = $html.Replace("{{DATE}}", (Get-Date -Format "dd/MM/yyyy"))
$html = $html.Replace("{{NOTEBOOK_ID}}", $NOTEBOOK_ID)
$html = $html.Replace("{{NOTEBOOK_URL}}", "https://notebooklm.google.com/notebook/$NOTEBOOK_ID")
$html = $html.Replace("{{PRIORITY_PLATFORM}}", $PRIORITY_PLATFORM)
$html = $html.Replace("{{CONTENT_BRIEF}}", $brief)
$html = $html.Replace("{{CONTENT_DOC}}", $doc)
$html = $html.Replace("{{CONTENT_SCRIPT}}", $script)
$html = $html.Replace("{{CONTENT_CHECKLIST}}", $checklist)
$html = $html.Replace("{{CONTENT_QUIZ_RAW}}", $quiz)
$html = $html.Replace("{{CONTENT_FLASHCARDS_RAW}}", $flashcards)

$sourceLines = (Get-Content -LiteralPath "$RUN_FOLDER\sources\urls.txt") | Where-Object { $_.Trim() -ne "" }
$i = 0
$sourcesHtml = ($sourceLines | ForEach-Object { $i++; "<div class='source-item'><div class='source-num'>$i</div><a href='$($_.Trim())' target='_blank' class='source-url'>$($_.Trim())</a></div>" }) -join "`n"
$html = $html.Replace("{{SOURCES_LIST}}", $sourcesHtml)

$fileCount = (Get-ChildItem -LiteralPath $RUN_FOLDER -File | Measure-Object).Count
$totalSize = "{0:N1} MB" -f ((Get-ChildItem -LiteralPath $RUN_FOLDER -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1MB)
$html = $html.Replace("{{FILE_COUNT}}", $fileCount.ToString())
$html = $html.Replace("{{TOTAL_SIZE}}", "~$totalSize")

[System.IO.File]::WriteAllText("$RUN_FOLDER\index.html", $html, [System.Text.Encoding]::UTF8)

$size = (Get-Item -LiteralPath "$RUN_FOLDER\index.html").Length
if ($size -lt 50000) { Write-Host "ERRORE: index.html troppo piccolo ($size bytes) — ripeti Phase 5" }
else { Write-Host "OK: index.html generato ($size bytes)" }
```

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
- Se flashcards < 8 Q&A → usa fallback query (vedi Phase 4 Self-Healing)
- La dashboard deve funzionare anche senza i file media
- Mai bloccarsi su un singolo step
- Se AntiGravity va in crash → cambia modello (es. Gemini Pro High) e riprendi dall'ultimo step completato

---

## VINCOLI NON NEGOZIABILI

1. Mai importare 100+ fonti in un colpo — chunk da 20
2. Mai inserire credenziali o token nell'output
3. Notebook isolato per ogni run
4. Output sempre in italiano salvo diversa indicazione
5. Chiedi i parametri UNA VOLTA all'inizio — poi esegui tutto da solo
6. **Self-healing obbligatorio dopo ogni file MD generato** — non saltare mai questo step
7. **Phase 5: metodo autonomo sempre preferito** — PowerShell solo come fallback

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
│   ── CONTENT_PACK:
├── 07_QUIZ.md
├── 08_FLASHCARDS.md
├── 09_AUDIO_BRIEF.mp3
├── 10_INFOGRAPHIC.png
├── 11_SLIDE_DECK.pdf
│
│   ── MEETING_PREP (aggiuntivi):
├── 05_MEETING_BRIEF.md
├── 06_PARTICIPANT_BIOS.md
├── 07_QUARTERLY_INTEL.md
├── 08_FRICTION_MAP.md
│
│   ── MARKETING_INTEL (aggiuntivi):
├── 05_MARKET_MAP.md
├── 06_TARGET_PERSONAS.md
├── 07_PAINPOINTS_EVIDENCE.md
├── 08_OFFER_POSITIONING.md
├── 09_FUNNEL_BLUEPRINT.md
├── 10_ADS_ANGLES.md
├── 11_CONTENT_CALENDAR.md
├── 12_QUIZ.md → 16_SLIDE_DECK.pdf
│
├── index.html                   ← dashboard offline-ready
└── sources/
    └── urls.txt
```
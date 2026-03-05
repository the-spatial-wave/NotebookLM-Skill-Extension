# THE SPATIAL WAVE — System OS
### NotebookLM Skill Extension for AntiGravity

> **Topic grezzo → NotebookLM → Documenti + Audio + Infografica + Dashboard HTML**

Una pipeline completa che connette AntiGravity a NotebookLM per generare pacchetti documentali, artifact media e dashboard glassmorphic (Lyra palette) — tutto in locale, tutto automatizzato.

---

## Cosa genera

| File | Descrizione |
|------|-------------|
| `01_MASTER_BRIEF.md` | Brief strategico: target, pain point, CTA, KPI |
| `02_MAIN_DOC.md` | Documento tecnico step-by-step |
| `03_SCRIPT_LYRA.md` | Script voce per Lyra — tono calmo, autorevole |
| `04_CHECKLIST.md` | Checklist operativa con tempi stimati |
| `07_QUIZ.md` | Quiz 8 domande (NotebookLM Studio) |
| `08_FLASHCARDS.md` | Flashcard Q&A (NotebookLM Studio) |
| `09_AUDIO_BRIEF.mp3` | Audio overview podcast (NotebookLM Studio) |
| `10_INFOGRAPHIC.png` | Infografica visuale (NotebookLM Studio) |
| `11_SLIDE_DECK.pdf` | Slide deck (NotebookLM Studio) |
| `index.html` | Dashboard HTML offline-ready (Lyra palette) |

---

## Modi disponibili

- **CONTENT_PACK** — Pacchetto contenuti per Skool / Instagram / LinkedIn
- **MARKETING_INTEL** — Competitor analysis + funnel + ads angles
- **MEETING_PREP** — Briefing pre-call per partner o brand

---

## Setup

### 1. Installa dipendenze

```bash
pip install "notebooklm-py[browser]"
playwright install chromium
```

### 2. Aggiungi al PATH (Windows)

```bash
[System.Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";C:\Users\[TUO_USERNAME]\AppData\Roaming\Python\Python313\Scripts", "User")
```

### 3. Login NotebookLM

```bash
notebooklm login
# Si apre Chromium — accedi con Google, poi premi ENTER nel terminale
```

### 4. Verifica

```bash
notebooklm list
# Deve listare i tuoi notebook
```

### 5. Installa la skill in AntiGravity

```bash
notebooklm skill install antigravity
```

Oppure clona manualmente nella cartella skills di AntiGravity:

```bash
git clone https://github.com/the-spatial-wave/NotebookLM-Skill-Extension.git
```

---

## Utilizzo

Una volta installata la skill, parla ad AntiGravity in linguaggio naturale:

```
"Lancia pipeline TSW CONTENT_PACK sul topic WebXR 2026"

"Crea un pacchetto contenuti su strategie Skool per creator italiani"

"Analizza i competitor di XR Reset con MODE MARKETING_INTEL"

"Meeting prep per una call con [Brand]"
```

---

## Dipendenze

- [`notebooklm-py`](https://github.com/teng-lin/notebooklm-py) ≥ 0.3.3
- AntiGravity (Google) con MCP `notebooklm-mcp` configurato

---

## Struttura repo

```
NotebookLM-Skill-Extension/
├── SKILL.md                          ← istruzioni per AntiGravity
├── README.md                         ← questo file
├── requirements.txt
├── THE_SPATIAL_WAVE_SYSTEM_OS.pdf    ← System OS completo
├── prompts/
│   ├── CONTENT_PACK.md
│   ├── MARKETING_INTEL.md
│   └── MEETING_PREP.md
└── templates/
    └── dashboard_template.html
```

---

## Note tecniche

- Usa API non documentate di Google (`batchexecute` RPC) — può rompersi se Google cambia gli endpoint
- Output sempre in locale, nessun dato inviato a servizi esterni
- Notebook isolato per ogni run — nessuna contaminazione tra sessioni
- Dashboard funziona offline (tutti i file in locale)

---

*The Spatial Wave — Lyra System OS*
*[thespatialwave.com](https://thespatialwave.com)*
# TSW System OS — NotebookLM Skill Extension
**v2.5.0 · The Spatial Wave · Marzo 2026**

Skill per AntiGravity che automatizza la produzione di knowledge pack tramite NotebookLM.
Da un topic o notebook esistente genera documenti, media e una dashboard HTML offline-ready.

---

## Output per run

| File | Contenuto |
|---|---|
| `01_MASTER_BRIEF.md` | Brief operativo: obiettivo, target, CTA, KPI |
| `02_MAIN_DOC.md` | Documento principale step-by-step |
| `03_SCRIPT_LYRA.md` | Script voce: autorevole, calmo, architettonico |
| `04_CHECKLIST.md` | Checklist operativa con tempi e output |
| `07_QUIZ.md` | Quiz interattivo 8 domande |
| `08_FLASHCARDS.md` | Flashcard Q/A |
| `09_AUDIO_BRIEF.mp3` | Audio narrazione Lyra Voice |
| `10_INFOGRAPHIC.png` | Infografica portrait |
| `11_SLIDE_DECK.pdf` | Slide deck |
| `index.html` | Dashboard HTML offline completa |

---

## Dashboard v4

- 8 tab di contenuto (Brief, Doc, Script, Checklist, Quiz, Flashcards, Media, Fonti)
- Modal export per ogni file: TXT · MD · PDF · JSON · PNG
- Push to Kanban → `localStorage('tsw_kanban_import')` per AI Content Factory
- Offline-ready — nessuna dipendenza npm, tutto CDN

---

## MODE disponibili

| MODE | Use case |
|---|---|
| `CONTENT_PACK` | Pacchetto knowledge su qualsiasi topic |
| `MARKETING_INTEL` | Analisi competitor, funnel, ads angles |
| `MEETING_PREP` | Prep meeting con bio e friction map |
| `COURSE_CREATOR` | Moduli formativi strutturati |

---

## Requisiti

```bash
pip install notebooklm-py --break-system-packages  # >= 0.3.3
# Python >= 3.13
# AntiGravity (Cursor/VSCode fork)
```

---

## Struttura repo

```
├── SKILL.md                    ← skill principale
├── templates/
│   └── dashboard_template.html ← template dashboard v4
├── prompts/                    ← prompt per ogni MODE
├── assemble_dashboard.ps1      ← fallback PowerShell Phase 5
├── requirements.txt
└── LICENSE
```

---

## Rigenera dashboard (PowerShell)

```powershell
$RUN = "C:\Users\admin\Dev\ai-skill-notebook-knowledge\TSW-[MODE]-[TOPIC_SAFE]"
$TEMPLATE = "C:\Users\admin\Dev\NotebookLM-Skill-Extension-CLEAN\templates\dashboard_template.html"
$html = [System.IO.File]::ReadAllText($TEMPLATE, [System.Text.Encoding]::UTF8)
$html = $html.Replace("{{TOPIC}}","Il Tuo Topic")
# ... sostituisci tutti i placeholder
[System.IO.File]::WriteAllText("$RUN\index.html", $html, [System.Text.Encoding]::UTF8)
```

---

*The Spatial Wave · [thespatialwave.com](https://thespatialwave.com)*
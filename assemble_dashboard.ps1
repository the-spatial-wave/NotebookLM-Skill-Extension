$RUN_FOLDER = "c:\Users\admin\Dev\ai-skill-notebook-knowledge\TSW-COURSE_CREATOR-XR-Scene-7-Gidorni"
$TEMPLATE_PATH = "c:\Users\admin\Dev\NotebookLM-Skill-Extension-CLEAN\templates\dashboard_template.html"
$TOPIC = "Crea la tua prima XR scena in 7 giorni"
$MODE = "COURSE_CREATOR"
$NOTEBOOK_ID = "196d687a-785e-4319-9dcc-93030a7ce64a"

function Clean-Markdown($path) {
    if (Test-Path $path) {
        $content = Get-Content -Path $path -Raw
        $content = $content -replace '(?s)Different notebook.*?\.\.\.\s*', ''
        $content = $content -replace '(?s)Continuing conversation.*?\.\.\.\s*', ''
        return $content
    }
    return ""
}

$template = Get-Content -Path $TEMPLATE_PATH -Raw
$brief = Clean-Markdown "$RUN_FOLDER\01_MASTER_BRIEF.md"
$doc = Clean-Markdown "$RUN_FOLDER\02_MAIN_DOC.md"
$curriculum = Clean-Markdown "$RUN_FOLDER\05_CURRICULUM_MAP.md"
$lessons = Clean-Markdown "$RUN_FOLDER\06_LESSON_SCRIPTS.md"
$worksheets = Clean-Markdown "$RUN_FOLDER\07_WORKSHEETS.md"
$skool = Clean-Markdown "$RUN_FOLDER\08_SKOOL_SETUP.md"

$html = $template
$html = $html.Replace("{{TOPIC}}", $TOPIC)
$html = $html.Replace("{{MODE}}", $MODE)
$html = $html.Replace("{{DATE}}", (Get-Date -Format "dd/MM/yyyy"))
$html = $html.Replace("{{NOTEBOOK_ID}}", $NOTEBOOK_ID)
$html = $html.Replace("{{NOTEBOOK_URL}}", "https://notebooklm.google.com/notebook/$NOTEBOOK_ID")
$html = $html.Replace("{{CONTENT_BRIEF}}", $brief)
$html = $html.Replace("{{CONTENT_DOC}}", $doc)
$html = $html.Replace("{{CONTENT_CURRICULUM}}", $curriculum)
$html = $html.Replace("{{CONTENT_LESSONS}}", $lessons)
$html = $html.Replace("{{CONTENT_WORKSHEETS}}", $worksheets)
$html = $html.Replace("{{CONTENT_SKOOL_SETUP}}", $skool)
$html = $html.Replace("{{COURSE_DISPLAY}}", "flex")

# Default placeholders for other modes (not used in COURSE_CREATOR but needed for template stability)
$html = $html.Replace("{{CONTENT_SCRIPT}}", "")
$html = $html.Replace("{{CONTENT_CHECKLIST}}", "")
$html = $html.Replace("{{CONTENT_QUIZ}}", "")
$html = $html.Replace("{{CONTENT_FLASHCARDS}}", "")
$html = $html.Replace("{{PRIORITY_PLATFORM}}", "Skool")

$html | Out-File -FilePath "$RUN_FOLDER\index.html" -Encoding utf8
Write-Host "Dashboard index.html generata con successo in $RUN_FOLDER"

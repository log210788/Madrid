# build_turns_json.ps1
$ErrorActionPreference = 'Stop'

function Get-Seconds($t) {
    $p = $t.Split(':')
    if ($p.Count -eq 2) { return [int]$p[0]*60 + [int]$p[1] }
    if ($p.Count -eq 3) { return [int]$p[0]*3600 + [int]$p[1]*60 + [int]$p[2] }
    return 0
}

Write-Host "Loading configuration and transcript..."
$chaptersRaw = [System.IO.File]::ReadAllText("$PSScriptRoot\chapters.json", [System.Text.Encoding]::UTF8)
$chapters = $chaptersRaw | ConvertFrom-Json

$asrRaw = [System.IO.File]::ReadAllText("$PSScriptRoot\asr_replacements.json", [System.Text.Encoding]::UTF8)
$asrReplacements = $asrRaw | ConvertFrom-Json

$vocabTagsRaw = [System.IO.File]::ReadAllText("$PSScriptRoot\vocab_tags.json", [System.Text.Encoding]::UTF8)
$vocabTags = $vocabTagsRaw | ConvertFrom-Json

# Sort vocab tags by pattern length descending to avoid substring clashes
$vocabTags = $vocabTags | Sort-Object { $_.p.Length } -Descending

$transcriptPath = "$PSScriptRoot\Transcript\10-23-2026.txt"
if (-not (Test-Path $transcriptPath)) {
    throw "Transcript file not found: $transcriptPath"
}
$rawLines = Get-Content $transcriptPath -Encoding UTF8
$rawTurns = @()
$currentSpeaker = ''
$currentTime = ''
$currentText = @()

foreach ($line in $rawLines) {
    if ($line -match '^([^|]+)\s*\|\s*([0-9:]+)') {
        if ($currentSpeaker -ne '') {
            $rawTurns += [PSCustomObject]@{
                rawSpeaker = $currentSpeaker.Trim()
                time = $currentTime.Trim()
                sec = (Get-Seconds $currentTime.Trim())
                text = ($currentText -join ' ').Trim()
            }
        }
        $currentSpeaker = $matches[1]
        $currentTime = $matches[2]
        $currentText = @()
    } else {
        if ($line.Trim() -ne '') {
            $currentText += $line.Trim()
        }
    }
}
if ($currentSpeaker -ne '') {
    $rawTurns += [PSCustomObject]@{
        rawSpeaker = $currentSpeaker.Trim()
        time = $currentTime.Trim()
        sec = (Get-Seconds $currentTime.Trim())
        text = ($currentText -join ' ').Trim()
    }
}

Write-Host "Parsed $($rawTurns.Count) raw speaking turns from transcript."

$assignedChaps = @{}
$finalTurns = @()

for ($i = 0; $i -lt $rawTurns.Count; $i++) {
    $t = $rawTurns[$i]
    $turnNum = $i + 1
    $turnId = "turn-$turnNum"
    
    $chapId = ''
    $chapTitle = ''

    # Check each chapter in sequence
    foreach ($ch in $chapters) {
        if (-not $assignedChaps.ContainsKey($ch.id) -and $t.sec -ge $ch.minSec) {
            $chapId = $ch.id
            $chapTitle = $ch.title
            $assignedChaps[$ch.id] = $true
            break
        }
    }

    $speaker = if ($t.rawSpeaker -eq 'Diego') { 'Diego' } else { 'Louie' }
    $text = $t.text

    # Apply forensic ASR replacements
    foreach ($asr in $asrReplacements) {
        if ($text.Contains($asr.match)) {
            $text = $text.Replace($asr.match, $asr.replace)
        }
    }

    # Tag vocabulary safely outside existing HTML tags
    foreach ($vt in $vocabTags) {
        if ($text.Contains("data-vkey=`"$($vt.k)`"")) {
            continue
        }

        $tokens = [regex]::Split($text, "(<[^>]+>)")
        $newTokens = @()
        $insideSpan = 0
        $tagged = $false

        for ($j = 0; $j -lt $tokens.Count; $j++) {
            $tok = $tokens[$j]
            if ($tok.StartsWith("<") -and $tok.EndsWith(">")) {
                if ($tok -match '^<span\b') { $insideSpan++ }
                elseif ($tok -match '^</span\b') { if ($insideSpan -gt 0) { $insideSpan-- } }
                $newTokens += $tok
            } else {
                if ($insideSpan -eq 0 -and -not $tagged -and $tok.Trim() -ne "") {
                    $patt = [regex]::Escape($vt.p)
                    $regexPattern = "(?i)\b($patt)\b"
                    if ([regex]::IsMatch($tok, $regexPattern)) {
                        $replacement = "<span class=`"vocab-mark`" data-vkey=`"$($vt.k)`" onclick=`"inspectVocab('$($vt.k)')`">`$1</span>"
                        $tok = [regex]::Replace($tok, $regexPattern, $replacement, 1)
                        $tagged = $true
                    }
                }
                $newTokens += $tok
            }
        }
        $text = $newTokens -join ""
    }

    # Validate tag pairing for this turn
    $openSpans = ([regex]::Matches($text, "<span\b")).Count
    $closeSpans = ([regex]::Matches($text, "</span>")).Count
    if ($openSpans -ne $closeSpans) {
        Write-Warning "Mismatched span tags in $turnId ($($t.time)): $openSpans open, $closeSpans close."
    }

    $finalTurns += [PSCustomObject]@{
        id = $turnId
        chapterId = $chapId
        chapterTitle = $chapTitle
        speaker = $speaker
        time = $t.time
        html = $text
    }
}

Write-Host "Writing turns.json..."
$json = $finalTurns | ConvertTo-Json -Depth 5
[System.IO.File]::WriteAllText("$PSScriptRoot\turns.json", $json, [System.Text.Encoding]::UTF8)

$size = (Get-Item "$PSScriptRoot\turns.json").Length
Write-Host "SUCCESS! Generated turns.json ($size bytes, $($finalTurns.Count) turns)."

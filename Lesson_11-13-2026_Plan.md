# In-Depth Lesson Plan & Teaching Guide — Diego
**Time:** Friday, Nov 13, 2026 • 22:00 – 22:50 BKK (50 mins)
**Focus:** High-Stakes Incident Post-Mortem & Stakeholder Alignment (Building on [Nov 4](./Lesson_11-04-2026_Notes.md))
**Companion Files:** [Worksheet](./Lesson_11-13-2026_Worksheet.md) • [Preply Canvas Kit](./Lesson_11-13-2026_Preply_Canvas.md)

---

## 🎯 Teaching Philosophy for This Lesson
Diego works in a Dutch/Amsterdam engineering culture (**Polder model**—consensus-driven, direct, low ego) and needs to switch seamlessly between **blameless engineering discussions** and **calm, reassuring executive summaries**.
- **Correction Rule:** Watch for his recurring Spanish-transfer slips from Nov 4 (`used to` vs `usually`, `account` vs `bill`, `half-hour` hyphenation, `all together` vs `altogether`). Fix them briskly in Step 1 so they stay top-of-mind during the role-play.

---

## ⏱️ Minute-by-Minute Teaching Script

### 1. Warm-Up & Nov 4 Polish Drill (00:00 – 08:00)
*Paste Preply Canvas Block 1.*
- **Worksheet Part 1 Answer Key:**
  1. `usually` / `bill` (*"In Amsterdam, we usually split the bill."*)
  2. `was` / `late` / `half-hour` (*"I was half an hour late to a half-hour meeting."*)
  3. `all together` (*two words = as a group; `altogether` = completely*).
- **Quick Recall (4 mins):** Ask Diego to connect 2–3 Nov 4 terms (`crunch time`, `Polder model`, `customer churn`, `retention`, `observability`, `tech debt`, `open up the floor`) to anything that actually happened in his sprint this week.

### 2. Leadership Phrasal Verbs Primer (08:00 – 15:00)
*Paste Preply Canvas Block 3 BEFORE the role-play so he can deploy them live!*
- **Worksheet Part 2 Answer Key:** `1-C` (*roll out*), `2-D` (*iron out*), `3-A` (*flag up*), `4-B` (*sign off on*).
- **How to teach it:** Elicit the meaning from engineering context:
  - *"Do we deploy to 100% of users on day one, or **roll it out** gradually?"*
  - *"Before QA **signs off on** the release, we need to **iron out** two edge cases and **flag up** any billing risks."*

### 3. Core Role-Play: Amsterdam Billing Outage Post-Mortem (15:00 – 42:00)
*Paste Preply Canvas Block 2.*
- **Scenario Brief (2 mins):** *"During the legacy billing migration, a missing dead-letter queue retry caused 45 minutes of failed invoices and real **customer churn** risk."*
- **Part A — Dutch Engineering Team / Polder Model (12 mins):**
  - **Louie's Role:** Play *Bram* (a blunt Dutch senior dev who suggests *"Let's just patch it this Saturday so it's done"*) and *Sanne* (quiet junior dev).
  - **Diego's Goals:**
    1. **Open up the floor** warmly to Sanne (*"Sanne, what did you notice in the logs?"*).
    2. Keep it blameless—focus on **observability** and **tech debt**, not who forgot the retry.
    3. Push back diplomatically on Saturday work using **Polder consensus** (*"Before anyone signs off on weekend work, let's flag up the risk of rushing..."*).
- **Micro-Debrief (3 mins):** Praise 2 strong leadership lines; upgrade 1 phrasing slip.
- **Part B — Non-Technical Product Manager Update (10 mins):**
  - **Louie's Role:** Play an anxious PM: *"Diego, I have a board call in 10 minutes—did we lose customers? Can you explain what a 'dead-letter queue' even is without jargon?"*
  - **Diego's Goal:** Deliver a **90-second plain-English summary** covering: (1) what failed and for how long, (2) how we're paying down **tech debt** and **ironing out** alerts, and (3) how we'll **roll out** the fix safely to protect **retention**.

### 4. Wrap-Up & Homework (42:00 – 50:00)
*Paste Preply Canvas Block 4.*
- Celebrate 3 strong phrases from the two audiences + 2 gentle polishes.
- **Homework:** Draft a **4-sentence Slack/email post-mortem summary** for stakeholders using at least 3 phrases from today.

---

## 🛟 Pacing Rescue & Extension
- **If Part B finishes fast:** Challenge Diego to cut his 90-second PM update down to a **30-second "elevator version"** (headline → fix → timeline).
- **If he gets bogged down in technical jargon in Part B:** Interrupt playfully as the PM: *"Hold on—translate 'dead-letter queue' for the CEO in one sentence!"*

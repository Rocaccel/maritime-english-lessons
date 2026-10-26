# Agent Memo — Maritime English Lessons

## Project root
C:\Users\ser\Desktop\GitHub\maritime-english-lessons-new

## Git workflow (mandatory)
- `git init` already done in root.
- After EVERY change: `git add <file>; git commit -m "<type>: <message>"`

## Folder structure
```
Unit-1/             # source .md + images (*.png)
Unit-2/
Unit-3/
docs/
  index.html          # index with cards (no PART 1 / MD tags)
  lessons/
    lesson-1.html     # built page
```

## How to create a new lesson page (e.g. lesson-2.html)
1. Copy `docs/lessons/lesson-1.html` → `docs/lessons/lesson-2.html`
2. Update `<title>` and headings.
3. Fix image paths: from `../../lesson-1/` to `../../lesson-2/` (in `src`, `background:url`, and hero `background`).
4. Keep lightbox script (already embedded) and back-link `<a href="../index.html">`.
5. Keep design: no `PART 1 / PART 2 / HTML / MD` meta tags.
6. Commit.

## How to add/update index card (`docs/index.html`)
- Card structure: `<a class="card" href="lessons/lesson-X.html">` (or `.md` for non-HTML).
- No `.meta` tags inside cards.
- Link back to index inside lesson page: `<a href="../index.html">← Оглавление уроков</a>` in `.hero-inner`.

## Navigation buttons (inside `.hero-inner`)
- Always include centered flex container with gap `.6rem`: `display:flex;gap:.6rem;justify-content:center;`
- Left: `← Оглавление уроков` → `../index.html`
- Right: `Следующий урок →` → `lesson-(X+1).html` ONLY if this is NOT the last lesson in repo.
- Last lesson has ONLY the left button.

## Design rules (do not change without user approval)
- Hero with ship image background (`Строении корпуса судна.png` or `lesson-X/*.jpg` / `*.png`).
- Dark navy / gold / sand color palette.
- Tables for terminology; `.callout` blocks for notes.
- `cursor:zoom-in` on `.lesson-img`; lightbox on click (`.lightbox.active`).
- Back-to-index link always present at top of lesson page.
- No `.meta` tags (`PART 1`, `MD`, `HTML`) anywhere.
- Index cards must link to `.html` files, not `.md`.

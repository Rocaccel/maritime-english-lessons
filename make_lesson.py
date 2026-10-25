#!/usr/bin/env python3
"""Build lesson HTML from lesson-N/ source files. Run from terminal."""
import sys, re, subprocess, glob, os

ROOT = os.path.dirname(os.path.abspath(__file__))

def md_to_html(path, folder):
    with open(path, encoding='utf-8') as f:
        lines = f.read().splitlines()
    html = []
    i = 0
    in_table = False
    table_hdr = []
    table_rows = []
    def flush_table():
        nonlocal in_table, table_hdr, table_rows
        if not in_table: return
        out = '<div class="table-wrap"><table><thead><tr>'
        out += ''.join(f'<th>{cell}</th>' for cell in table_hdr)
        out += '</tr></thead><tbody>'
        for row in table_rows:
            out += '<tr>' + ''.join(f'<td>{cell}</td>' for cell in row) + '</tr>'
        out += '</tbody></table></div>'
        html.append(out)
        in_table = False; table_hdr = []; table_rows = []
    while i < len(lines):
        line = lines[i]
        # headings
        m = re.match(r'^(#{1,3})\s+(.*)', line)
        if m:
            flush_table()
            level = len(m.group(1))
            html.append(f'<h{level + 1}>{m.group(2).strip()}</h{level + 1}>')
            i += 1; continue
        # tables
        if line.startswith('|'):
            flush_table()
            in_table = True
            cells = [c.strip() for c in line.split('|') if c != '']
            if not table_hdr:
                table_hdr = cells
            else:
                table_rows.append(cells)
            i += 1; continue
        # images
        m = re.search(r'!\[([^]]*)\]\(([^)]+)\)', line)
        if m:
            flush_table()
            src = m.group(2)
            alt = m.group(1) or ''
            html.append(f'<img class="lesson-img" src="../../{folder}/{os.path.basename(src)}" alt="{alt}">')
            if i+1 < len(lines) and lines[i+1].startswith('*'):
                html.append(f'<p class="caption">{lines[i+1].strip("*")}</p>')
                i += 1
            i += 1; continue
        # bold terms
        if '**' in line:
            flush_table()
            line = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', line)
        html.append(f'<p>{line}</p>')
        i += 1
    flush_table()
    return '\n'.join(html)

if __name__ == '__main__':
    folder = sys.argv[1] if len(sys.argv) > 1 else 'lesson-1'
    md_file = os.path.join(ROOT, folder, f'{folder}-text.md')
    if not os.path.isfile(md_file):
        md_file = glob.glob(os.path.join(ROOT, folder, '*.md'))[0]
    content = md_to_html(md_file, folder)
    out_path = os.path.join(ROOT, 'html', 'lessons', f'{folder}.html')
    # Read template from lesson-1.html and replace <main>...</main> and title
    with open(os.path.join(ROOT, 'html', 'lessons', 'lesson-1.html'), 'r', encoding='utf-8') as f:
        template = f.read()
    # Update title
    template = template.replace('Lesson 1 — Main Parts of a Vessel', f'Lesson {folder.replace("lesson-","")} — {folder.replace("-"," ").title()}')
    # Fix hero background image reference
    template = template.replace('../../lesson-1/Строении корпуса судна.png', f'../../{folder}/Строении корпуса судна.png')
    # Replace main content
    template = re.sub(r'<main>.*?</main>', f'<main>\n{content}\n</main>', template, flags=re.DOTALL)
    with open(out_path, 'w', encoding='utf-8') as out:
        out.write(template)
    # git
    subprocess.run(['git', 'add', out_path], check=False)
    subprocess.run(['git', 'commit', '-m', f'auto: build {folder} from md'], check=False)
    print('Built', out_path)

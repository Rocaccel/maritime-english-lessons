const REPO = 'Rocaccel/maritime-english-lessons';
const BRANCH = 'master';
function raw(path){ return `https://raw.githubusercontent.com/${REPO}/${BRANCH}/${path}`; }
function api(path){ return `https://api.github.com/repos/${REPO}/contents/${path}?ref=${BRANCH}`; }

async function fetchDir(lesson){
  const res = await fetch(api(`lesson-${lesson}`));
  if(!res.ok) throw new Error('Dir not found');
  return res.json();
}

async function loadMarkdown(path){
  const res = await fetch(raw(path));
  if(!res.ok) return null;
  const md = await res.text();
  return marked.parse(md);
}

function renderImages(files){
  const imgs = files.filter(f=> /\.(png|jpe?g|gif|webp)$/i.test(f.name));
  if(!imgs.length) return '';
  const html = imgs.map(f=> `<figure class="card"><img src="${raw(f.path)}" alt="${f.name}"><figcaption>${f.name}</figcaption></figure>`).join('');
  return `<section><h2>Изображения</h2><div class="grid">${html}</div></section>`;
}

async function loadLesson(lesson){
  const files = await fetchDir(lesson);
  let html = '';
  // Main text
  const main = files.find(f=> f.name === `lesson-${lesson}-text.md`);
  if(main){
    const content = await loadMarkdown(main.path);
    html += `<section><h2>Основной текст</h2><article class="card">${content}</article></section>`;
  }
  // Work texts
  const parts = files.filter(f=> f.name.startsWith(`lesson-${lesson}_part-`) && f.name.endsWith('.md'));
  if(parts.length){
    html += `<section><h2>Work Text</h2>`;
    for(const p of parts){
      const c = await loadMarkdown(p.path);
      html += `<article class="card"><h3>${p.name.replace('.md','')}</h3>${c}</article>`;
    }
    html += `</section>`;
  }
  // Images
  html += renderImages(files);
  document.getElementById('content').innerHTML = html;
}

function getLessonFromHash(){
  const m = location.hash.match(/lesson-(\d+)/);
  return m ? m[1] : '1';
}

window.addEventListener('DOMContentLoaded', async ()=>{
  const lesson = getLessonFromHash();
  try{
    await loadLesson(lesson);
    document.getElementById('title').textContent = `Lesson ${lesson}`;
  }catch(e){
    document.getElementById('content').innerHTML = '<p>Урок не найден</p>';
  }
});
window.addEventListener('hashchange', async ()=>{
  const lesson = getLessonFromHash();
  try{
    await loadLesson(lesson);
    document.getElementById('title').textContent = `Lesson ${lesson}`;
  }catch(e){
    document.getElementById('content').innerHTML = '<p>Урок не найден</p>';
  }
});

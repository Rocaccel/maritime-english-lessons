const REPO = 'Rocaccel/maritime-english-lessons';
const BRANCH = 'master';
function raw(path){ return `https://raw.githubusercontent.com/${REPO}/${BRANCH}/${path}`; }
async function loadLesson(lesson){
  const res = await fetch(raw(`lesson-${lesson}/lesson-${lesson}-text.md`));
  if(!res.ok) throw new Error('Not found');
  const md = await res.text();
  const html = marked.parse(md);
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
  await loadLesson(lesson);
  document.getElementById('title').textContent = `Lesson ${lesson}`;
});

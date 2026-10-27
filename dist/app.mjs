import { examples, intake, explain, markdown } from './content.mjs';

const $ = id => document.getElementById(id);
const zone = $('dropzone');
let original = '', reply = null, generation = 0, timer, saveTimer;

function resetDrag() { zone.classList.remove('is-over'); }
function showError(message) { $('error').textContent = message; $('error').hidden = false; $('live').textContent = message; }

function ask(value) {
  let text;
  try { text = intake(value); } catch (error) { showError(error.message); return; }
  const request = ++generation;
  clearTimeout(timer); clearTimeout(saveTimer);
  original = text; reply = explain(text);
  resetDrag(); $('error').hidden = true; $('paste-form').hidden = true;
  $('answer-wrap').hidden = true; $('answer').dataset.open = 'false';
  $('loading').hidden = false;
  $('drop-label').textContent = text.length > 36 || text.includes('\n') ? '“這段話…”' : `“${text}”`;
  $('drop-prompt').textContent = '換成這一句';
  zone.classList.add('filled'); $('question').classList.add('has-text');
  zone.setAttribute('aria-label', '查看或修改剛才放入的原文');
  document.body.classList.add('answered');
  $('live').textContent = '已收到文字，正在展開示範解釋。';
  timer = setTimeout(() => {
    if (request !== generation) return;
    $('loading').hidden = true;
    $('original-text').textContent = original;
    $('original').open = false;
    $('answer-title').textContent = reply.title;
    $('answer-body').textContent = reply.body;
    $('answer-detail').textContent = reply.detail;
    $('answer-note').textContent = reply.note;
    $('example').hidden = !reply.example;
    $('example').open = false;
    $('example-text').textContent = reply.example ?? '';
    $('save-label').textContent = 'Keep as .md';
    $('answer-wrap').hidden = false;
    // Start the panel from its closed pose, then reveal on the following frame.
    void $('answer').offsetHeight;
    requestAnimationFrame(() => {
      if (request !== generation) return;
      $('answer').dataset.open = 'true';
      $('live').textContent = '示範解釋已展開。';
    });
  }, 650);
}

function openPaste() {
  $('paste-form').hidden = false;
  $('paste-input').value = original;
  $('paste-input').focus();
}

zone.addEventListener('dragover', event => {
  if (event.dataTransfer.types.includes('text/plain') && !event.dataTransfer.types.includes('Files')) {
    event.preventDefault(); event.dataTransfer.dropEffect = 'copy'; zone.classList.add('is-over');
  }
});
zone.addEventListener('dragleave', event => { if (!zone.contains(event.relatedTarget)) resetDrag(); });
zone.addEventListener('drop', event => {
  event.preventDefault(); resetDrag();
  if (event.dataTransfer.files.length) { showError('這裡接收文字。請選取一句話，再拖進來。'); return; }
  ask(event.dataTransfer.getData('text/plain'));
});
// Prevent dropped links/files outside the target from navigating away.
window.addEventListener('dragover', event => event.preventDefault());
window.addEventListener('drop', event => { event.preventDefault(); resetDrag(); });
window.addEventListener('dragend', resetDrag);
zone.addEventListener('click', openPaste);
$('paste-trigger').addEventListener('click', openPaste);
$('paste-cancel').addEventListener('click', () => { $('paste-form').hidden = true; zone.focus(); });
$('paste-form').addEventListener('submit', event => { event.preventDefault(); ask($('paste-input').value); });
$('paste-input').addEventListener('keydown', event => {
  if (event.key === 'Enter' && (event.metaKey || event.ctrlKey)) { event.preventDefault(); ask(event.target.value); }
});
window.addEventListener('paste', event => {
  if (event.target.matches('textarea,input,[contenteditable="true"]') || $('about-dialog').open) return;
  const value = event.clipboardData?.getData('text/plain');
  if (value) { event.preventDefault(); ask(value); }
});

for (const item of examples) {
  const button = document.createElement('button');
  button.className = 'sample'; button.draggable = true; button.textContent = item.text;
  button.setAttribute('aria-label', `試問 ${item.text}；也可以拖入空格`);
  button.addEventListener('dragstart', event => {
    event.dataTransfer.setData('text/plain', item.text); event.dataTransfer.effectAllowed = 'copy'; button.classList.add('is-dragging');
  });
  button.addEventListener('dragend', () => button.classList.remove('is-dragging'));
  button.addEventListener('click', () => ask(item.text));
  $('sample-list').append(button);
}

$('reset').addEventListener('click', () => {
  ++generation; clearTimeout(timer); clearTimeout(saveTimer); original = ''; reply = null;
  $('answer-wrap').hidden = true; $('answer').dataset.open = 'false'; $('loading').hidden = true;
  $('paste-form').hidden = true; $('error').hidden = true;
  zone.classList.remove('filled'); $('question').classList.remove('has-text');
  $('drop-label').textContent = ''; $('drop-prompt').textContent = 'drop it here';
  zone.setAttribute('aria-label', '放入想問的文字；點一下也可以貼上');
  document.body.classList.remove('answered'); zone.focus(); $('live').textContent = '空格準備好了，再放一句進來。';
});
$('save').addEventListener('click', () => {
  if (!reply) return;
  const blob = new Blob([markdown(original, reply)], { type: 'text/markdown;charset=utf-8' });
  const url = URL.createObjectURL(blob), link = document.createElement('a');
  const date = new Date();
  const day = [date.getFullYear(), String(date.getMonth() + 1).padStart(2, '0'), String(date.getDate()).padStart(2, '0')].join('-');
  link.href = url; link.download = `wdym-${reply.id}-${day}.md`;
  document.body.append(link); link.click(); link.remove();
  setTimeout(() => URL.revokeObjectURL(url), 1000);
  $('save-label').textContent = '已下載 ✓'; $('live').textContent = '已下載 Markdown，包含原文與示範解釋。';
  clearTimeout(saveTimer); saveTimer = setTimeout(() => { $('save-label').textContent = 'Keep as .md'; }, 2200);
});
$('about').addEventListener('click', () => $('about-dialog').showModal());
$('about-close').addEventListener('click', () => $('about-dialog').close());
$('about-dialog').addEventListener('click', event => { if (event.target === $('about-dialog')) {
  const rect = event.target.getBoundingClientRect();
  if (event.clientX < rect.left || event.clientX > rect.right || event.clientY < rect.top || event.clientY > rect.bottom) event.target.close();
}});

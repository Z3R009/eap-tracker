(function () {
  'use strict';
  const $ = s => document.querySelector(s);
  const esc = s => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({'&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'}[c]));
  const num = n => Number(n).toLocaleString('en-US', {maximumFractionDigits: 2});
  const dateFmt = iso => new Date(iso + 'T00:00:00').toLocaleDateString('en-US', {month: 'short', day: 'numeric', year: 'numeric'});
  const STATUS = {not_enrolled: 'Not enrolled', scholarship: 'On scholarship program', transferred: 'Transferred'};
  let timer = null;
  let seq = 0;

  async function call(url, body) {
    const opt = body ? {method: 'POST', headers: {'Content-Type': 'application/json', 'X-CSRF': window.PUB.csrf}, body: JSON.stringify(body)} : {};
    const r = await fetch(url, opt);
    let j;
    const text = await r.text();
    try { j = JSON.parse(text); } catch (e) {
      console.error('view_api.php replied with:', text.slice(0, 500));
      j = {error: 'The server sent an unexpected reply (HTTP ' + r.status + ').'};
    }
    if (j.need_code) { showLock(); }
    if (!r.ok || j.error) { throw new Error(j.error || 'Something went wrong.'); }
    return j;
  }

  function showLock() {
    $('#lock').hidden = false;
    $('#finder').hidden = true;
    $('#record').hidden = true;
  }

  function cell(c) {
    switch (c.state) {
      case 'paid':
               return '<td class="c p m-' + esc(c.mode) + '" data-d="' + esc(c.date) + '" style="--h:' + esc(c.color) + '" title="Paid ' + esc(dateFmt(c.date)) + '">Paid</td>';
      case 'exempt': return '<td class="c x" title="Exempt">Exempt</td>';
      case 'direct': return '<td class="c x" title="Paid directly">Direct</td>';
      case 'care_of': return '<td class="c x" title="Paid care of another office">c/o</td>';
      case 'own': return '<td class="c e own" title="This one is for you">For you</td>';
      case 'due': return '<td class="c e due" title="Not paid yet"></td>';
      default: return '<td class="c e"></td>';
    }
  }

  function fundBlock(f) {
        const head = '<thead><tr>' + f.cells.map(c => '<th>' + esc(c.label) + '</th>').join('') + '</tr></thead>';
    const body = '<tbody><tr>' + f.cells.map(cell).join('') + '</tr></tbody>';
    const chips = f.legend.map(l => '<button type="button" class="chip" data-d="' + esc(l.date) + '"><span class="swatch on" style="--h:' + esc(l.color) + '"></span>' + esc(dateFmt(l.date)) + '</button>').join('');
    return '<section class="fundblock"><h2>' + esc(f.name) + '</h2>' +
      '<div class="gridwrap pubwrap"><table class="grid pubgrid">' + head + body + '</table></div>' +
      (chips ? '<div class="chips" aria-label="Collection dates">' + chips + '</div>' : '') + '</section>';
  }

  function showRecord(d) {
    const e = d.employee;
    let h = '<div class="recordhead"><h2>' + esc(e.name) + '</h2>' + (e.division ? '<span class="muted">' + esc(e.division) + '</span>' : '') + '</div>';
    if (STATUS[e.status]) h += '<p class="muted" style="margin:0">' + esc(STATUS[e.status]) + '</p>';
    h += '<p class="keyline"><span>Colored box: paid, the color is the collection date</span><span>Dashed box: not paid yet</span><span>Gray box: exempt or paid another way</span><span>FT: fund transfer</span></p>';
    h += d.funds.length ? d.funds.map(fundBlock).join('') : '<p class="muted">There is nothing to show for you yet.</p>';
    h += '<p class="pubfoot">' + (d.updated ? 'Records updated ' + esc(dateFmt(d.updated)) + '. ' : '') + '<button type="button" class="link" id="again">Search for another name</button></p>';
    $('#record').innerHTML = h;
    $('#record').hidden = false;
    $('#finder').hidden = true;
    const again = $('#again');
    if (again) again.addEventListener('click', () => {
      $('#record').hidden = true;
      $('#finder').hidden = false;
      $('#q').value = '';
      $('#results').hidden = true;
      $('#q').focus();
    });
    document.querySelectorAll('.fundblock').forEach(b => {
      b.addEventListener('click', ev => {
        const chip = ev.target.closest('.chip');
        if (!chip) return;
        const on = !chip.classList.contains('on');
        b.querySelectorAll('.chip').forEach(c => c.classList.toggle('on', on && c === chip));
        b.querySelectorAll('td.p').forEach(td => td.classList.toggle('dim', on && td.dataset.d !== chip.dataset.d));
      });
    });
    window.scrollTo({top: 0});
  }

  async function open(id) {
    $('#findErr').textContent = '';
    try { showRecord(await call('view_api.php?action=record&id=' + id)); }
    catch (err) { $('#findErr').textContent = err.message; }
  }

  async function search() {
    const q = $('#q').value.trim();
    const box = $('#results');
    const mine = ++seq;
    $('#findErr').textContent = '';
    if (q.length < 2) { box.hidden = true; return; }
    try {
      const d = await call('view_api.php?action=search&q=' + encodeURIComponent(q));
      if (mine !== seq) return;
      if (!d.results.length) {
        box.innerHTML = '<p class="empty">No one matches "' + esc(q) + '". Try your last name only.</p>';
      } else {
        box.innerHTML = d.results.map(r => '<button type="button" data-id="' + r.id + '"><span>' + esc(r.name) + '</span><span class="div">' + esc(r.division) + '</span></button>').join('') +
          (d.more ? '<p class="empty">More names match. Type a little more to narrow it down.</p>' : '');
      }
      box.hidden = false;
    } catch (err) { if (mine === seq) { box.hidden = true; $('#findErr').textContent = err.message; } }
  }

  $('#q').addEventListener('input', () => { clearTimeout(timer); timer = setTimeout(search, 250); });
  $('#q').addEventListener('keydown', ev => {
    if (ev.key === 'Enter') { const first = $('#results button'); if (first) { ev.preventDefault(); open(+first.dataset.id); } }
  });
  $('#results').addEventListener('click', ev => {
    const b = ev.target.closest('button[data-id]');
    if (b) open(+b.dataset.id);
  });

  $('#lockForm').addEventListener('submit', async ev => {
    ev.preventDefault();
    $('#lockErr').textContent = '';
    try {
      await call('view_api.php?action=unlock', {code: ev.target.elements.code.value});
      $('#lock').hidden = true;
      $('#finder').hidden = false;
      $('#q').focus();
    } catch (err) { $('#lockErr').textContent = err.message; }
  });
})();
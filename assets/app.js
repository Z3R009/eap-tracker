(function () {
  "use strict";
  const E = window.EAP;
  const $ = (s, r) => (r || document).querySelector(s);
  const MODE = {
    cash: "Cash",
    fund_transfer: "Fund transfer",
    direct: "Paid directly",
    care_of: "Care of another office",
    exempt: "Exempt",
  };
  const STATUS = { open: "Open", partial: "Partial", remitted: "Remitted" };
  const EMP_STATUS = {
    not_enrolled: "not enrolled",
    scholarship: "scholarship",
    transferred: "transferred",
  };
  let S = null;
  let pays = new Map();
  let colById = new Map();
  let ctx = null;
  let pinned = 0;
  let lpTimer = null;
  let lpFired = false;

  const esc = (s) =>
    String(s == null ? "" : s).replace(
      /[&<>"']/g,
      (c) =>
        ({
          "&": "&amp;",
          "<": "&lt;",
          ">": "&gt;",
          '"': "&quot;",
          "'": "&#39;",
        })[c],
    );
  const num = (n) =>
    Number(n).toLocaleString("en-US", { maximumFractionDigits: 2 });
  const peso = (n) => "\u20B1" + num(n);
  const dateFmt = (iso) =>
    new Date(iso + "T00:00:00").toLocaleDateString("en-US", {
      month: "short",
      day: "numeric",
      year: "numeric",
    });

  let toastTimer;
  function toast(msg, bad) {
    const t = $("#toast");
    t.textContent = msg;
    t.className = "show" + (bad ? " bad" : "");
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => {
      t.className = "";
    }, 3200);
  }

  async function api(action, body) {
    const opt =
      body === undefined
        ? {}
        : {
            method: "POST",
            headers: { "Content-Type": "application/json", "X-CSRF": E.csrf },
            body: JSON.stringify(body),
          };
    const r = await fetch("api.php?action=" + action + "&fund=" + E.fund, opt);
    let j;
    try {
      j = await r.json();
    } catch (e) {
      j = { error: "The server sent an unexpected reply." };
    }
    if (r.status === 401) {
      location.href = "login.php";
    }
    if (!r.ok || j.error) {
      throw new Error(j.error || "Request failed.");
    }
    return j;
  }

  async function refresh() {
    S = await api("state");
    index();
    render();
  }

  function index() {
    pays = new Map(
      S.payments.map((p) => [p.employee_id + ":" + p.period_id, p]),
    );
    colById = new Map(S.collections.map((c) => [c.id, c]));
  }

  function render() {
    renderSummary();
    renderActive();
    renderGrid();
    renderLegend();
    applySearch();
    focusCol(pinned);
    $("#hint").textContent = S.employees.length
      ? "Dashed cells are due and still unpaid. Hold a cell (or Shift-click) to open the full form. Tap or hover a collection below to highlight its cells."
      : "No employees yet. Use Add employee to start.";
  }

  function renderSummary() {
    const c = S.collections.reduce((a, x) => a + x.collected, 0);
    const r = S.collections.reduce((a, x) => a + x.remitted, 0);
    const left = Math.max(c - r, 0);
    const card = (label, v, cls) =>
      '<div class="card ' +
      (cls || "") +
      '"><span>' +
      label +
      "</span><b>" +
      peso(v) +
      "</b></div>";
    $("#summary").innerHTML =
      card("Collected", c) +
      card("Remitted", r) +
      card("Awaiting remittance", left, left > 0 ? "hot" : "");
  }

  function renderActive() {
    const sel = $("#activeCol");
    const open = S.collections
      .filter((c) => !c.locked)
      .slice()
      .reverse();
    sel.innerHTML =
      '<option value="0">Not recording</option>' +
      open
        .map(
          (c) =>
            '<option value="' +
            c.id +
            '">' +
            esc(dateFmt(c.collected_on)) +
            (c.note ? " - " + esc(c.note) : "") +
            "</option>",
        )
        .join("");
    sel.value = String(S.active || 0);
    const col = colById.get(S.active);
    const sw = $("#activeSwatch");
    sw.style.background = col ? col.color : "transparent";
    sw.classList.toggle("on", !!col);
  }

  function owes(e, p) {
    if (e.status !== "enrolled") return false;
    if (p.beneficiary_id === e.id) return false;
    if (p.due_on && p.due_on > S.today) return false;
    if (e.start_on && p.due_on && p.due_on.slice(0, 7) < e.start_on.slice(0, 7))
      return false;
    return true;
  }

  function renderGrid() {
    const P = S.periods;
    const span = P.length + 2;
    let h =
      '<thead><tr><th class="name">Employee</th>' +
      P.map(
        (p) =>
          '<th class="ph" data-p="' +
          p.id +
          '" title="' +
          esc(
            (p.due_on ? "Due " + dateFmt(p.due_on) + ". " : "") +
              "Click to edit this column",
          ) +
          '">' +
          esc(p.label) +
          "</th>",
      ).join("") +
      '<th class="tot">Total</th></tr></thead><tbody>';
    let lastDiv = null;
    for (const e of S.employees) {
      if (e.division !== lastDiv) {
        lastDiv = e.division;
        h +=
          '<tr class="grp"><td colspan="' +
          span +
          '">' +
          esc(e.division || "No division") +
          "</td></tr>";
      }
      let total = 0;
      let cells = "";
      for (const p of P) {
        const pay = pays.get(e.id + ":" + p.id);
        const at = 'data-e="' + e.id + '" data-p="' + p.id + '"';
        if (pay && pay.collection_id) {
          const col = colById.get(pay.collection_id);
          total += pay.amount;
          const tip =
            (col ? dateFmt(col.collected_on) : "") +
            ", " +
            MODE[pay.mode] +
            (pay.note ? ", " + pay.note : "");
          cells +=
            '<td class="c p m-' +
            pay.mode +
            '" ' +
            at +
            ' data-c="' +
            pay.collection_id +
            '" style="--h:' +
            (col ? col.color : "#888") +
            '" title="' +
            esc(tip) +
            '">' +
            num(pay.amount) +
            "</td>";
        } else if (pay) {
          const tip =
            MODE[pay.mode] +
            (pay.amount ? ": " + peso(pay.amount) : "") +
            (pay.note ? ", " + pay.note : "");
          cells +=
            '<td class="c x" ' +
            at +
            ' title="' +
            esc(tip) +
            '">' +
            (pay.mode === "care_of"
              ? "c/o"
              : pay.mode === "exempt"
                ? "Exempt"
                : "Direct") +
            "</td>";
        } else if (p.beneficiary_id === e.id) {
          cells +=
            '<td class="c e own" ' +
            at +
            ' title="This column is for them">For them</td>';
        } else {
          cells +=
            '<td class="c e' +
            (owes(e, p) ? " due" : "") +
            '" ' +
            at +
            "></td>";
        }
      }
      const tag = EMP_STATUS[e.status]
        ? '<span class="tag" title="' +
          esc(e.remarks || "") +
          '">' +
          EMP_STATUS[e.status] +
          "</span>"
        : "";
      h +=
        '<tr data-name="' +
        esc(e.name.toLowerCase()) +
        '"><td class="name"><span class="nm">' +
        esc(e.name) +
        "</span>" +
        tag +
        "</td>" +
        cells +
        '<td class="tot">' +
        (total ? num(total) : "") +
        "</td></tr>";
    }
    const colTot = {},
      actTot = {},
      owe = {};
    P.forEach((p) => {
      colTot[p.id] = 0;
      actTot[p.id] = 0;
      owe[p.id] = 0;
    });
    for (const e of S.employees) {
      for (const p of P) {
        const pay = pays.get(e.id + ":" + p.id);
        if (pay && pay.collection_id) {
          colTot[p.id] += pay.amount;
          if (pay.collection_id === S.active) actTot[p.id] += pay.amount;
        } else if (!pay && owes(e, p)) {
          owe[p.id] += S.default_amount;
        }
      }
    }
    const sum = (o) => P.reduce((a, p) => a + o[p.id], 0);
    const frow = (cls, label, o, tip, style) =>
      '<tr class="' +
      cls +
      '"' +
      (style ? ' style="' + style + '"' : "") +
      '><td class="fs name" title="' +
      esc(tip) +
      '">' +
      esc(label) +
      "</td>" +
      P.map(
        (p) =>
          '<td class="fs' +
          (o[p.id] ? "" : " zero") +
          '">' +
          (o[p.id] ? num(o[p.id]) : "-") +
          "</td>",
      ).join("") +
      '<td class="fs ftot">' +
      (sum(o) ? num(sum(o)) : "-") +
      "</td></tr>";
    const act = colById.get(S.active);
    let foot =
      "<tfoot>" +
      frow(
        "f-col",
        "Collected so far",
        colTot,
        "Everything collected in this tab, per column",
      );
    if (act) {
      const d = new Date(act.collected_on + "T00:00:00").toLocaleDateString(
        "en-US",
        { month: "short", day: "numeric" },
      );
      foot += frow(
        "f-rem",
        "To remit, " + d,
        actTot,
        "What was collected in the collection you are recording into (" +
          dateFmt(act.collected_on) +
          "), per column",
        "--h:" + act.color,
      );
    }
    foot +=
      frow(
        "f-left",
        "Still to collect",
        owe,
        "Dashed cells in each column, counted at " +
          peso(S.default_amount) +
          " each",
      ) + "</tfoot>";
    $("#grid").innerHTML = h + "</tbody>" + foot;
  }

  function renderLegend() {
    const rows = S.collections.slice().reverse();
    if (!rows.length) {
      $("#legend").innerHTML =
        '<p class="empty">No collections yet. Press Collect today when you start receiving payments.</p>';
      return;
    }
    $("#legend").innerHTML = rows
      .map((c) => {
        let badge =
          '<span class="badge ' +
          c.status +
          '">' +
          STATUS[c.status] +
          "</span>";
        let sub = "";
        if (c.status === "partial")
          sub = peso(c.remitted) + " of " + peso(c.collected) + " remitted";
        else if (c.status === "open")
          sub = c.entries
            ? "Open for " + c.age_days + " day" + (c.age_days === 1 ? "" : "s")
            : "No payments yet";
        const late =
          c.status !== "remitted" && c.age_days > 30 && c.entries
            ? " late"
            : "";
        const del =
          !c.entries && !c.remitted
            ? '<button class="link" data-del="' + c.id + '">Delete</button>'
            : "";
        const rem =
          !c.locked && c.collected - c.remitted > 0
            ? '<button data-remit="' + c.id + '">Remit</button>'
            : "";
        return (
          '<div class="lrow' +
          late +
          (c.id === pinned ? " pinned" : "") +
          '" data-id="' +
          c.id +
          '" style="--h:' +
          c.color +
          '">' +
          '<span class="swatch on"></span>' +
          '<a class="ldate" href="collection.php?id=' +
          c.id +
          '">' +
          esc(dateFmt(c.collected_on)) +
          "</a>" +
          '<span class="lamt">' +
          peso(c.collected) +
          "</span>" +
          '<span class="lstat">' +
          badge +
          "<small>" +
          esc(sub) +
          "</small></span>" +
          '<span class="lact">' +
          rem +
          del +
          "</span></div>"
        );
      })
      .join("");
  }

  function applySearch() {
    const q = $("#search").value.trim().toLowerCase();
    const rows = $("#grid tbody").children;
    let visible = 0;
    for (let i = rows.length - 1; i >= 0; i--) {
      const tr = rows[i];
      if (tr.classList.contains("grp")) {
        tr.hidden = visible === 0;
        visible = 0;
      } else {
        const show = !q || tr.dataset.name.indexOf(q) !== -1;
        tr.hidden = !show;
        if (show) visible++;
      }
    }
  }

  function focusCol(id) {
    document
      .querySelectorAll("#grid td.p")
      .forEach((td) =>
        td.classList.toggle("dim", !!id && +td.dataset.c !== id),
      );
  }

  async function run(fn, okMsg) {
    try {
      await fn();
      if (okMsg) toast(okMsg);
    } catch (err) {
      toast(err.message, true);
      await refresh().catch(() => {});
    }
  }

  async function quickPay(e, p) {
    S.payments.push({
      id: 0,
      employee_id: e,
      period_id: p,
      collection_id: S.active,
      amount: S.default_amount,
      mode: "cash",
      note: "",
    });
    index();
    renderGrid();
    applySearch();
    await run(async () => {
      await api("save_payment", {
        employee_id: e,
        period_id: p,
        amount: S.default_amount,
        mode: "cash",
        collection_id: S.active,
      });
      await refresh();
    });
  }

  function toggleColRow() {
    const f = $("#payForm");
    const direct = ["direct", "care_of", "exempt"].includes(
      f.elements.mode.value,
    );
    $("#amtRow").hidden = f.elements.mode.value === "exempt";
    $("#colRow").hidden = direct;
    $("#newDateRow").hidden =
      direct || f.elements.collection_id.value !== "new";
  }

  function openPay(e, p, pay) {
    const emp = S.employees.find((x) => x.id === e);
    const per = S.periods.find((x) => x.id === p);
    const f = $("#payForm");
    ctx = { e, p, pay };
    $("#payTitle").textContent = emp.name;
    $("#payMeta").textContent = per.label + (pay ? ", already recorded" : "");
    f.elements.amount.value = pay ? pay.amount : S.default_amount;
    f.elements.mode.value = pay ? pay.mode : "cash";
    f.elements.note.value = pay && pay.note ? pay.note : "";
    $("#payErr").textContent = "";
    const open = S.collections
      .filter((c) => !c.locked)
      .slice()
      .reverse();
    const cur =
      pay && pay.collection_id ? colById.get(pay.collection_id) : null;
    const list = cur && cur.locked ? [cur].concat(open) : open;
    f.elements.collection_id.innerHTML =
      list
        .map(
          (c) =>
            '<option value="' +
            c.id +
            '">' +
            esc(dateFmt(c.collected_on)) +
            (c.locked ? " (remitted)" : "") +
            "</option>",
        )
        .join("") + '<option value="new">Another date...</option>';
    f.elements.collection_id.value = String(
      cur ? cur.id : S.active || (open[0] ? open[0].id : "new"),
    );
    f.elements.new_date.value = S.today;
    f.elements.new_date.max = S.today;
    const locked = !!(cur && cur.locked);
    [...f.elements].forEach((el) => {
      if (el.name) el.disabled = locked;
    });
    $("#paySave").hidden = locked;
    $("#payDelete").hidden = !pay || locked;
    if (locked)
      $("#payErr").textContent =
        "This payment is in a remitted collection. Delete that remittance first if it needs to change.";
    toggleColRow();
    $("#payDlg").showModal();
  }

  let periodId = 0;
  function openPeriod(id) {
    const f = $("#periodForm");
    const p = id ? S.periods.find((x) => x.id === id) : null;
    periodId = id;
    f.reset();
    f.elements.beneficiary_id.innerHTML =
      '<option value="0">No one</option>' +
      S.employees
        .map((e) => '<option value="' + e.id + '">' + esc(e.name) + "</option>")
        .join("");
    f.elements.label.value = p ? p.label : "";
    f.elements.due_on.value = p && p.due_on ? p.due_on : "";
    f.elements.beneficiary_id.value = String(
      p && p.beneficiary_id ? p.beneficiary_id : 0,
    );
    $("#periodTitle").textContent = p ? "Edit column" : "Add a column";
    $("#periodSave").textContent = p ? "Save column" : "Add column";
    $("#periodErr").textContent = "";
    $("#periodDlg").showModal();
  }

  function openRemit(id) {
    const c = colById.get(id);
    const left = Math.round((c.collected - c.remitted) * 100) / 100;
    const f = $("#remitForm");
    f.dataset.id = id;
    $("#remitMeta").textContent =
      dateFmt(c.collected_on) +
      ": " +
      peso(c.collected) +
      " collected, " +
      peso(left) +
      " still to remit.";
    f.elements.remitted_on.value = S.today;
    f.elements.amount.value = left;
    f.elements.amount.max = left;
    f.elements.mode.value = "cash";
    f.elements.reference.value = "";
    $("#remitErr").textContent = "";
    $("#remitDlg").showModal();
  }

  function bind() {
    document.addEventListener("click", (ev) => {
      if (ev.target.closest("[data-close]"))
        ev.target.closest("dialog").close();
    });

    const grid = $("#grid");
    grid.addEventListener("pointerdown", (ev) => {
      const td = ev.target.closest("td.c");
      if (!td) return;
      lpFired = false;
      clearTimeout(lpTimer);
      lpTimer = setTimeout(() => {
        lpFired = true;
        if (navigator.vibrate) navigator.vibrate(12);
        const e = +td.dataset.e,
          p = +td.dataset.p;
        openPay(e, p, pays.get(e + ":" + p));
      }, 550);
    });
    ["pointerup", "pointerleave", "pointercancel", "pointermove"].forEach((t) =>
      grid.addEventListener(t, () => clearTimeout(lpTimer)),
    );
    grid.addEventListener("contextmenu", (ev) => {
      if (ev.target.closest("td.c")) ev.preventDefault();
    });

    $("#grid").addEventListener("click", (ev) => {
      if (lpFired) {
        lpFired = false;
        return;
      }
      const th = ev.target.closest("th.ph");
      if (th) {
        openPeriod(+th.dataset.p);
        return;
      }
      const td = ev.target.closest("td.c");
      if (!td) return;
      const e = +td.dataset.e,
        p = +td.dataset.p;
      const pay = pays.get(e + ":" + p);
      if (!pay && $("#quick").checked && S.active && !ev.shiftKey) {
        quickPay(e, p);
        return;
      }
      openPay(e, p, pay);
    });

    $("#payForm").elements.mode.addEventListener("change", toggleColRow);
    $("#payForm").elements.collection_id.addEventListener(
      "change",
      toggleColRow,
    );
    $("#payForm").addEventListener("submit", async (ev) => {
      ev.preventDefault();
      const f = ev.target;
      try {
        let colId = f.elements.collection_id.value;
        if (
          colId === "new" &&
          ["cash", "fund_transfer"].includes(f.elements.mode.value)
        ) {
          if (!f.elements.new_date.value)
            throw new Error("Pick the collection date.");
          colId = (
            await api("collect_today", { date: f.elements.new_date.value })
          ).collection_id;
        }
        await api("save_payment", {
          employee_id: ctx.e,
          period_id: ctx.p,
          amount:
            f.elements.mode.value === "exempt"
              ? 0
              : parseFloat(f.elements.amount.value || "0"),
          mode: f.elements.mode.value,
          note: f.elements.note.value,
          collection_id: +colId || 0,
        });
        $("#payDlg").close();
        await refresh();
        toast("Payment saved");
      } catch (err) {
        $("#payErr").textContent = err.message;
      }
    });
    $("#payDelete").addEventListener("click", async () => {
      if (!ctx.pay || !confirm("Delete this payment?")) return;
      try {
        await api("delete_payment", { payment_id: ctx.pay.id });
        $("#payDlg").close();
        await refresh();
        toast("Payment deleted");
      } catch (err) {
        $("#payErr").textContent = err.message;
      }
    });

    $("#btnToday").addEventListener("click", () =>
      run(async () => {
        await api("collect_today", {});
        await refresh();
      }, "Recording into today\u2019s collection"),
    );
    $("#activeCol").addEventListener("change", (ev) =>
      run(async () => {
        await api("set_active", { collection_id: +ev.target.value });
        await refresh();
      }),
    );

    $("#legend").addEventListener("mouseover", (ev) => {
      const r = ev.target.closest(".lrow");
      focusCol(r ? +r.dataset.id : pinned);
    });
    $("#legend").addEventListener("mouseleave", () => focusCol(pinned));
    $("#legend").addEventListener("click", (ev) => {
      const rem = ev.target.closest("[data-remit]");
      if (rem) {
        openRemit(+rem.dataset.remit);
        return;
      }
      const del = ev.target.closest("[data-del]");
      if (del) {
        if (confirm("Delete this empty collection?"))
          run(async () => {
            await api("delete_collection", { collection_id: +del.dataset.del });
            await refresh();
          }, "Collection deleted");
        return;
      }
      const row = ev.target.closest(".lrow");
      if (row && !ev.target.closest("a, button")) {
        pinned = pinned === +row.dataset.id ? 0 : +row.dataset.id;
        document
          .querySelectorAll(".lrow")
          .forEach((r) =>
            r.classList.toggle("pinned", +r.dataset.id === pinned),
          );
        focusCol(pinned);
      }
    });
    $("#remitForm").addEventListener("submit", async (ev) => {
      ev.preventDefault();
      const f = ev.target;
      try {
        await api("remit", {
          collection_id: +f.dataset.id,
          remitted_on: f.elements.remitted_on.value,
          amount: parseFloat(f.elements.amount.value),
          mode: f.elements.mode.value,
          reference: f.elements.reference.value,
        });
        $("#remitDlg").close();
        await refresh();
        toast("Remittance saved");
      } catch (err) {
        $("#remitErr").textContent = err.message;
      }
    });

    $("#btnAddPeriod").addEventListener("click", () => openPeriod(0));
    $("#periodForm").addEventListener("submit", async (ev) => {
      ev.preventDefault();
      const f = ev.target;
      const body = {
        label: f.elements.label.value,
        due_on: f.elements.due_on.value,
        beneficiary_id: +f.elements.beneficiary_id.value || 0,
      };
      try {
        if (periodId) {
          body.period_id = periodId;
          await api("edit_period", body);
        } else {
          await api("add_period", body);
        }
        $("#periodDlg").close();
        await refresh();
        toast(periodId ? "Column saved" : "Column added");
      } catch (err) {
        $("#periodErr").textContent = err.message;
      }
    });

    $("#btnAddEmp").addEventListener("click", () => {
      $("#empForm").reset();
      $("#empErr").textContent = "";
      $("#empDlg").showModal();
    });
    $("#empForm").addEventListener("submit", async (ev) => {
      ev.preventDefault();
      const f = ev.target;
      try {
        await api("add_employee", {
          name: f.elements.name.value,
          division: f.elements.division.value,
          status: f.elements.status.value,
          start_on: f.elements.start_on.value,
        });
        $("#empDlg").close();
        await refresh();
        toast("Employee added");
      } catch (err) {
        $("#empErr").textContent = err.message;
      }
    });

    $("#search").addEventListener("input", applySearch);
    const q = $("#quick");
    q.checked = localStorage.getItem("eap_quick") !== "0";
    q.addEventListener("change", () =>
      localStorage.setItem("eap_quick", q.checked ? "1" : "0"),
    );
  }

  bind();
  refresh().catch((err) => toast(err.message, true));
})();

#!/usr/bin/env python3
"""
Turns the EAP workbook (sheets "2026" and "2026 MANDATORY") into seed_2026.sql.

    pip install openpyxl
    python3 tools/xlsx_to_sql.py EAP_PAYMENT_TRACKER_DTI_REGION.xlsx seed_2026.sql

How the workbook is read
  - Each numeric cell becomes a payment. Its fill color decides which collection it belongs to
    (see BATCHES_2026 and BATCHES_MANDATORY below), so the batch totals can no longer drift
    from the grid.
  - Text cells in the Mandatory sheet ("Direct", "Direct (1k)", "c/o NC", "c/o SC") become
    payments of mode direct or care_of, so they no longer sit in amount cells.
  - Names that differ between the two sheets are matched with a fuzzy comparison. Review the
    "Name matches" part of the report this script prints.
Run it against an empty database only: the seed uses fixed ids.
"""
import difflib
import re
import sys
from collections import Counter, defaultdict

from openpyxl import load_workbook

SRC = sys.argv[1] if len(sys.argv) > 1 else 'EAP_PAYMENT_TRACKER_DTI_REGION.xlsx'
OUT = sys.argv[2] if len(sys.argv) > 2 else 'seed_2026.sql'

# fill color -> (collection id, collected_on, color, note)
BATCHES_2026 = {
    'FF4A86E8': (1, '2026-02-06', '#378ADD', 'Batch 1. The workbook only gives its remitted date.'),
    'FFFF00FF': (2, '2026-02-24', '#D4537E', None),
    'FF38761D': (3, '2026-04-30', '#639922', None),
    'FFFFFF00': (4, '2026-07-23', '#BA7517', None),
    'FFFF0000': (5, '2026-08-25', '#E24B4A', None),
    'FF00FF00': (6, '2026-09-10', '#1D9E75', None),
}
BATCHES_MANDATORY = {
    'FFFFFF00': (7, '2026-07-23', '#BA7517', None),
    'FFFF0000': (8, '2026-08-25', '#E24B4A', None),
    'FF00FF00': (9, '2026-09-10', '#1D9E75', None),
}
# Notes the workbook keeps beside its "Collection as of" rows.
# (collection id, date, amount or None = the whole batch, mode, reference)
REMITTANCES = [
    (1, '2026-02-06', None, 'cash', 'Imported from workbook note'),
    (2, '2026-03-19', None, 'cash', 'Imported from workbook note'),
    (3, '2026-06-11', None, 'cash', 'Imported from workbook note'),
    (4, '2026-07-23', 900, 'care_of', 'c/o nonoy collection'),
    (4, '2026-07-23', 3750, 'fund_transfer', 'FT'),
    (7, '2026-07-23', None, 'cash', 'Imported from workbook note'),
]
MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
DIVISIONS = {'MSSD', 'AFMD', 'CPD', 'IDD', 'SDD', 'JOCOS'}
ALIASES = {'Martirizar-Aquino, DAC': 'Martirizar, Dagny Athena A.'}
FT_CELLS_2026 = {'M22', 'N22', 'O22', 'H28', 'I28'}          # cells whose comment says "FT"
FT_NOTE_2026 = {'D36': 'FT Feb 11', 'E36': 'FT Feb 11', 'F36': 'FT Feb 11'}  # comment on D62: "Ma'am Ime paid FT Feb 11"


def q(v):
    if v is None:
        return 'NULL'
    if isinstance(v, (int, float)):
        return str(v)
    return "'" + str(v).replace('\\', '\\\\').replace("'", "''") + "'"


def fill(cell):
    f = cell.fill
    return f.fgColor.rgb if f and f.fill_type == 'solid' and f.fgColor.type == 'rgb' else None


def clean(name, reorder=False):
    n = re.sub(r'\s+', ' ', str(name).replace('\n', ' ')).strip().replace(' .', '.')
    n = re.sub(r'\.(?=\S)', '. ', n).strip() if reorder else n
    if reorder and ',' not in n:
        parts = n.split(' ')
        n = parts[-1] + ', ' + ' '.join(parts[:-1])
    if n.isupper():
        n = n.title()
    return n


def parts(name):
    last, _, first = name.lower().partition(',')
    last = re.sub(r'[^a-z]', '', last)
    toks = [t for t in re.split(r'[^a-z]+', first) if len(t) > 1]
    return last, toks


def score(a, b):
    la, ta = parts(a)
    lb, tb = parts(b)
    r = difflib.SequenceMatcher(None, la + ' ' + ' '.join(sorted(ta)), lb + ' ' + ' '.join(sorted(tb))).ratio()
    if la == lb and ta and tb and (set(ta) <= set(tb) or set(tb) <= set(ta)):
        r = max(r, 0.97)
    return r


wb = load_workbook(SRC)
ws1, ws2 = wb['2026'], wb['2026 MANDATORY']

employees = []      # dicts: id, name, division, status, remarks
rows1 = {}          # sheet row -> employee id
rows2 = {}
report = []

group = ''
for r in range(4, 58):
    raw = ws1.cell(r, 2).value
    if raw is None:
        continue
    txt = str(raw).strip()
    if txt.upper() in ('REGULAR EMPLOYEE', 'JOCOS'):
        group = '' if txt.upper().startswith('REGULAR') else 'JOCOS'
        continue
    emp = {'id': len(employees) + 1, 'name': clean(txt), 'division': group, 'status': 'enrolled', 'remarks': None}
    if str(ws1.cell(r, 9).value or '').upper().startswith('PROMOTED') or any(
            str(ws1.cell(r, c).value or '').upper().startswith('PROMOTED') for c in range(4, 16)):
        emp['remarks'] = 'Promoted to DTI NC'
    employees.append(emp)
    rows1[r] = emp['id']

section = ''
matched_by2 = {}
STATUS = {'enrolled': 'enrolled', 'not enrolled': 'not_enrolled', 'on scholarship program': 'scholarship'}
for r in range(4, 70):
    b, c = ws2.cell(r, 2).value, ws2.cell(r, 3).value
    if b is None:
        continue
    txt = str(b).strip()
    if c is None and txt.upper() in DIVISIONS:
        section = txt.upper()
        continue
    if c is None:
        continue
    name = ALIASES.get(txt) or clean(txt, reorder=(r >= 57))
    best, best_s = None, 0
    for e in employees:
        s = score(name, e['name'])
        if s > best_s:
            best, best_s = e, s
    status = STATUS.get(str(c).strip().lower(), 'enrolled')
    if best_s >= 0.82:
        if best['id'] in matched_by2:
            report.append(f"DUPLICATE  mandatory row {r} '{txt}' is the same person as row {matched_by2[best['id']]}; skipped")
            continue
        matched_by2[best['id']] = r
        rows2[r] = best['id']
        if r < 59:
            best['division'] = section or best['division']
        best['status'] = status
        if best_s < 1:
            report.append(f"MATCH {best_s:.2f}  '{txt}'  ->  '{best['name']}'")
    else:
        emp = {'id': len(employees) + 1, 'name': name, 'division': section if r < 59 else '', 'status': status, 'remarks': None}
        employees.append(emp)
        rows2[r] = emp['id']
        report.append(f"NEW        '{txt}'  ->  '{name}' (only in the Mandatory sheet)")

sql = ['-- Generated by tools/xlsx_to_sql.py. Load into an empty database right after schema.sql.',
       'SET NAMES utf8mb4;', '']
sql.append('INSERT INTO employees (id, name, division, status, remarks) VALUES')
sql.append(',\n'.join(f"({e['id']}, {q(e['name'])}, {q(e['division'])}, {q(e['status'])}, {q(e['remarks'])})" for e in employees) + ';\n')

batches = {}
for k, v in list(BATCHES_2026.items()):
    batches[(1, k)] = v
for k, v in BATCHES_MANDATORY.items():
    batches[(2, k)] = v
sql.append('INSERT INTO collections (id, fund_id, collected_on, color, note) VALUES')
sql.append(',\n'.join(f"({v[0]}, {f}, {q(v[1])}, {q(v[2])}, {q(v[3])})" for (f, k), v in sorted(batches.items(), key=lambda x: x[1][0])) + ';\n')

cases = [str(ws2.cell(2, c).value).strip().title() for c in range(4, 10)]
sql.append('INSERT IGNORE INTO periods (fund_id, label, due_on, sort_no) VALUES')
sql.append(',\n'.join(f"(2, {q(l)}, NULL, {i + 1})" for i, l in enumerate(cases)) + ';\n')

pay = []
totals = defaultdict(float)
problems = []


def add(fund, emp_id, label, coll, amount, mode, note):
    sub = f"(SELECT id FROM periods WHERE fund_id = {fund} AND label = {q(label)})"
    pay.append(f"({emp_id}, {sub}, {q(coll)}, {amount}, {q(mode)}, {q(note)})")
    if coll:
        totals[coll] += amount


for r, eid in rows1.items():
    for i, m in enumerate(MONTHS):
        cell = ws1.cell(r, 4 + i)
        if not isinstance(cell.value, (int, float)):
            continue
        b = BATCHES_2026.get(fill(cell))
        if not b:
            problems.append(f"2026!{cell.coordinate} has an amount but no collection color; skipped")
            continue
        mode = 'fund_transfer' if cell.coordinate in FT_CELLS_2026 or cell.coordinate in FT_NOTE_2026 else 'cash'
        add(1, eid, m, b[0], cell.value, mode, FT_NOTE_2026.get(cell.coordinate))

for r, eid in rows2.items():
    for i, label in enumerate(cases):
        cell = ws2.cell(r, 4 + i)
        v = cell.value
        if v is None:
            continue
        if isinstance(v, (int, float)):
            b = BATCHES_MANDATORY.get(fill(cell))
            if not b:
                problems.append(f"MANDATORY!{cell.coordinate} has an amount but no collection color; skipped")
                continue
            add(2, eid, label, b[0], v, 'cash', None)
        else:
            t = str(v).strip()
            if t.lower().startswith('direct'):
                add(2, eid, label, None, 1000 if '1k' in t.lower() else 0, 'direct', t)
            elif t.lower().startswith('c/o'):
                add(2, eid, label, None, 0, 'care_of', 'c/o ' + t[4:].strip().upper())
            else:
                problems.append(f"MANDATORY!{cell.coordinate} has unknown text '{t}'; skipped")

sql.append('INSERT INTO payments (employee_id, period_id, collection_id, amount, mode, note) VALUES')
sql.append(',\n'.join(pay) + ';\n')

rem = []
for cid, date, amount, mode, ref in REMITTANCES:
    amt = amount if amount is not None else totals[cid]
    rem.append(f"({cid}, {q(date)}, {amt}, {q(mode)}, {q(ref)})")
sql.append('INSERT INTO remittances (collection_id, remitted_on, amount, mode, reference) VALUES')
sql.append(',\n'.join(rem) + ';\n')

open(OUT, 'w', encoding='utf-8').write('\n'.join(sql))

print(f'{len(employees)} employees, {len(pay)} payments written to {OUT}')
print('\nCollected per collection id:', {k: totals[k] for k in sorted(totals)})
print('\nName matches to review:')
print('\n'.join(report) or '  none')
if problems:
    print('\nProblems:')
    print('\n'.join(problems))

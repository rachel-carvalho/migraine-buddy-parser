{ start, it, finish } = require '../support/support'
fs = require 'fs'
assert = require 'assert'

MigraineQC = require '../../lib/migraine-qc'
Entry = require '../../lib/entry'

first_entry_html = fs.readFileSync('specs/fixtures/first-entry.html').toString()
first_entry = new Entry(first_entry_html)
second_entry = new Entry(first_entry_html.replace('12/10/18 21:06', '12/5/18 12:15'))
third_entry = new Entry(first_entry_html.replace('12/10/18', '12/20/18').replace('06h 00m', '30h 00m'))
entries = [first_entry, second_entry, third_entry]

start()

it 'saves entries', ->
  subject = new MigraineQC.Month(entries)
  assert.equal subject.entries, entries

it 'extracts month identifier from entry', ->
  subject = MigraineQC.Month.identify_month(first_entry)
  assert.equal subject, '2018-12'

it 'has an identifier', ->
  subject = new MigraineQC.Month(entries)
  assert.equal subject.identifier, '2018-12'

it 'has title', ->
  subject = new MigraineQC.Month(entries)
  assert.equal subject.title, 'Dec 2018'

it 'has days', ->
  subject = new MigraineQC.Month(entries)
  assert.equal subject.days.length, 31
  assert.ok subject.days.every((day) -> day instanceof MigraineQC.Day), 'instance of Day'

  dates_with_entries =
    10: first_entry
    11: first_entry
    5: second_entry
    20: third_entry
    21: third_entry
    22: third_entry

  subject.days.forEach (day, index) ->
    entry = dates_with_entries[index + 1]
    length = if entry then 1 else 0
    assert.equal day.number(), index + 1, "day #{day.number()} should be #{index + 1}"
    assert.equal day.entries.length, length, "day #{day.number()} should have #{length} items instead of #{day.entries.length}"
    assert.equal day.entries[0], entry, "day #{day.number()}'s entry should be #{entry}"

finish()

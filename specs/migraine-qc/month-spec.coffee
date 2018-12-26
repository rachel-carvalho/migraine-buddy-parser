{ start, it, finish } = require '../support/support'
fs = require 'fs'
assert = require 'assert'

MigraineQC = require '../../lib/migraine-qc'
Entry = require '../../lib/entry'

first_entry_html = fs.readFileSync('specs/fixtures/first-entry.html').toString()
first_entry = new Entry(first_entry_html)
second_entry = new Entry(first_entry_html.replace('12/10/18', '12/5/18'))
entries = [first_entry, second_entry]

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

it 'has days', ->
  subject = new MigraineQC.Month(entries)
  assert.equal subject.days.length, 31
  assert.ok subject.days.every((day) -> day instanceof MigraineQC.Day), 'instance of Day'

  assert.equal subject.days[9].number(), 10
  assert.equal subject.days[9].entries.length, 1
  assert.equal subject.days[9].entries[0], first_entry

  assert.equal subject.days[4].number(), 5
  assert.equal subject.days[4].entries.length, 1
  assert.equal subject.days[4].entries[0], second_entry

  assert.equal subject.days[30].number(), 31
  assert.equal subject.days[30].entries.length, 0

finish()

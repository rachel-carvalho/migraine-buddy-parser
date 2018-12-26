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

finish()

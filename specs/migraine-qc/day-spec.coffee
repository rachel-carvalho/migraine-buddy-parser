{ start, it, finish } = require '../support/support'
fs = require 'fs'
assert = require 'assert'

MigraineQC = require '../../lib/migraine-qc'
Entry = require '../../lib/entry'

first_entry_html = fs.readFileSync('specs/fixtures/first-entry.html').toString()
first_entry = new Entry(first_entry_html)

date = new Date(2018, 11, 10)
entries = [first_entry]

start()

it 'has a date', ->
  subject = new MigraineQC.Day({date, entries})
  assert.equal subject.date, date

it 'saves entries', ->
  subject = new MigraineQC.Day({date, entries})
  assert.equal subject.entries, entries

it 'has a day number', ->
  subject = new MigraineQC.Day({date, entries})
  assert.equal subject.number(), 10

finish()

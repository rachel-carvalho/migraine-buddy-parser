{ start, it, finish } = require './support/support'
fs = require 'fs'
assert = require 'assert'

Report = require '../lib/report'
Entry = require '../lib/entry'

report_html = fs.readFileSync('input/report.html').toString()
first_entry = fs.readFileSync('specs/fixtures/first-entry.html').toString()

start()

it 'stores report html', ->
  subject = new Report('this is the html')
  assert.equal subject.html, 'this is the html'

it 'has entries', ->
  subject = new Report(report_html)
  assert.ok(subject.entries instanceof Array, 'is array')
  assert.ok(subject.entries[0] instanceof Entry, 'first is an entry')
  assert.equal(subject.entries[0]?.html, first_entry, 'passed entry html to entry')
  assert.equal(subject.entries.length, 185, 'parsed all entries')

it 'removes html and document from toJSON', ->
  subject = new Report('crazy html').toJSON()
  assert.ok(!subject.html?, 'remove html')
  assert.ok(!subject.document?, 'remove document')

finish()

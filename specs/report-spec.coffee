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
  assert.equal(subject.entries.length, 195, 'parsed all entries')

it 'only leaves entries in toJSON', ->
  subject = new Report('crazy html').toJSON()
  assert.equal(Object.keys(subject).length, 1)
  assert.equal(Object.keys(subject)[0], 'entries')

finish()

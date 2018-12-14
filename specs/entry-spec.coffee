{ start, it, finish } = require './support/support'
fs = require 'fs'
assert = require 'assert'

Entry = require '../lib/entry'
Medication = require '../lib/medication'

first_entry_html = fs.readFileSync('specs/fixtures/first-entry.html').toString()
first_entry = -> new Entry(first_entry_html)

start()

it 'stores entry html', ->
  subject = first_entry()
  assert.equal subject.html, first_entry_html

it 'parses pain level', ->
  subject = first_entry()
  assert.equal subject.pain_level, 5

it 'parses aura', ->
  subject = first_entry()
  assert.equal subject.aura, false

it 'parses menstruation', ->
  subject = first_entry()
  assert.equal subject.menstruation, true

it 'parses notes', ->
  subject = first_entry()
  assert.equal subject.notes, 'Dec 11, 2018 at 01:45: I took this drug:  sumatriptan'

it 'parses medication', ->
  subject = first_entry()
  assert.ok subject.medication instanceof Array, 'is array'
  assert.ok subject.medication[0] instanceof Medication, 'right type'
  assert.equal subject.medication[1].name, 'Sumatriptan'

finish()

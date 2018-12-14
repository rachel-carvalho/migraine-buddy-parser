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
  assert.equal subject.medication.length, 2, 'array of 2'
  assert.ok subject.medication[0] instanceof Medication, 'right type'
  assert.equal subject.medication[1].name, 'Sumatriptan'

it 'parses triggers', ->
  subject = first_entry()
  assert.equal subject.triggers.length, 1, 'array of 1'
  assert.equal subject.triggers[0], 'Alcohol'

it 'parses started_at', ->
  subject = first_entry()
  assert.equal subject.started_at.toJSON(), new Date(2018, 11, 10, 21, 6).toJSON()

it 'parses duration', ->
  subject = first_entry()
  assert.equal subject.duration, '06h 00m'

finish()

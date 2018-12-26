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

it 'has a pain level from 1 to 3', ->
  subject = new MigraineQC.Day({date, entries})
  assert.equal subject.pain(), 2

it 'has aura', ->
  subject = new MigraineQC.Day({date, entries})
  assert.equal subject.aura(), false

it 'has menstruation', ->
  subject = new MigraineQC.Day({date, entries})
  assert.equal subject.menstruation(), true

it 'has trigger', ->
  subject = new MigraineQC.Day({date, entries})
  assert.equal subject.trigger(), 'Alcohol'

it 'has medications', ->
  subject = new MigraineQC.Day({date, entries})
  assert.equal subject.medications().length, 2
  assert.equal subject.medications()[0], 'Naproxen sodium 550mg Oral'
  assert.equal subject.medications()[1], 'Sumatriptan'

it 'has effectiveness', ->
  subject = new MigraineQC.Day({date, entries})
  assert.equal subject.effective(), true

# Entry#pain_level 10 == Day#pain 3
# Day#trigger is only one
# Day#medication is max 3

# multiple entries:
# pain level is max between entries
# trigger and medications are sum of entries

finish()

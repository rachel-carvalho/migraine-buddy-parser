{ start, it, finish } = require '../support/support'
fs = require 'fs'
assert = require 'assert'

MigraineQC = require '../../lib/migraine-qc'
Medication = require '../../lib/medication'
Entry = require '../../lib/entry'

first_entry_html = fs.readFileSync('specs/fixtures/first-entry.html').toString()
first_entry = new Entry(first_entry_html.replace('21:06', '10:06'))
second_entry = new Entry(first_entry_html.replace('"> 5 </td>', '"> 7 </td>'))

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

it 'sets pain to 3 when entry has 10', ->
  first_entry.pain_level = 10
  subject = new MigraineQC.Day({date, entries})
  assert.equal subject.pain(), 3

it 'uses first trigger only', ->
  first_entry.triggers = ['one', 'two']
  subject = new MigraineQC.Day({date, entries})
  assert.equal subject.trigger(), 'one'

it 'shows first 3 medications', ->
  first_entry.medication.push new Medication(name: 'Advil')
  first_entry.medication.push new Medication(name: 'Tylenol')
  subject = new MigraineQC.Day({date, entries})
  assert.equal subject.medications().length, 3
  assert.equal subject.medications()[0], 'Naproxen sodium 550mg Oral'
  assert.equal subject.medications()[1], 'Sumatriptan'
  assert.equal subject.medications()[2], 'Advil'

it 'uses max pain level between entries', ->
  first_entry.pain_level = 5
  entries = [first_entry, second_entry]
  subject = new MigraineQC.Day({date, entries})
  assert.equal subject.pain(), 3

it 'joins triggers', ->
  first_entry.triggers = []
  second_entry.triggers = ['second']
  subject = new MigraineQC.Day({date, entries})
  assert.equal subject.trigger(), 'second'

it 'joins auras', ->
  first_entry.aura = false
  second_entry.aura = true
  subject = new MigraineQC.Day({date, entries})
  assert.equal subject.aura(), true

it 'joins menstruations', ->
  first_entry.menstruation = false
  second_entry.menstruation = true
  subject = new MigraineQC.Day({date, entries})
  assert.equal subject.menstruation(), true

it 'joins medications', ->
  first_entry.medication.pop()
  first_entry.medication.pop()
  second_entry.medication = [new Medication(name: 'Novalgin'), new Medication(name: 'Tylenol')]
  subject = new MigraineQC.Day({date, entries})
  assert.equal subject.medications().length, 3
  assert.equal subject.medications()[0], 'Naproxen sodium 550mg Oral'
  assert.equal subject.medications()[1], 'Sumatriptan'
  assert.equal subject.medications()[2], 'Novalgin'

finish()
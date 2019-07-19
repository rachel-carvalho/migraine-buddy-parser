{ start, it, finish } = require '../support/support'
fs = require 'fs'
assert = require 'assert'
{DateTime} = require 'luxon'

MigraineQC = require '../../lib/migraine-qc'
Medication = require '../../lib/medication'
Entry = require '../../lib/entry'

first_entry_html = fs.readFileSync('specs/fixtures/first-entry.html').toString()
first_entry = new Entry(first_entry_html.replace('21:06', '10:06'))
second_entry = new Entry(first_entry_html.replace('"> 5 </td>', '"> 7 </td>'))

date = DateTime.local(2018, 12, 10)
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
  assert.equal subject.medications()[0], 'Sumatriptan'
  assert.equal subject.medications()[1], 'Naproxen sodium 550mg Oral'

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
  assert.equal subject.medications()[0], 'Sumatriptan'
  assert.equal subject.medications()[1], 'Naproxen sodium 550mg Oral'
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
  medications = subject.medications().sort()
  assert.equal medications[0], 'Naproxen sodium 550mg Oral'
  assert.equal medications[1], 'Novalgin'
  assert.equal medications[2], 'Sumatriptan'

it 'returns undefined for all methods when there are no entries', ->
  subject = new MigraineQC.Day({date, entries: []})
  assert.equal subject.pain(), undefined, 'pain'
  assert.equal subject.aura(), undefined, 'aura'
  assert.equal subject.menstruation(), undefined, 'menstruation'
  assert.equal subject.trigger(), undefined, 'trigger'
  assert.equal subject.medications().length, 0, 'medications'
  assert.equal subject.effective(), undefined, 'effective'

it 'checks external menstruation data', ->
  subject = MigraineQC.Day.external_menstruation(new Date(2019, 0, 8))
  assert.equal subject, undefined

  MigraineQC.Day.menstruation_dates = JSON.parse(fs.readFileSync('input/menstruation.json'))
  subject = MigraineQC.Day.external_menstruation(new Date(2019, 0, 8))
  assert.equal subject, true

it 'uses external menstruation data', ->
  MigraineQC.Day.menstruation_dates = JSON.parse(fs.readFileSync('input/menstruation.json'))
  subject = new MigraineQC.Day(date: new Date(2019, 0, 8), entries: [])
  assert.equal subject.menstruation(), true

  first_entry.menstruation = false
  subject = new MigraineQC.Day(date: new Date(2019, 0, 8), entries: [first_entry])
  assert.equal subject.menstruation(), true

  subject = new MigraineQC.Day(date: new Date(2019, 0, 11), entries: [first_entry])
  assert.equal subject.menstruation(), false

finish()

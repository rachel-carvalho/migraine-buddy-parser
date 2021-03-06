{ start, it, finish } = require '../support/support'
fs = require 'fs'
assert = require 'assert'
{DateTime} = require 'luxon'

MigraineQC = require '../../lib/migraine-qc'
Entry = require '../../lib/entry'

first_entry_html = fs.readFileSync('specs/fixtures/first-entry.html').toString()
first_entry = new Entry(first_entry_html)
second_entry = new Entry(first_entry_html.replace('10/12/18 21:06', '05/12/18 12:15'))
third_entry = new Entry(first_entry_html.replace('10/12/18', '20/12/18').replace('06h 00m', '30h 00m'))
entries = [first_entry, second_entry, third_entry]
date = DateTime.local(2018, 12, 15)

start()

it 'saves entries', ->
  subject = new MigraineQC.Month({date, entries})
  assert.equal subject.entries, entries

it 'extracts month identifier from date', ->
  subject = MigraineQC.Month.identify_month(date)
  assert.equal subject, '2018-12'

it 'has an identifier', ->
  subject = new MigraineQC.Month({date, entries})
  assert.equal subject.identifier, '2018-12'

it 'has title', ->
  subject = new MigraineQC.Month({date, entries})
  assert.equal subject.title, 'Dec 2018'

it 'has triggers', ->
  subject = new MigraineQC.Month({date, entries})
  assert.equal subject.triggers.length, 1
  assert.equal JSON.stringify(subject.triggers), JSON.stringify(['Alcohol'])

it 'has medication', ->
  subject = new MigraineQC.Month({date, entries})
  expected = ['Naproxen sodium 550mg', 'Sumatriptan']
  expected.sort()
  assert.equal subject.medication.length, 2
  assert.equal JSON.stringify(subject.medication), JSON.stringify(expected)

it 'has days', ->
  subject = new MigraineQC.Month({date, entries})
  assert.equal subject.days.length, 31
  assert.ok subject.days.every((day) -> day instanceof MigraineQC.Day), 'instance of Day'

  dates_with_entries =
    5: second_entry
    11: first_entry
    21: third_entry
    22: third_entry

  subject.days.forEach (day, index) ->
    entry = dates_with_entries[index + 1]
    length = if entry then 1 else 0
    assert.equal day.number(), index + 1, "day #{day.number()} should be #{index + 1}"
    assert.equal day.entries.length, length, "day #{day.number()} should have #{length} items instead of #{day.entries.length}"
    assert.equal day.entries[0], entry, "day #{day.number()}'s entry should be #{entry}"

finish()

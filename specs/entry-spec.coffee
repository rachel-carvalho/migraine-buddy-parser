{ start, it, finish } = require './support/support'
fs = require 'fs'
assert = require 'assert'

Entry = require '../lib/entry'
Medication = require '../lib/medication'

first_entry_html = fs.readFileSync('specs/fixtures/first-entry.html').toString()
entry_no_idea_html = fs.readFileSync('specs/fixtures/entry_no_idea.html').toString()
entry_empty_trigger_html = fs.readFileSync('specs/fixtures/entry_empty_trigger.html').toString()
menstruation_soon_html = fs.readFileSync('specs/fixtures/entry_menstruation_soon.html').toString()
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
  assert.ok subject.medication.every((item) -> item instanceof Medication), 'right type'
  assert.ok subject.medication.some((item) -> item.name == 'Sumatriptan'), 'parsed Sumatriptan'
  assert.ok subject.medication.some((item) -> item.name.indexOf('Naproxen') > -1), 'parsed Naproxen'

it 'parses triggers', ->
  subject = first_entry()
  assert.equal subject.triggers.length, 1, 'array of 1'
  assert.equal subject.triggers[0], 'Alcohol'

it 'parses started_at', ->
  subject = first_entry()
  assert.equal subject.started_at.toUTC().toJSON(), new Date(2018, 11, 10, 21, 6).toJSON()

it 'parses duration', ->
  subject = first_entry()
  assert.equal subject.duration.hours, 6
  assert.equal subject.duration.minutes, 0
  assert.equal subject.duration.formatted, '06h 00m'

it 'calculates end', ->
  subject = first_entry()
  assert.equal subject.ended_at.toUTC().toJSON(), new Date(2018, 11, 11, 3, 6).toJSON()

it 'calculates days choosing sleep time over wake time', ->
  # from 21h to 3h
  subject = new Entry(first_entry_html)
  assert.equal subject.days.length, 1, 'keeps second day (from 21h to 3h)'
  assert.equal subject.days[0].toUTC().toJSON(), new Date(2018, 11, 11).toJSON(), 'keeps second day (from 21h to 3h)'

  # from 21h to 1h
  subject = new Entry(first_entry_html.replace('06h', '04h'))
  assert.equal subject.days.length, 1, 'keeps first day (from 21h to 1h)'
  assert.equal subject.days[0].toUTC().toJSON(), new Date(2018, 11, 10).toJSON(), 'keeps first day (from 21h to 1h)'

  # from 21h to 1h of 3rd day
  subject = new Entry(first_entry_html.replace('06h', '28h'))
  assert.equal subject.days.length, 2, 'drops 3rd day (from 21h to 1h of 3rd day)'
  assert.equal subject.days[0].toUTC().toJSON(), new Date(2018, 11, 10).toJSON(), 'drops 3rd day (from 21h to 1h of 3rd day)'
  assert.equal subject.days[1].toUTC().toJSON(), new Date(2018, 11, 11).toJSON(), 'drops 3rd day (from 21h to 1h of 3rd day)'

  # from 21h to 3h of 3rd day
  subject = new Entry(first_entry_html.replace('06h', '28h').replace('21:06', '23:06'))
  assert.equal subject.days.length, 2, 'drops 1st day (from 21h to 3h of 3rd day)'
  assert.equal subject.days[0].toUTC().toJSON(), new Date(2018, 11, 11).toJSON(), 'drops 1st day (from 21h to 3h of 3rd day)'
  assert.equal subject.days[1].toUTC().toJSON(), new Date(2018, 11, 12).toJSON(), 'drops 1st day (from 21h to 3h of 3rd day)'

it 'parses pain position', ->
  subject = first_entry()
  assert.equal subject.pain_position.left, true, 'is left'
  assert.equal subject.pain_position.right, false, 'is not right'

it 'handles trigger no idea', ->
  subject = new Entry(entry_no_idea_html)
  assert.equal subject.triggers.length, 0, 'no triggers'

it 'handles empty spaces in trigger', ->
  subject = new Entry(entry_empty_trigger_html)
  assert.equal subject.triggers.length, 1, '1 trigger'
  assert.equal subject.triggers[0], 'Sinus', 'sinus'

it 'only leaves relevant keys in toJSON', ->
  subject = new Entry(entry_no_idea_html).toJSON()

  actual = Object.keys(subject)
  expected = ['pain_level', 'aura', 'triggers', 'menstruation', 'notes', 'duration', 'medication', 'started_at', 'ended_at', 'pain_position', 'days']

  assert.equal(actual.length, 11)
  assert.ok(actual.every((value) -> expected.includes(value)))
  assert.ok(expected.every((value) -> actual.includes(value)))

it 'handles menstruation soon', ->
  subject = new Entry(menstruation_soon_html)
  assert.equal subject.triggers.length, 1
  assert.equal subject.triggers[0], 'Sinus'
  assert.equal subject.menstruation, false

finish()

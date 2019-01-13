{ start, it, finish } = require './support/support'
fs = require 'fs'
assert = require 'assert'

Entry = require '../lib/entry'
Medication = require '../lib/medication'

first_entry_html = fs.readFileSync('specs/fixtures/first-entry.html').toString()
entry_no_idea_html = fs.readFileSync('specs/fixtures/entry_no_idea.html').toString()
entry_empty_trigger_html = fs.readFileSync('specs/fixtures/entry_empty_trigger.html').toString()
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
  assert.equal subject.duration.hours, 6
  assert.equal subject.duration.minutes, 0
  assert.equal subject.duration.formatted, '06h 00m'

it 'calculates end', ->
  subject = first_entry()
  assert.equal subject.ended_at.toJSON(), new Date(2018, 11, 11, 3, 6).toJSON()

it 'calculates days', ->
  subject = first_entry()
  assert.equal subject.days.length, 2
  assert.equal subject.days[0].toJSON(), new Date(2018, 11, 10).toJSON()
  assert.equal subject.days[1].toJSON(), new Date(2018, 11, 11).toJSON()

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

finish()

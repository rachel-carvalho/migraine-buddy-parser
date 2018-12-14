{ start, it, finish } = require './support/support'
fs = require 'fs'
assert = require 'assert'
_ = require 'underscore'

Medication = require '../lib/medication'

medication_html = fs.readFileSync('specs/fixtures/medication.html').toString()
medication_mixed_html = fs.readFileSync('specs/fixtures/medication_mixed.html').toString()
medication_unsure_html = fs.readFileSync('specs/fixtures/medication_unsure.html').toString()
medication_somewhat_helpful_html = fs.readFileSync('specs/fixtures/medication_somewhat_helpful.html').toString()
medication_implicit_amount_html = fs.readFileSync('specs/fixtures/medication_implicit_amount.html').toString()
medication_none_html = fs.readFileSync('specs/fixtures/medication_none.html').toString()

start()

it 'stores amount, name and helpful', ->
  subject = new Medication(name: 'Sumatriptan', amount: 1, helpful: true)
  assert.equal(subject.name, 'Sumatriptan')
  assert.equal(subject.amount, 1)
  assert.equal(subject.helpful, true)

it 'parses html', ->
  subject = Medication.parse(medication_html)

  assert.ok(subject instanceof Array, 'is array')
  assert.equal(subject.length, 2)

  assert.ok(subject[0] instanceof Medication, 'is medication')
  assert.ok(subject[1] instanceof Medication, 'is medication')

  assert.equal(subject[0].name, 'Naproxen sodium 550mg Oral')
  assert.equal(subject[0].amount, 1)
  assert.equal(subject[0].helpful, true)

  assert.equal(subject[1].name, 'Sumatriptan')
  assert.equal(subject[1].amount, 1)
  assert.equal(subject[1].helpful, true)

it 'understands mixed helpfulnesss html', ->
  subject = Medication.parse(medication_mixed_html)
  helpful = _.any subject, (med) -> med.name == 'Naproxen sodium 550mg Oral' && med.helpful == true
  assert.ok helpful, 'parses helpful'
  unhelpful = _.any subject, (med) -> med.name == 'Naproxen 375mg Oral' && med.helpful == false
  assert.ok unhelpful, 'parses unhelpful'

it 'understands unsure medication', ->
  subject = Medication.parse(medication_unsure_html)
  unsure = _.any subject, (med) -> med.name == 'Sumatriptan' && !med.helpful?
  assert.ok unsure, 'parses unsure'

it 'understands somewhat helpful medication', ->
  subject = Medication.parse(medication_somewhat_helpful_html)
  unsure = _.any subject, (med) -> med.name == 'Advil' && !med.helpful?
  assert.ok unsure, 'parses somewhat helpful as unsure'

it 'understands implicit amounts', ->
  subject = Medication.parse(medication_implicit_amount_html)
  no_amount = _.any subject, (med) -> med.name == 'Tylenol' && med.amount == 1
  assert.ok no_amount, 'no amount == 1x'

it 'understands no medication', ->
  subject = Medication.parse(medication_none_html)
  assert.equal subject.length, 0

finish()

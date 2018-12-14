{ start, it, finish } = require './support/support'
fs = require 'fs'
assert = require 'assert'

Medication = require '../lib/medication'

medication_html = fs.readFileSync('specs/fixtures/medication.html').toString()

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

finish()

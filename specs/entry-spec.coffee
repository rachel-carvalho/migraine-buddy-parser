{ start, it, finish } = require './support/support'
fs = require 'fs'
assert = require 'assert'

Entry = require '../lib/entry'
first_entry = fs.readFileSync('specs/fixtures/first-entry.html').toString()

start()

it 'stores entry html', ->
  subject = new Entry(first_entry)
  assert.equal subject.html, first_entry

finish()

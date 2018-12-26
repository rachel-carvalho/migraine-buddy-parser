{ start, it, finish } = require '../support/support'
fs = require 'fs'
assert = require 'assert'

MigraineQC = require '../../lib/migraine-qc'
Report = require '../../lib/report'

report_html = fs.readFileSync('specs/fixtures/5-month-report.html').toString()
report = new Report(report_html)

start()

it 'saves report', ->
  subject = new MigraineQC.Renderer(report)
  assert.equal subject.report, report

it 'splits entries per month', ->
  subject = new MigraineQC.Renderer(report)
  assert.equal subject.months.length, 5
  assert.ok subject.months.every (month) -> month instanceof MigraineQC.Month

  assert.equal subject.months[0].identifier, '2018-12'
  assert.equal subject.months[0].entries.length, 3, 'entries in december'

  assert.equal subject.months[1].identifier, '2018-11'
  assert.equal subject.months[1].entries.length, 7, 'entries in november'

  assert.equal subject.months[2].identifier, '2018-10'
  assert.equal subject.months[2].entries.length, 6, 'entries in october'

  assert.equal subject.months[3].identifier, '2018-9'
  assert.equal subject.months[3].entries.length, 5, 'entries in september'

  assert.equal subject.months[4].identifier, '2018-8'
  assert.equal subject.months[4].entries.length, 8, 'entries in august'

finish()

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
  assert.equal Object.keys(subject.entries_per_month()).length, 5
  assert.ok subject.entries_per_month()['2018_12'].length == 3, 'entries in december'
  assert.ok subject.entries_per_month()['2018_11'].length == 7, 'entries in november'
  assert.ok subject.entries_per_month()['2018_10'].length == 6, 'entries in october'
  assert.ok subject.entries_per_month()['2018_9'].length == 5, 'entries in september'
  assert.ok subject.entries_per_month()['2018_8'].length == 8, 'entries in august'

finish()

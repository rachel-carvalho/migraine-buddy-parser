{ start, it, finish } = require '../support/support'
fs = require 'fs'
assert = require 'assert'

MigraineQC = require '../../lib/migraine-qc'
Report = require '../../lib/report'

report_html = fs.readFileSync('specs/fixtures/5-month-report.html').toString()
report = new Report(report_html)

start()

it 'saves report', ->
  assert.equal MigraineQC.Day.menstruation_dates, undefined, 'no previous external menstruation data'
  subject = new MigraineQC.Renderer(report)
  assert.ok MigraineQC.Day.menstruation_dates?.length > 0, 'set external menstruation data'
  assert.equal subject.report, report

it 'splits entries per month', ->
  subject = new MigraineQC.Renderer(report)
  assert.equal subject.months.length, 5
  assert.ok subject.months.every (month) -> month instanceof MigraineQC.Month

  assert.equal subject.months[0].identifier, '2018-12'
  assert.equal subject.months[0].entries.length, 3, 'entries in december'
  assert.equal subject.months[0].days.length, 31, 'days in december'

  assert.equal subject.months[1].identifier, '2018-11'
  assert.equal subject.months[1].entries.length, 8, 'entries in november'
  assert.equal subject.months[1].days.length, 30, 'days in november'

  assert.equal subject.months[2].identifier, '2018-10'
  assert.equal subject.months[2].entries.length, 6, 'entries in october'
  assert.equal subject.months[2].days.length, 31, 'days in october'

  assert.equal subject.months[3].identifier, '2018-9'
  assert.equal subject.months[3].entries.length, 5, 'entries in september'
  assert.equal subject.months[3].days.length, 30, 'days in september'

  assert.equal subject.months[4].identifier, '2018-8'
  assert.equal subject.months[4].entries.length, 8, 'entries in august'
  assert.equal subject.months[4].days.length, 31, 'days in august'

it 'renders html', ->
  subject = new MigraineQC.Renderer(report).render()
  assert.ok subject.includes('id="month-2018-12"'), 'december month div'
  assert.ok subject.includes('Dec 2018'), 'december month text'
  assert.ok subject.includes('id="month-2018-11"'), 'november month div'
  assert.ok subject.includes('Nov 2018'), 'november month text'
  assert.ok subject.includes('id="month-2018-10"'), 'october month div'
  assert.ok subject.includes('Oct 2018'), 'october month text'
  assert.ok subject.includes('id="month-2018-9"'), 'september month div'
  assert.ok subject.includes('Sep 2018'), 'september month text'
  assert.ok subject.includes('id="month-2018-8"'), 'august month div'
  assert.ok subject.includes('Aug 2018'), 'august month text'

finish()

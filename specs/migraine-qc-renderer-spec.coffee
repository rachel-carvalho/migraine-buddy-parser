{ start, it, finish } = require './support/support'
fs = require 'fs'
assert = require 'assert'

MigraineQCRenderer = require '../lib/migraine-qc-renderer'
Report = require '../lib/report'

report_html = fs.readFileSync('input/report.html').toString()

start()

it 'saves report', ->
  report = new Report(report_html)
  subject = new MigraineQCRenderer(report)
  assert.equal subject.report, report

finish()

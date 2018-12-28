fs = require 'fs'
Report = require './lib/report'
MigraineQC = require './lib/migraine-qc'

report_path = './input/report.html'

report_html = fs.readFileSync(report_path).toString()

report = new Report(report_html)
renderer = new MigraineQC.Renderer(report)

console.log renderer.render()

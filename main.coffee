fs = require 'fs'

report_path = './input/report.html'

report_html = fs.readFileSync(report_path).toString()

report = new Report(report_html)

console.log JSON.stringify(report)

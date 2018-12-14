fs = require 'fs'

report_path = './input/report.html'

report_html = fs.readFileSync(report_path).toString()

console.log report_html

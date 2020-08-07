fs = require 'fs'
pug = require 'pug'
{DateTime} = require 'luxon'

Month = require './month'
Day = require './day'

module.exports =
  class Renderer
    constructor: (@report) ->
      Day.menstruation_dates = @menstruation()

      reducer = (all, entry) ->
        days_months = {}
        entry.days.forEach (day) ->
          month = Month.identify_month(day)
          unless days_months[month]
            all[month] ||= []
            all[month].push entry
            days_months[month] = true
        all

      per_month = @report.entries.reduce reducer, {}

      @months = Object.keys(per_month).map (full_month) ->
        [year, month] = full_month.split('-')
        new Month(date: DateTime.local(parseInt(year), parseInt(month)), entries: per_month[full_month])

      @months.sort (a, b) -> a.date - b.date

      @render_html = pug.compileFile('templates/calendar.pug')

    menstruation: ->
      menstruation_path = 'input/menstruation.json'
      return [] unless fs.existsSync(menstruation_path)
      JSON.parse(fs.readFileSync(menstruation_path))

    render: ->
      @render_html({@months})

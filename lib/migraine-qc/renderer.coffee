pug = require 'pug'

Month = require './month'

module.exports =
  class Renderer
    constructor: (@report) ->
      reducer = (all, entry) ->
        month = Month.identify_month(entry.started_at)
        all[month] ||= []
        all[month].push entry
        all

      per_month = @report.entries.reduce reducer, {}

      @months = Object.keys(per_month).map (full_month) ->
        [year, month] = full_month.split('-')
        new Month(date: new Date(year, parseInt(month) - 1), entries: per_month[full_month])

      @render_html = pug.compileFile('templates/calendar.pug')

    render: ->
      @render_html({@months})

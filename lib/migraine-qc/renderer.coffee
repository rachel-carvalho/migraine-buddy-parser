_ = require 'underscore'
pug = require 'pug'

Month = require './month'

module.exports =
  class Renderer
    constructor: (@report) ->
      @months = _.chain(@report.entries)
        .groupBy (entry) -> Month.identify_month(entry)
        .map (entries) -> new Month(entries)
        .value()

      @render_html = pug.compileFile('templates/calendar.pug')

    render: ->
      @render_html({@months})

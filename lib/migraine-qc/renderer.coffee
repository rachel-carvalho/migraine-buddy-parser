_ = require 'underscore'
Month = require './month'

module.exports =
  class Renderer
    constructor: (@report) ->
      @months = _.chain(@report.entries)
        .groupBy (entry) -> Month.identify_month(entry)
        .map (entries) -> new Month(entries)
        .value()

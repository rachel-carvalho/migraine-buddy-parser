_ = require 'underscore'

module.exports =
  class MigraineQCRenderer
    constructor: (@report) ->

    entries_per_month: ->
      @entries_per_month_cache ||= _.groupBy @report.entries, (entry) ->
        "#{entry.started_at.getFullYear()}_#{entry.started_at.getMonth() + 1}"

module.exports =
  class Month
    @identify_month: (entry) ->
      "#{entry.started_at.getFullYear()}-#{entry.started_at.getMonth() + 1}"

    constructor: (@entries) ->
      @identifier = Month.identify_month @entries[0]

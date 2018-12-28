Day = require './day'

module.exports =
  class Month
    @identify_month: (entry) ->
      "#{entry.started_at.getFullYear()}-#{entry.started_at.getMonth() + 1}"

    constructor: (@entries) ->
      @identifier = Month.identify_month @entries[0]
      @title = @entries[0].started_at.toDateString().replace(/^\w{3} /, '').replace(/ \d{1,2} /, ' ')
      @days = @_days(@entries[0].started_at)

    # private

    _days: (reference) ->
      first_day = new Date(reference.getFullYear(), reference.getMonth(), 1)
      last_day = new Date(reference.getFullYear(), reference.getMonth() + 1, 0)

      [first_day.getDate()..last_day.getDate()].map (day_number) =>
        date = new Date(reference.getFullYear(), reference.getMonth(), day_number)
        new Day(date: date, entries: @_findEntriesOnDay(date))

    _findEntriesOnDay: (date) ->
      next_day = new Date(date.getFullYear(), date.getMonth(), date.getDate() + 1)
      @entries.filter (entry) ->
        entry.started_at >= date && entry.started_at < next_day

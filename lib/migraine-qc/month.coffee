Day = require './day'

module.exports =
  class Month
    @identify_month: (date) ->
      "#{date.getFullYear()}-#{date.getMonth() + 1}"

    constructor: ({@date, @entries}) ->
      @identifier = Month.identify_month @date
      @title = @date.toDateString().replace(/^\w{3} /, '').replace(/ \d{1,2} /, ' ')
      @days = @_days(@date)

    # private

    _days: (reference) ->
      first_day = new Date(reference.getFullYear(), reference.getMonth(), 1)
      last_day = new Date(reference.getFullYear(), reference.getMonth() + 1, 0)

      [first_day.getDate()..last_day.getDate()].map (day_number) =>
        date = new Date(reference.getFullYear(), reference.getMonth(), day_number)
        new Day(date: date, entries: @_findEntriesOnDay(date))

    _findEntriesOnDay: (date) ->
      next_day = new Date(date.getFullYear(), date.getMonth(), date.getDate() + 1)
      @entries.filter (entry) -> entry.days.some (day) -> day.toJSON() == date.toJSON()

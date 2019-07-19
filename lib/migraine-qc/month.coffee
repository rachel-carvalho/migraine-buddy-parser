_ = require 'underscore'
Day = require './day'
{DateTime} = require 'luxon'

module.exports =
  class Month
    @identify_month: (date) ->
      "#{date.year}-#{date.month}"

    constructor: ({@date, @entries}) ->
      @identifier = Month.identify_month @date
      @title = @date.toFormat 'MMM yyyy'
      @days = @_days(@date)
      @triggers = @_triggers()
      @medication = @_medication()

    # private

    _days: (reference) ->
      first_day = reference.startOf 'month'
      last_day = reference.endOf('month').startOf 'day'

      [first_day.day..last_day.day].map (day_number) =>
        date = DateTime.local(reference.year, reference.month, day_number)
        new Day(date: date, entries: @_findEntriesOnDay(date))

    _findEntriesOnDay: (date) ->
      next_day = date.plus day: 1
      @entries.filter (entry) -> entry.days.some (day) -> day.toJSON() == date.toJSON()

    _triggers: ->
      _.chain(@entries)
        .map (entry) -> entry.triggers?[0]?.trim()
        .compact()
        .uniq()
        .sortBy (trigger) -> trigger
        .value()

    _medication: ->
      _.chain(@entries)
        .map (entry) -> entry.medication.map (med) -> med.name.replace(/oral/i, '').trim()
        .flatten()
        .uniq()
        .sortBy (med) -> med
        .value()

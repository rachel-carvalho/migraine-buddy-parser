_ = require 'underscore'
cheerio = require 'cheerio'
Medication = require './medication'

module.exports =
  class Entry
    constructor: (@html) ->
      @_parse()

    toJSON: ->
      _.pick(this, 'pain_level', 'aura', 'triggers', 'menstruation', 'notes', 'duration', 'medication', 'started_at', 'ended_at', 'pain_position', 'days')

    # private

    _parse: ->
      @document = cheerio.load('<tr>' + @html + '</tr>', null, false)

      @pain_level = parseInt(@document('td').eq(3).text().trim())
      @aura = @document('td').eq(7).text().trim().toLowerCase() == 'yes'
      @triggers = @_triggers()
      @menstruation = @_all_triggers().toLowerCase().indexOf('menstruation: yes') > -1
      @notes = @document('td').last().text().trim().substring 'Notes: '.length
      @duration = @_duration()
      @medication = Medication.parse(@document('td').eq(10).html())
      @started_at = new Date(Date.parse(@document('td').eq(1).find('div span').text().trim()))
      @ended_at = new Date(@started_at.getFullYear(), @started_at.getMonth(), @started_at.getDate(), @started_at.getHours() + @duration.hours, @started_at.getMinutes() + @duration.minutes)
      @pain_position = @_pain_position()

      @days = @_days()

    _all_triggers: ->
      @__all_triggers ||= @document('td').eq(5).text().trim()

    _triggers: ->
      triggers = @_all_triggers().replace(/menstruation: (yes|no|soon)/i, '').replace(/no idea/i, '')
      _.compact(triggers.split(',').map (trigger) -> trigger.trim())

    _duration: ->
      duration_text = @document('td').eq(2).text().trim()
      [..., hours, minutes] = duration_text.match(/(\d+)h (\d+)m/i)

      hours: parseInt(hours)
      minutes: parseInt(minutes)
      formatted: duration_text

    _pain_position: ->
      left: @document('td').eq(8).text().trim().length > 0
      right: @document('td').eq(9).text().trim().length > 0

    _days: ->
      first_day = new Date(@started_at.getFullYear(), @started_at.getMonth(), @started_at.getDate())
      last_day = new Date(@ended_at.getFullYear(), @ended_at.getMonth(), @ended_at.getDate())

      day = new Date(@started_at.getFullYear(), @started_at.getMonth(), @started_at.getDate())
      days = []
      while day <= @ended_at
        days.push {day, first: day.toJSON() == first_day.toJSON(), last: day.toJSON() == last_day.toJSON()}
        day = new Date(day.getFullYear(), day.getMonth(), day.getDate() + 1)

      return [days[0].day] if days.length == 1

      hours_at_end_of_1st_day = (24 - @started_at.getHours())
      hours_at_begin_of_last_day = @ended_at.getHours()

      if days.length == 2
        if @started_at.getHours() >= 20 && hours_at_end_of_1st_day <= hours_at_begin_of_last_day
          days.shift()
        else if @ended_at.getHours() <= 4 && hours_at_begin_of_last_day < hours_at_end_of_1st_day
          days.pop()
      else
        if hours_at_end_of_1st_day <= 4 && hours_at_begin_of_last_day <= 4
          if hours_at_begin_of_last_day < hours_at_end_of_1st_day
            days.pop()
          else
            days.shift()

      days.map (d) -> d.day

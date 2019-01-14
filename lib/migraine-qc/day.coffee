_ = require 'underscore'

module.exports =
  class Day
    @external_menstruation: (date) ->
      return unless @menstruation_dates?.length
      @menstruation_dates.includes(JSON.parse(JSON.stringify(date)))

    constructor: ({@date, @entries}) ->

    number: ->
      @date.getDate()

    pain: ->
      return unless @entries.length

      level = Math.max(...@entries.map((e) -> e.pain_level))

      # cap level at 9
      level = 9 if level == 10
      Math.ceil(level / 3)

    aura: ->
      return unless @entries.length
      @entries.some (entry) -> entry.aura

    menstruation: ->
      return Day.external_menstruation(@date) if Day.menstruation_dates?.length
      return unless @entries.length
      @entries.some (entry) -> entry.menstruation

    trigger: ->
      @_triggers()[0]

    medications: ->
      @_medications().map (medication) -> medication.name

    effective: ->
      return unless @entries.length
      @_medications().some (medication) -> medication.helpful

    # private

    _triggers: ->
      @triggers_cache ||= _.flatten @entries.map (entry) -> entry.triggers

    _medications: ->
      @medications_cache ||= _
        .flatten @entries.map (entry) -> entry.medication
        .slice(0, 3)

module.exports =
  class Day
    constructor: ({@date, @entries}) ->

    number: ->
      @date.getDate()

    pain: ->
      level = @_entry().pain_level
      # cap level at 9
      level = 9 if level == 10
      Math.ceil(level / 3)

    aura: ->
      @_entry().aura

    menstruation: ->
      @_entry().menstruation

    trigger: ->
      @_entry().triggers[0]

    medications: ->
      @_medications().map (medication) -> medication.name

    effective: ->
      @_medications().some (medication) -> medication.helpful

    # private

    _entry: ->
      @entries[0]

    _medications: ->
      @medications_cache ||= @_entry().medication.slice(0, 3)

module.exports =
  class Day
    constructor: ({@date, @entries}) ->

    number: ->
      @date.getDate()

    pain: ->
      Math.ceil(@_entry().pain_level / 3)

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
      @medications_cache ||= @_entry().medication

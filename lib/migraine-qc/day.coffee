module.exports =
  class Day
    constructor: ({@date, @entries}) ->

    number: ->
      @date.getDate()

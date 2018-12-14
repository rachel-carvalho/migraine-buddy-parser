cheerio = require 'cheerio'

module.exports =
  class Entry
    constructor: (@html) ->
      @_parse()

    # private

    _parse: ->
      @document = cheerio.load('<tr>' + @html + '</tr>', null, false)

      @pain_level = parseInt(@document('td').eq(3).html())
      @aura = @document('td').eq(7).html().trim().toLowerCase() == 'yes'

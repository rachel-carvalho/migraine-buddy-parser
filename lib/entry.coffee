cheerio = require 'cheerio'
Medication = require './medication'

module.exports =
  class Entry
    constructor: (@html) ->
      @_parse()

    # private

    _parse: ->
      @document = cheerio.load('<tr>' + @html + '</tr>', null, false)

      @pain_level = parseInt(@document('td').eq(3).text().trim())
      @aura = @document('td').eq(7).text().trim().toLowerCase() == 'yes'
      all_triggers = @document('td').eq(5).text().trim()
      @menstruation = all_triggers.toLowerCase().indexOf('menstruation: yes') > -1
      @triggers = all_triggers.replace(/menstruation: (yes|no)/i, '').split(',').map (trigger) -> trigger.trim()
      @notes = @document('td').last().text().trim().substring 'Notes: '.length

      @medication = Medication.parse(@document('td').eq(10).text().trim())

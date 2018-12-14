_ = require 'underscore'
cheerio = require 'cheerio'
Entry = require './entry'

module.exports =
class Report
  constructor: (@html) ->
    @_parse()

  # private

  _parse: ->
    @document = cheerio.load @html
    trs = @document('.reports-table tbody tr')

    [notes, data] = _.partition trs, (tr) -> cheerio(tr).find('.notes').length > 0

    @entries = data.map (tr, index) ->
      entry = new Entry()
      entry.html = cheerio(tr).html() + cheerio(notes[index]).html()
      entry

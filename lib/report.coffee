_ = require 'underscore'
cheerio = require 'cheerio'
Entry = require './entry'

module.exports =
class Report
  constructor: (@html) ->
    @_parse()

  toJSON: ->
    _.omit(this, 'html', 'document')

  # private

  _parse: ->
    @document = cheerio.load @html
    trs = @document('.reports-table tbody tr')

    [notes, data] = _.partition trs, (tr) => @document(tr).find('.notes').length > 0

    @entries = data.map (tr, index) =>
      html = @document(tr).html() + @document(notes[index]).html()
      new Entry(html)

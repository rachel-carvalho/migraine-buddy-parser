cheerio = require 'cheerio'
_ = require 'underscore'

module.exports =
  class Medication
    @parse: (html) ->
      document = cheerio.load('<root>' + html + '</root>', null, false)

      classifications = document('root > div')

      mapping = [['helpful - ', true], ['unhelpful - ', false]]

      _.flatten classifications.toArray().map (classification) ->
        text = cheerio(classification).text().trim()
        [label, helpful] = mapping.find((mapping) -> text.toLowerCase().indexOf(mapping[0]) == 0)
        text = text.substring(label.length)
        text.split(',').map (med) ->
          amount_regexp = /\d+x /i
          amount = parseInt(med.match(amount_regexp)[0])
          new Medication({name: med.replace(amount_regexp, '').trim(), amount, helpful})

    constructor: (options = {}) ->
      {@name, @amount, @helpful} = options

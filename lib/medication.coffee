cheerio = require 'cheerio'
_ = require 'underscore'

module.exports =
  class Medication
    @parse: (html) ->
      document = cheerio.load('<root>' + html + '</root>', null, false)

      classifications = document('root > div')

      mapping = [['helpful - ', true], ['unhelpful - ', false], ['unsure - '], ['somewhat helpful - ']]

      _.flatten classifications.toArray().map (classification) ->
        text = document(classification).text().trim()
        return [] if text.toLowerCase() == 'no medication'

        [label, helpful] = mapping.find((m) -> text.toLowerCase().indexOf(m[0]) == 0)
        text = text.substring(label.length)
        text.split(',').map (med) ->
          amount_regexp = /\d+x /i
          amount = parseInt(med.match(amount_regexp)?[0] || 1)
          new Medication({name: med.replace(amount_regexp, '').trim(), amount, helpful})

    constructor: (options = {}) ->
      {@name, @amount, @helpful} = options

module.exports =
  class Medication
    @parse: (text) ->
      helpful = text.toLowerCase().indexOf('helpful - ') == 0
      text = text.substring('helpful - '.length) if helpful
      text.split(',').map (med) ->
        amount_regexp = /\d+x /i
        amount = parseInt(med.match(amount_regexp)[0])
        new Medication({name: med.replace(amount_regexp, '').trim(), amount, helpful})

    constructor: (options = {}) ->
      {@name, @amount, @helpful} = options

path = require 'path'
colorize = require './colorize'

module.exports =
  start: ->
    @specs = []

  it: (description, body) ->
    @specs.push [description, body]

  finish: ->
    @specs.map (info, index) ->
      [description, body] = info
      line = "[#{index + 1}/#{@specs.length}] it #{description} "
      try
        body()
        console.log colorize(line, 'green') + '👌'
      catch error
        console.log colorize(line, 'red') + '❌'
        console.log '  ' + error
        at = '    at '
        location = error.stack.split('\n')[1].substring at.length
        console.log at + path.relative(__dirname, location)

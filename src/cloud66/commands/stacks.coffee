# Description
# 	stacks command

{ getStacks } = require '../services/get_stacks.coffee'

module.exports = (robot) ->
  robot.respond /(?:cloud66|c66)\s+stacks/, (res) ->

    getStacks(
      robot,
      (message) ->
        res.send(message)
      (message) ->
        res.send(message)
    )

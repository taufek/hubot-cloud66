# Description
#   stack command

{ getStack } = require '../services/get_stack.coffee'

module.exports = (robot) ->
  robot.respond /(?:cloud66|c66)\s+stack\s+(\w*)\s+(.*)/, (res) ->
    getStack(
      robot
      {
        stack_environment: res.match[1]
        stack_name: res.match[2]
      }
      (message) ->
        res.send(message)
      (message) ->
        res.send(message)
    )

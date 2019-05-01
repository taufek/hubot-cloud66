# Description
#   stack command

{ stack_message_builder } = require '../message_builders/stack.coffee'
{ getStacks } = require '../apis/stacks.coffee'
{ invalidStack } = require '../utilities.coffee'

module.exports = (robot) ->
  robot.respond /(?:cloud66|c66)\s+stack\s+(\w*)\s+(.*)/, (res) ->
    environment = res.match[1]
    stack_name = res.match[2]
    getStacks(robot)
      .then (stacks) ->
        stack = stacks.find (item) ->
          item.name == stack_name && item.environment == environment

        return invalidStack() unless stack

        output = stack_message_builder(robot, stack)

        res.send(output)
      .catch (message) ->
        res.send(message)

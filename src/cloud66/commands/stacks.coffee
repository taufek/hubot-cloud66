# Description
# 	stacks command

{ stack_message_builder } = require '../message_builders/stack.coffee'
{ getStacks } = require '../utilities.coffee'

module.exports = (robot) ->
  robot.respond /(?:cloud66|c66)\s+stacks/, (res) ->
    getStacks(robot)
      .then (stacks) ->
        stacks.forEach (stack) ->
          output = stack_message_builder(robot, stack)
          res.send(output)
      .catch (message) ->
        res.send(message)


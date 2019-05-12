{ stack_message_builder } = require '../message_builders/stack.coffee'
{ getStacks } = require '../apis/stacks.coffee'

exports.getStacks = (robot, successCallback, failCallback) ->
  getStacks(robot)
    .then (stacks) ->
      stacks.forEach (stack) ->
        output = stack_message_builder(robot, stack)

        successCallback(output)
    .catch (message) ->
      failCallback(message)

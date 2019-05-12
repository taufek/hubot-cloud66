{ stack_message_builder } = require '../message_builders/stack.coffee'
{ getStacks } = require '../apis/stacks.coffee'
{ invalidStack } = require '../utilities.coffee'

exports.getStack = (robot, params, successCallback, failCallback) ->
  getStacks(robot)
    .then (stacks) ->
      stack = stacks.find (item) ->
        item.uid == params['stack_uid'] or (item.name == params['stack_name'] && item.environment == params['stack_environment'])

      return invalidStack() unless stack

      output = stack_message_builder(robot, stack)
      successCallback(output)
    .catch (message) ->
      failCallback(message)

{ stack_message_builder } = require '../message_builders/stack.coffee'
{ getStacks, getStack, waitForLiveStack } = require '../apis/stacks.coffee'
{ deployStack } = require '../apis/deployments.coffee'
{ invalidStack } = require '../utilities.coffee'

exports.redeploy = (robot, params, successCallback, failCallback) ->
  getStacks(robot)
    .then (stacks) ->
      stack = stacks.find (item) ->
        item.uid == params['stack_uid'] or (item.name == params['stack_name'] && item.environment == params['stack_environment'])

      return invalidStack() unless stack

      deployStack(robot, stack)
    .then ({ message, stack }) ->

      successCallback(message)

      getStack(robot, stack.uid)
    .then (stack) ->
      output = stack_message_builder(robot, stack)

      successCallback(output)

      waitForLiveStack(robot, stack)
    .then (stack) ->
      output = stack_message_builder(robot, stack)

      successCallback(output)
    .catch (message) ->
      failCallback(message)

{ stack_message_builder } = require '../message_builders/stack'
{ getStacks, getStack, waitForLiveStack } = require '../apis/stacks'
{ deployStack } = require '../apis/deployments'
{ invalidStack } = require '../utilities'

exports.redeploy = (robot, params, successCallback, failCallback) ->
  getStacks(robot)
    .then (stacks) ->
      stack = stacks.find (item) ->
        item.uid == params['stack_uid'] or (item.name == params['stack_name'] && item.environment == params['stack_environment'])

      return invalidStack() unless stack
      return Promise.reject('Stack has in-progress deployment') if stack.status != 1

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

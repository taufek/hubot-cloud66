{ stack_message_builder } = require '../message_builders/stack.coffee'
{ deployment_message_builder } = require '../message_builders/deployment.coffee'
{ getStacks } = require '../apis/stacks.coffee'
{ deployments } = require '../apis/deployments.coffee'
{ invalidStack } = require '../utilities.coffee'

exports.deployment = (robot, params, successCallback, failCallback) ->
  getStacks(robot)
    .then (stacks) ->
      stack = stacks.find (item) ->
        item.uid == params['stack_uid'] or (item.name == params['stack_name'] && item.environment == params['stack_environment'])

      return invalidStack() unless stack

      deployments(robot, stack)
    .then ({ deployments, stack }) ->
      deployment = deployments[0]

      output = ''
      if deployment
        successCallback("Here is the latest deployment commit hash for #{stack.environment} #{stack.name}")
        output = deployment_message_builder(robot, deployment)
      else
        successCallback('No deployment')
        output = stack_message_builder(robot, stack)
      successCallback(output)
    .catch (message) ->
      failCallback(message)

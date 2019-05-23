co = require 'co'
{ stack_message_builder } = require '../message_builders/stack.coffee'
{ deployment_message_builder } = require '../message_builders/deployment.coffee'
{ getStacks } = require '../apis/stacks.coffee'
{ getDeployments } = require '../apis/deployments.coffee'
{ invalidStack } = require '../utilities.coffee'

exports.deployment = (robot, params, successCallback, failCallback) ->
  co(() ->
    stacks = yield getStacks(robot)

    stack = stacks.find (item) ->
      item.uid == params['stack_uid'] or (item.name == params['stack_name'] && item.environment == params['stack_environment'])

    return invalidStack() unless stack

    { deployments, stack } = yield getDeployments(robot, stack)

    deployment = deployments?[0]

    if deployment?
      successCallback("Here is the latest deployment commit hash for #{stack.environment} #{stack.name}")
      output = deployment_message_builder(robot, deployment)
      successCallback(output)
    else
      successCallback('No deployment')
  )
  .catch (message) ->
    failCallback(message)

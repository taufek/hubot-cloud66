# Description
#   router

{ getStacks, getStack, waitForLiveStack } = require '../apis/stacks.coffee'
{ deployments, deployStack } = require '../apis/deployments.coffee'
{ stack_message_builder } = require '../message_builders/stack.coffee'
{ deployment_message_builder } = require '../message_builders/deployment.coffee'
{ invalidStack } = require '../utilities.coffee'

module.exports = (robot) ->
  robot.router.post '/hubot/cloud66', (request, response) ->
    data = if request.body.payload? then JSON.parse request.body.payload else request.body

    if data.actions[0].name == 'stack'
      getStack(robot, data['actions'][0]['value'])
        .then (stack) ->
          output = stack_message_builder(robot, stack)

          robot.messageRoom 'dev', output

    if data.actions[0].name == 'redeploy'
      stack_uid = data['actions'][0]['value']

      getStacks(robot)
        .then (stacks) ->
          stack = stacks.find (item) ->
            item.uid == stack_uid

          return invalidStack() unless stack

          deployStack(robot, stack)
        .then ({ message, stack }) ->
          robot.messageRoom 'dev', message

          getStack(robot, stack.uid)
        .then (stack) ->
          output = stack_message_builder(robot, stack)

          robot.messageRoom 'dev', output

          waitForLiveStack(robot, stack)
        .then (stack) ->
          output = stack_message_builder(robot, stack)

          robot.messageRoom 'dev', output
        .catch (message) ->
          robot.messageRoom 'dev', message

    if data.actions[0].name == 'deployment'
      getStack(robot, data['actions'][0]['value'])
        .then (stack) ->
          deployments(robot, stack)
        .then ({ deployments, stack }) ->
          deployment = deployments[0]

          output = ''
          if deployment
            robot.messageRoom 'dev', "Here is the latest deployment commit hash for #{stack.environment} #{stack.name}"
            output = deployment_message_builder(robot, deployment)
          else
            robot.messageRoom 'dev', 'No deployment'
            output = stack_message_builder(robot, stack)
          robot.messageRoom 'dev', output

    responses = ['OK Dokie', 'Your wish is my command', 'Consider it done', 'Right away']

    response.send responses[Math.floor(Math.random()*responses.length)]

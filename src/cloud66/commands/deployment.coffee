# Description
#   deployment command

{ deployment_message_builder } = require '../message_builders/deployment.coffee'
{ getStacks } = require '../apis/stacks.coffee'
{ deployments } = require '../apis/deployments.coffee'
{ invalidStack } = require '../utilities.coffee'

module.exports = (robot) ->
  robot.respond /(?:cloud66|c66)\s+deployment\s+(\w*)\s+(.*)/, (res) ->
    environment = res.match[1]
    stack_name = res.match[2]
    getStacks(robot)
      .then (stacks) ->
        stack = stacks.find (item) ->
          item.name == stack_name && item.environment == environment

        return invalidStack() unless stack

        deployments(robot, stack)
      .then ({ deployments, stack }) ->
        deployment = deployments[0]

        if deployment
          res.send("Here is the latest deployment commit hash for #{stack.environment} #{stack.name}")
          output = deployment_message_builder(robot, deployment)
          res.send(output)
        else
          res.send('No deployment')
      .catch (message) ->
        res.send(message)

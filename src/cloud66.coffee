# Description
#   Hubot for Cloud66
#
# Configuration:
#   CLOUD66_ACCESS_TOKEN - Cloud66 personal access token.
#   CLOUD66_DELAY_IN_MS - Delay in millisecond before start polling Cloud66 for Stack status update after running `redeploy`.
#   CLOUD66_INTERVAL_IN_MS - Interval in millisecond between polling requests for Cloud66 Stack status update.
#   CLOUD66_MAX_ATTEMPTS - Maximum attempts to poll Cloud66 for Stack status update.
#
# Commands:
#   hubot cloud66|c66 stacks - List of available Stacks.
#   hubot cloud66|c66 redeploy <environment> <stack_name> - Redeploy given environment and Stack name.
#   hubot cloud66|c66 stack <environment> <stack_name> - Stack current info for given environment and stack name.
#
# Notes:
#   Go to https://app.cloud66.com/personal_tokens/new to create Cloud66 access token.
#
# Author:
#   Taufek Johar <taufek@gmail.com>

{ stack_message_builder } = require './stack_message_builder.coffee'

module.exports = (robot) ->
  API_URL = 'https://app.cloud66.com/api/3/'

  robot.respond /(?:cloud66|c66)\s+stacks/, (res) ->
    getStacks(robot)
      .then (stacks) ->
        stacks.forEach (stack) ->
          output = stack_message_builder(robot, stack)
          res.send(output)
      .catch (message) ->
        res.send(message)

  robot.respond /(?:cloud66|c66)\s+redeploy\s+(\w*)\s+(.*)/, (res) ->
    environment = res.match[1]
    stack_name = res.match[2]
    getStacks(robot)
      .then (stacks) ->
        stack = stacks.find (item) ->
          item.name == stack_name && item.environment == environment

        return invalidStack() unless stack

        deployStack(robot, stack)
      .then ({ message, stack }) ->

        res.send(message)

        getStack(robot, stack.uid)
      .then (stack) ->
        output = stack_message_builder(robot, stack)
        res.send(output)

        waitForLiveStack(robot, stack)
      .then (stack) ->
        output = stack_message_builder(robot, stack)
        res.send(output)
      .catch (message) ->
        res.send(message)

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

  getStacks = (robot) ->
    new Promise (resolve, reject) ->
      robot.http("#{API_URL}stacks.json")
        .header('Authorization', "Bearer #{process.env.CLOUD66_ACCESS_TOKEN}")
        .get() (err, response, body) ->
          resolve(JSON.parse(body).response)

  getStack = (robot, uid) ->
    new Promise (resolve, reject) ->
      robot.http("#{API_URL}stacks/#{uid}")
        .header('Authorization', "Bearer #{process.env.CLOUD66_ACCESS_TOKEN}")
        .get() (err, response, body) ->
          resolve(JSON.parse(body).response)

  waitForLiveStack = (robot, stack) ->
    @attempt = 0
    new Promise (resolve, reject) ->
      callback = () -> pollingStack(robot, stack, resolve, reject)
      timeout = process.env.CLOUD66_DELAY_IN_MS || 60000
      setTimeout callback, timeout

  pollingStack = (robot, stack, resolve, reject) ->
    robot.http("#{API_URL}stacks/#{stack.uid}")
      .header('Authorization', "Bearer #{process.env.CLOUD66_ACCESS_TOKEN}")
      .get() (err, response, body) =>
        @attempt++
        updatedStack = JSON.parse(body).response
        return resolve(updatedStack) if updatedStack.status == 1
        callback = () -> pollingStack(robot, updatedStack, resolve, reject)
        return reject('Deployment taking too long. Run `stack` command to get status update.') if @attempt > (process.env.CLOUD66_MAX_ATTEMPTS || 10)
        timeout = process.env.CLOUD66_INTERVAL_IN_MS || 60000
        setTimeout callback, timeout

  deployStack = (robot, stack) ->
    new Promise (resolve, reject) ->
      data = JSON.stringify({})
      robot.http("#{API_URL}stacks/#{stack.uid}/deployments")
        .header('Authorization', "Bearer #{process.env.CLOUD66_ACCESS_TOKEN}")
        .post(data) (err, response, body) ->
          resolve({ message: JSON.parse(body).response.message, stack: stack })

  invalidStack = () ->
    Promise.reject('Invalid stack_name')

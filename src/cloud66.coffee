# Description
#   Hubot for Cloud66
#
# Configuration:
#   CLOUD66_ACCESS_TOKEN
#
# Commands:
#   hubot cloud66|c66 stacks - List of available stacks.
#   hubot cloud66|c66 redeploy <environment> <stack_name> - Redeploy given environment and stack name.
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

  robot.respond /(?:cloud66|c66) stacks/, (res) =>
    getStacks(robot)
      .then (stacks) =>
        stacks.forEach (stack) =>
          output = stack_message_builder(robot, stack)
          res.send(output)
      .catch (message) =>
        res.send(message)

  robot.respond /(?:cloud66|c66) redeploy (\w*) (.*)/, (res) =>
    environment = res.match[1]
    stack_name = res.match[2]
    getStacks(robot)
      .then (stacks) =>
        stack = stacks.find (item) =>
          item.name == stack_name && item.environment == environment

        return invalidStack() unless stack

        res.send("Deploying #{environment} #{stack.name} (#{stack.uid})")

        deployStack(robot, stack)
      .then (message) =>
        res.send(message)
      .catch (message) =>
        res.send(message)

  robot.respond /(?:cloud66|c66) stack (\w*) (.*)/, (res) =>
    environment = res.match[1]
    stack_name = res.match[2]
    getStacks(robot)
      .then (stacks) =>
        stack = stacks.find (item) =>
          item.name == stack_name && item.environment == environment

        return invalidStack() unless stack

        output = stack_message_builder(robot, stack)

        res.send(output)
      .catch (message) =>
        res.send(message)

  getStacks = (robot) =>
    new Promise (resolve, reject) =>
      robot.http("#{API_URL}stacks.json")
        .header('Authorization', "Bearer #{process.env.CLOUD66_ACCESS_TOKEN}")
        .get() (err, response, body) =>
          resolve(JSON.parse(body).response)

  deployStack = (robot, stack) =>
    new Promise (resolve, reject) =>
      data = JSON.stringify({})
      robot.http("#{API_URL}stacks/#{stack.uid}/deployments")
        .header('Authorization', "Bearer #{process.env.CLOUD66_ACCESS_TOKEN}")
        .post(data) (err, response, body) =>
          resolve(JSON.parse(body).response.message)

  invalidStack = () ->
    Promise.reject('Invalid stack_name')

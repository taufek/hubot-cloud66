# Description
#   Hubot for Cloud66
#
# Configuration:
#   CLOUD66_ACCESS_TOKEN
#
# Commands:
#   hubot cloud66 stacks - List of available stacks.
#   hubot cloud66 redeploy <environment> <stack_name> - Redeploy given environment and stack name.
#   hubot cloud66 deployment <environment> <stack_name> - Latest deployment info for given environment and stack name.
#
# Notes:
#   Go to https://app.cloud66.com/personal_tokens/new to create Cloud66 access token.
#
# Author:
#   Taufek Johar <taufek@gmail.com>

module.exports = (robot) ->
  API_URL = 'https://app.cloud66.com/api/3/'

  robot.respond /(?:cloud66|c66) stacks/, (res) =>
    getStacks(robot)
      .then (stacks) ->
        stacks.forEach (item) =>
          output = "#{item.name} (env: #{item.environment}, uid: #{item.uid})"
          res.send(output)

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

  robot.respond /(?:cloud66|c66) deployment (\w*) (.*)/, (res) =>
    environment = res.match[1]
    stack_name = res.match[2]
    getStacks(robot)
      .then (stacks) =>
        stack = stacks.find (item) =>
          item.name == stack_name && item.environment == environment

        return invalidStack() unless stack

        getDeployments(robot, stack)
      .then (deployments) =>
        deployment = deployments[0]

        if deployment
          status = if deployment.is_deploying then 'Deploying :hammer_and_wrench:' else 'Deployment completed :rocket:'
          output = "#{environment} #{stack_name} deployment: #{status}"
        else
          output = "No deployment"

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

  getDeployments = (robot, stack) =>
    new Promise (resolve, reject) =>
      robot.http("#{API_URL}stacks/#{stack.uid}/deployments")
        .header('Authorization', "Bearer #{process.env.CLOUD66_ACCESS_TOKEN}")
        .get() (err, response, body) =>
          resolve(JSON.parse(body).response)

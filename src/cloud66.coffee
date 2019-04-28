# Description
#   Hubot for Cloud66
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot hello - <what the respond trigger does>
#   orly - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   Taufek Johar <taufek@gmail.com>

module.exports = (robot) ->
  robot.respond /(?:cloud66|c66) stacks/, (res) =>
    getStacks(robot)
      .then (stacks) ->
        stacks.forEach (item) =>
          output = {
            'environment': item.environment,
            'is_busy': item.is_busy,
            'name': item.name,
            'uuid': item.uuid,
          }
          res.send(output)

  robot.respond /(?:cloud66|c66) deploy (.*) (.*)/, (res) =>
    environment = res.match[1]
    stack_name = res.match[2]
    getStacks(robot)
      .then (stacks) =>
        stack = stacks.find (item) =>
          item.name == stack_name && item.environment == environment

        return invalidStack() unless stack

        deployStack(robot, stack)
      .then (response) =>
        res.send(response.message)
      .catch (message) =>
        res.send(message)


  getStacks = (robot) =>
    new Promise (resolve, reject) =>
      robot.http('https://app.cloud66.com/api/3/stacks.json')
        .header('Authorization', "Bearer #{process.env.CLOUD66_ACCESS_TOKEN}")
        .get() (err, response, body) =>
          resolve(JSON.parse(body).response)

  deployStack = (robot, stack) =>
    new Promise (resolve, reject) =>
      robot.http("https://app.cloud66.com/api/3/stacks/#{stack.uuid}/deployments")
        .header('Authorization', "Bearer #{process.env.CLOUD66_ACCESS_TOKEN}")
        .post() (err, response, body) =>
          resolve(JSON.parse(body).response)

  invalidStack = () ->
    Promise.reject('Invalid stack_name')

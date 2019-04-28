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
          output = JSON.stringify({
            'environment': item.environment,
            'is_busy': item.is_busy,
            'name': item.name,
            'uid': item.uid,
          })
          res.send(output)

  robot.respond /(?:cloud66|c66) deploy (.*) (.*)/, (res) =>
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


  getStacks = (robot) =>
    new Promise (resolve, reject) =>
      robot.http('https://app.cloud66.com/api/3/stacks.json')
        .header('Authorization', "Bearer #{process.env.CLOUD66_ACCESS_TOKEN}")
        .get() (err, response, body) =>
          resolve(JSON.parse(body).response)

  deployStack = (robot, stack) =>
    new Promise (resolve, reject) =>
      data = JSON.stringify({})
      robot.http("https://app.cloud66.com/api/3/stacks/#{stack.uid}/deployments")
        .header('Authorization', "Bearer #{process.env.CLOUD66_ACCESS_TOKEN}")
        .post(data) (err, response, body) =>
          resolve(JSON.parse(body).response.message)

  invalidStack = () ->
    Promise.reject('Invalid stack_name')

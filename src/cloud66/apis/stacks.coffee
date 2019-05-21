{ stack_message_builder } = require '../message_builders/stack.coffee'
{ API_URL, CLOUD66_ACCESS_TOKEN } = require '../constants.coffee'

exports.getStacks = (robot) ->
  new Promise (resolve, reject) ->
    robot.http("#{API_URL}stacks.json")
      .header('Authorization', "Bearer #{CLOUD66_ACCESS_TOKEN}")
      .get() (err, response, body) ->
        resolve(JSON.parse(body).response)

exports.getStack = (robot, uid) ->
  new Promise (resolve, reject) ->
    robot.http("#{API_URL}stacks/#{uid}")
      .header('Authorization', "Bearer #{CLOUD66_ACCESS_TOKEN}")
      .get() (err, response, body) ->
        resolve(JSON.parse(body).response)

exports.waitForLiveStack = (robot, stack) ->
  @attempt = 0
  new Promise (resolve, reject) ->
    callback = () -> pollingStack(robot, stack, resolve, reject)
    timeout = process.env.CLOUD66_DELAY_IN_MS || 60000
    setTimeout callback, timeout

pollingStack = (robot, stack, resolve, reject) ->
  robot.http("#{API_URL}stacks/#{stack.uid}")
    .header('Authorization', "Bearer #{CLOUD66_ACCESS_TOKEN}")
    .get() (err, response, body) =>
      @attempt++
      updatedStack = JSON.parse(body).response
      return resolve(updatedStack) if updatedStack.status in [1, 2, 7]
      callback = () -> pollingStack(robot, updatedStack, resolve, reject)
      return reject('Deployment taking too long. Run `stack` command to get status update.') if @attempt > (process.env.CLOUD66_MAX_ATTEMPTS || 10)
      timeout = process.env.CLOUD66_INTERVAL_IN_MS || 60000
      setTimeout callback, timeout

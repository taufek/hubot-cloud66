{ stack_message_builder } = require '../message_builders/stack.coffee'
{ API_URL, CLOUD66_ACCESS_TOKEN } = require '../constants.coffee'

exports.deployStack = (robot, stack) ->
  new Promise (resolve, reject) ->
    data = JSON.stringify({})
    robot.http("#{API_URL}stacks/#{stack.uid}/deployments")
      .header('Authorization', "Bearer #{CLOUD66_ACCESS_TOKEN}")
      .post(data) (err, response, body) ->
        resolve({ message: JSON.parse(body).response.message, stack: stack })

exports.getDeployments = (robot, stack) ->
  new Promise (resolve, reject) ->
    robot.http("#{API_URL}stacks/#{stack.uid}/deployments")
      .header('Authorization', "Bearer #{CLOUD66_ACCESS_TOKEN}")
      .get() (err, response, body) ->
        resolve({ deployments: JSON.parse(body).response, stack: stack })

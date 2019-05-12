# Description
#   router

{ redeploy } = require '../services/redeploy.coffee'
{ deployment } = require '../services/deployment.coffee'
{ getStack } = require '../services/get_stack.coffee'

module.exports = (robot) ->
  robot.router.post '/hubot/cloud66', (request, response) ->
    data = if request.body.payload? then JSON.parse request.body.payload else request.body
    channelId = data['channel']['id']

    if data.actions[0].name == 'stack'
      getStack(
        robot
        {
          stack_uid: data['actions'][0]['value']
        }
        (message) ->
          robot.messageRoom channelId, message
        (message) ->
          robot.messageRoom channelId, message
      )

    if data.actions[0].name == 'redeploy'
      redeploy(
        robot
        {
          stack_uid: data['actions'][0]['value']
        }
        (message) ->
          robot.messageRoom channelId, message
        (message) ->
          robot.messageRoom channelId, message
      )

    if data.actions[0].name == 'deployment'
      deployment(
        robot
        {
          stack_uid: data['actions'][0]['value']
        }
        (message) ->
          robot.messageRoom channelId, message
        (message) ->
          robot.messageRoom channelId, message
      )

    responses = ['OK Dokie', 'Your wish is my command', 'Consider it done', 'Right away']

    response.send responses[Math.floor(Math.random()*responses.length)]

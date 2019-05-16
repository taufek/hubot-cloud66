// Description
//   router

const { redeploy } = require('../services/redeploy')
const { deployment } = require('../services/deployment')
const { getStack } = require('../services/get_stack')

module.exports = (robot) =>
  robot.router.post('/hubot/cloud66', (request, response) => {
    let data

    if (request.body.payload) {
      data = JSON.parse(request.body.payload)
    } else {
      data = request.body
    }

    const channelId = data['channel']['id']

    if (data.actions[0].name == 'stack') {
      getStack(
        robot,
        {
          stack_uid: data['actions'][0]['value']
        },
        (message) => {
          robot.messageRoom(channelId, message)
        },
        (message) => {
          robot.messageRoom(channelId, message)
        }
      )
    }

    if (data.actions[0].name == 'redeploy') {
      redeploy(
        robot,
        {
          stack_uid: data['actions'][0]['value']
        },
        (message) => {
          robot.messageRoom(channelId, message)
        },
        (message) => {
          robot.messageRoom(channelId, message)
        }
      )
    }

    if (data.actions[0].name == 'deployment') {
      deployment(
        robot,
        {
          stack_uid: data['actions'][0]['value']
        },
        (message) => {
          robot.messageRoom(channelId, message)
        },
        (message) => {
          robot.messageRoom(channelId, message)
        }
      )
    }

    const responses = ['OK Dokie', 'Your wish is my command', 'Consider it done', 'Right away']

    response.send(responses[Math.floor(Math.random()*responses.length)])
  })

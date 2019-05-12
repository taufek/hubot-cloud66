# Description
#   deployment command

{ deployment } = require '../services/deployment.coffee'

module.exports = (robot) ->
  robot.respond /(?:cloud66|c66)\s+deployment\s+(\w*)\s+(.*)/, (res) ->
    deployment(
      robot
      {
        stack_environment: res.match[1]
        stack_name: res.match[2]
      }
      (message) ->
        res.send(message)
      (message) ->
        res.send(message)
    )

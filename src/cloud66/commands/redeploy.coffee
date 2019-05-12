# Description
#   redeploy command

{ redeploy } = require '../services/redeploy.coffee'

module.exports = (robot) ->
  robot.respond /(?:cloud66|c66)\s+redeploy\s+(\w*)\s+(.*)/, (res) ->
    redeploy(
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

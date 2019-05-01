# Description
#   Hubot for Cloud66
#
# Configuration:
#   CLOUD66_ACCESS_TOKEN - Cloud66 personal access token.
#   CLOUD66_DELAY_IN_MS - Delay in millisecond before start polling Cloud66 for Stack status update after running `redeploy`.
#   CLOUD66_INTERVAL_IN_MS - Interval in millisecond between polling requests for Cloud66 Stack status update.
#   CLOUD66_MAX_ATTEMPTS - Maximum attempts to poll Cloud66 for Stack status update.
#
# Commands:
#   hubot cloud66|c66 stacks - List of available Stacks.
#   hubot cloud66|c66 redeploy <environment> <stack_name> - Redeploy given environment and Stack name.
#   hubot cloud66|c66 stack <environment> <stack_name> - Stack current info for given environment and stack name.
#
# Notes:
#   Go to https://app.cloud66.com/personal_tokens/new to create Cloud66 access token.
#
# Author:
#   Taufek Johar <taufek@gmail.com>

Fs = require 'fs'
Path = require 'path'

module.exports = (robot) ->
  path = Path.resolve __dirname, 'cloud66/commands'
  Fs.exists path, (exists) ->
    if exists
      for file in Fs.readdirSync(path)
        robot.loadFile path, file

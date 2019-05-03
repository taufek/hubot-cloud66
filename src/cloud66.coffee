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
#   hubot cloud66|c66 deployment <environment> <stack_name> - Latest deployment info for given environment and Stack name.
#   hubot cloud66|c66 stacks - List of available Stacks.
#   hubot cloud66|c66 stack <environment> <stack_name> - Stack current info for given environment and stack name.
#   hubot cloud66|c66 redeploy <environment> <stack_name> - Redeploy given environment and Stack name.
#
# Notes:
#   Go to https://app.cloud66.com/personal_tokens/new to create Cloud66 access token.
#
# Author:
#   Taufek Johar <taufek@gmail.com>

fs = require 'fs'
path = require 'path'

module.exports = (robot) ->
  file_path = path.resolve __dirname, 'cloud66/commands'
  fs.exists file_path, (exists) ->
    if exists
      for file in fs.readdirSync(file_path)
        robot.loadFile file_path, file

const { stack_message_builder } = require('../message_builders/stack')
const { deployment_message_builder } = require('../message_builders/deployment')
const { getStacks } = require('../apis/stacks')
const { deployments } = require('../apis/deployments')
const { invalidStack } = require('../utilities')

exports.deployment = (robot, params, successCallback, failCallback) => {
  getStacks(robot)
    .then((stacks) => {
      const stack = stacks.find((item) => {
        return item.uid == params['stack_uid'] || (item.name == params['stack_name'] && item.environment == params['stack_environment'])
      })


      if (!stack) {
        return invalidStack()
      }

      return deployments(robot, stack)
    })
    .then(({ deployments, stack }) => {
      const deployment = deployments[0]

      let output = ''
      if (deployment) {
        successCallback(`Here is the latest deployment commit hash for ${stack.environment} ${stack.name}`)
        output = deployment_message_builder(robot, deployment)
      } else {
        successCallback('No deployment')
        output = stack_message_builder(robot, stack)
      }
      successCallback(output)
    })
    .catch((message) => {
      failCallback(message)
    })
}

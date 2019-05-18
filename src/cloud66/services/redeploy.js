const { stack_message_builder } = require('../message_builders/stack')
const { getStacks, getStack, waitForLiveStack } = require('../apis/stacks')
const { deployStack } = require('../apis/deployments')
const { invalidStack } = require('../utilities')

exports.redeploy = (robot, params, successCallback, failCallback) =>
  getStacks(robot)
    .then((stacks) => {
      const stack = stacks.find((item) => {
        return item.uid == params['stack_uid'] || (item.name == params['stack_name'] && item.environment == params['stack_environment'])
      })

      if (!stack) {
        return invalidStack()
      }

      if (stack.status != 1) {
        return Promise.reject('Stack has in-progress deployment')
      }

      return deployStack(robot, stack)
    })
    .then(({ message, stack }) => {

      successCallback(message)

      return getStack(robot, stack.uid)
    })
    .then((stack) => {
      const output = stack_message_builder(robot, stack)

      successCallback(output)

      return waitForLiveStack(robot, stack)
    })
    .then((stack) => {
      const output = stack_message_builder(robot, stack)

      return successCallback(output)
    })
    .catch((message) => {
      failCallback(message)
    })

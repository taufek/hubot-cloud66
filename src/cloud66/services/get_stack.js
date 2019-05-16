const { stack_message_builder } = require('../message_builders/stack')
const { getStacks } = require('../apis/stacks')
const { invalidStack } = require('../utilities')

exports.getStack = (robot, params, successCallback, failCallback) => {
  getStacks(robot)
    .then((stacks) => {
      const stack = stacks.find((item) => {
        return item.uid == params['stack_uid'] || (item.name == params['stack_name'] && item.environment == params['stack_environment'])
      })

      if (!stack) {
        return invalidStack()
      }

      const output = stack_message_builder(robot, stack)
      successCallback(output)
    })
    .catch((message) => {
      failCallback(message)
    })
}

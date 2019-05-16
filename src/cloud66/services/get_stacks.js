const { stack_message_builder } = require('../message_builders/stack')
const { getStacks } = require('../apis/stacks')

exports.getStacks = (robot, successCallback, failCallback) => {
  getStacks(robot)
    .then((stacks) => {
      stacks.forEach((stack) => {
        const output = stack_message_builder(robot, stack)

        successCallback(output)
      })
    })
    .catch((message) => {
      failCallback(message)
    })
}

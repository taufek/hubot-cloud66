//Description
//   stack command

const { getStack } = require('../services/get_stack')

module.exports = (robot) => {
  robot.respond(/(?:cloud66|c66)\s+stack\s+(\w*)\s+(.*)/, (res) => {
    getStack(
      robot,
      {
        stack_environment: res.match[1],
        stack_name: res.match[2]
      },
      (message) => {
        res.send(message)
      },
      (message) => {
        res.send(message)
      }
    )
  })
}

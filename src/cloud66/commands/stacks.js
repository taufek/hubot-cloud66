// Description
// 	stacks command

const { getStacks } = require('../services/get_stacks')

module.exports = (robot) =>
  robot.respond(/(?:cloud66|c66)\s+stacks/, (res) => {

    getStacks(
      robot,
      (message) => {
        res.send(message)
      },
      (message) => {
        res.send(message)
      }
    )
  })

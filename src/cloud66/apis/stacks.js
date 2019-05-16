const { API_URL, CLOUD66_ACCESS_TOKEN } = require('../constants')

let attempt = 0

exports.getStacks = (robot) => {
  return new Promise((resolve) => {
    robot.http(`${API_URL}stacks.json`)
      .header('Authorization', `Bearer ${CLOUD66_ACCESS_TOKEN}`)
      .get()((err, response, body) => {
        resolve(JSON.parse(body).response)
      })
  })
}

exports.getStack = (robot, uid) => {
  return new Promise((resolve) => {
    robot.http(`${API_URL}stacks/${uid}`)
      .header('Authorization', `Bearer ${CLOUD66_ACCESS_TOKEN}`)
      .get()((err, response, body) => {
        resolve(JSON.parse(body).response)
      })
  })
}

exports.waitForLiveStack = (robot, stack) => {
  attempt = 0
  return new Promise((resolve, reject) => {
    const callback = () => pollingStack(robot, stack, resolve, reject)
    const timeout = process.env.CLOUD66_DELAY_IN_MS || 60000
    setTimeout(callback, timeout)
  })
}

const pollingStack = (robot, stack, resolve, reject) => {
  robot.http(`${API_URL}stacks/${stack.uid}`)
    .header('Authorization', `Bearer ${CLOUD66_ACCESS_TOKEN}`)
    .get()((err, response, body) => {
      attempt++

      const updatedStack = JSON.parse(body).response
      if (updatedStack.status == 1) {
        return resolve(updatedStack)
      }

      const callback = () => pollingStack(robot, updatedStack, resolve, reject)

      if (attempt > (process.env.CLOUD66_MAX_ATTEMPTS || 10)) {
        return reject('Deployment taking too long. Run `stack` command to get status update.')
      }
      const timeout = process.env.CLOUD66_INTERVAL_IN_MS || 60000
      setTimeout(callback, timeout)
    })
}

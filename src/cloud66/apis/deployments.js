const { API_URL, CLOUD66_ACCESS_TOKEN } = require('../constants')

exports.deployStack = (robot, stack) => {
  return new Promise((resolve) => {
    const data = JSON.stringify({})
    robot.http(`${API_URL}stacks/${stack.uid}/deployments`)
      .header('Authorization', `Bearer ${CLOUD66_ACCESS_TOKEN}`)
      .post(data)((err, response, body) => {
        resolve({ message: JSON.parse(body).response.message, stack: stack })
      })
  })
}

exports.deployments = (robot, stack) => {
  return new Promise((resolve) => {
    robot.http(`${API_URL}stacks/${stack.uid}/deployments`)
      .header('Authorization', `Bearer ${CLOUD66_ACCESS_TOKEN}`)
      .get()((err, response, body) => {
        resolve({ deployments: JSON.parse(body).response, stack: stack })
      })
  })
}

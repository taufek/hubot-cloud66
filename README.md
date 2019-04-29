# hubot-cloud66

[![CircleCI](https://circleci.com/gh/taufek/hubot-cloud66.svg?style=svg)](https://circleci.com/gh/taufek/hubot-cloud66)

Hubot for Cloud66

See [`src/cloud66.coffee`](src/cloud66.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-cloud66 --save`

Then add **hubot-cloud66** to your `external-scripts.json`:

```json
[
  "hubot-cloud66"
]
```

## Commands

### Stacks List

Display all available stacks.

```
user1>> hubot cloud66 stacks
hubot>> 
frontend_app (env: development, uid: abc-123)
backend_app (env: development, uid: abc-345)
user app (env: development, uid: abc-456)
```

### Stack Redeployment

Redeploy given environment and stack name.

```
user1>> hubot cloud66 redeploy development backend_app
hubot>> Stack queued for redeployment
```

### Stack Deployment Info/Status

Latest deployment info for given environment and stack name.

```
user1>> hubot cloud66 redeploy development backend_app
hubot>> development backend_app deployment: Deployment completed 🚀
```

### Alias

`c66` is an alias for `cloud66`, so you could also run below

```
user1>> hubot c66 deploy development backend_app
hubot>> Stack queued for redeployment
```

## NPM Module

https://www.npmjs.com/package/hubot-cloud66

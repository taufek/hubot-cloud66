# hubot-cloud66

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/4aedde8284c04fb99119695394bbc19d)](https://app.codacy.com/app/taufek/hubot-cloud66?utm_source=github.com&utm_medium=referral&utm_content=taufek/hubot-cloud66&utm_campaign=Badge_Grade_Dashboard)
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

## Environment Variables

`CLOUD66_ACCESS_TOKEN` = Cloud66 personal access token. Go to [Cloud66 personal tokens page](https://app.cloud66.com/personal_tokens/new) to generate one.

`CLOUD66_DELAY_IN_MS` - Delay in millisecond before start polling Cloud66 for Stack status update after running `redeploy`.

`CLOUD66_INTERVAL_IN_MS` - Interval in millisecond between polling requests for Cloud66 Stack status update.

`CLOUD66_MAX_ATTEMPTS` - Maximum attempts to poll Cloud66 for Stack status update.

## Commands

### Stack Deployment Info

Stack latest deployment info for given environment and stack name.

```bash
user1>> hubot cloud66 deployment development backend_app
hubot>> Here is the latest deployment commit hash for development backend_app 
hubot>> Commit https://github.com/taufek/backend_app/commit/5675fcd8f9e6dc534ecf1410c0661c066097e310 
```

### Stacks List

Display all available stacks.

```bash
user1>> hubot cloud66 stacks
hubot>> 
frontend_app (env: development, uid: abc-123)
backend_app (env: development, uid: abc-345)
user app (env: development, uid: abc-456)
```

### Stack Info/Status

Stack current info for given environment and stack name.

```bash
user1>> hubot cloud66 stack development backend_app
hubot>> development backend_app status: Live 🚀
```

### Stack Redeployment

Redeploy given environment and stack name.

```bash
user1>> hubot cloud66 redeploy development backend_app
hubot>> Stack queued for redeployment
hubot>> development backend_app status: Deploying 🛠️
... few minutes later
hubot>> development backend_app status: Live 🚀
```

### Alias

`c66` is an alias for `cloud66`, so you could also run below

```bash
user1>> hubot c66 stack development backend_app
hubot>> development backend_app status: Live 🚀
```

## NPM Module

[NPM module page](https://www.npmjs.com/package/hubot-cloud66)

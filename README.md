# Pult

**UNDER CUNSTRUCTION!** This is **Dev** version (0.0.*x*)

Development progress can be reached at [CHANGELOG](./CHANGELOG.md)

Ruby *>= 2.3.0* require

# What is Pult?

Universal API service for manage your appications and system tasks via Ruby or HTTP.

You can manage your apps **localy** or **remotely**.

# Installation

```bash
gem install pult
```

# Usage

Proceed from the fact, that we have:
- Single Linux host (virtual or bare) with ruby installed
- You want to run your applications on it and manage them
- You want to manage some system tasks too

Talking about usage Pult, first of all we need to talk about use cases..

## Use Cases

There are to types of it:
1. Manage **one** application
2. Manage **many** applications

Manage many applications is the feature of Pult. But to understand the concept and use technique, we start with first item.

## 1. Manage ONE application

### 1.1. Configure app actions via pult.yml

Put `pult.yml` anywere into your app folder, some kind of `<app>/pult.yml` or `<app>/config/pult.yml`, and create any actions you need for manage your app:
```yaml
# actions is a simple linux shell commands

appname:
  test:       'sleep 20 && echo 123'

  # can combine actions of the same level
  up:         [pull, prepare, start]
  restart:    [stop, start]

  pull:       git pull

  prepare:    rails assets:precompile

  # if var is upcase, it will be required in API as a param
  start:      rails s -e production -p $PORT

  # if var is downcase, it will be not required, just local stuff
  stop:       f=tmp/pids/server.pid; if [ -f "$f" ]; then rm $f; fi

  # can grouping actions in sublevels
  log:
    clean:    '>log/production.log'
    view:     cat log/production.log
```

### 1.2. Understanding what Pult gives you after that

Pult provides a bunch universal actions, based on your app actions that you configured in `pult.yml` by adding some special *postfixes* to them (like `_job`, `_out` and etc..)

List of this new Pult API actions, that do some things:
- `<action>` to get source code of action or run it
- `<action>_job` to run action in a backround
- `<action>_out` to get STDOUT of action
- `<action>_err` to get STDERR of action
- `<action>_suc` to get success status of action (true or false)

### 1.2. Start Pult HTTP server and manage your app via API

Main principle of interact with API is:
- `GET` method is used for **view** something
- `POST` method is used for **run** something

Lets start it.

**In your app folder**, type:
```bash
pult server
```

Yep. Pult API server is running (default port is **7070**).

Now, for example with `curl`, you can:
```bash
# GET method is default

# See source code of actions
curl http://localhost:7070/appname/test
curl http://localhost:7070/appname/up
curl http://localhost:7070/appname/restart
curl http://localhost:7070/appname/pull
curl http://localhost:7070/appname/prepare
curl http://localhost:7070/appname/start
curl http://localhost:7070/appname/stop
curl http://localhost:7070/appname/log/clean
curl http://localhost:7070/appname/log/view

# Run actions (be careful, can block you runtime)
curl -X POST http://localhost:7070/api/appname/test
curl -X POST http://localhost:7070/appname/up
curl -X POST http://localhost:7070/appname/restart
curl -X POST http://localhost:7070/appname/pull
curl -X POST http://localhost:7070/appname/prepare
curl -X POST http://localhost:7070/appname/start
curl -X POST http://localhost:7070/appname/stop
curl -X POST http://localhost:7070/appname/log/clean
curl -X POST http://localhost:7070/appname/log/view

# Run actions in a background (asynchronously)
curl -X POST http://localhost:7070/appname/test_job
curl -X POST http://localhost:7070/appname/up_job
curl -X POST http://localhost:7070/appname/restart_job
curl -X POST http://localhost:7070/appname/pull_job
curl -X POST http://localhost:7070/appname/prepare_job
curl -X POST http://localhost:7070/appname/start_job
curl -X POST http://localhost:7070/appname/stop_job
curl -X POST http://localhost:7070/appname/log/clean_job
curl -X POST http://localhost:7070/appname/log/view_job

# See results of runned actions (STDOUT, STDERR, success status)
curl http://localhost:7070/appname/test_out
curl http://localhost:7070/appname/test_err
curl http://localhost:7070/appname/test_suc
curl http://localhost:7070/appname/up_out
curl http://localhost:7070/appname/up_err
curl http://localhost:7070/appname/up_suc
curl http://localhost:7070/appname/restart_out
curl http://localhost:7070/appname/restart_err
curl http://localhost:7070/appname/restart_suc
curl http://localhost:7070/appname/pull_out
curl http://localhost:7070/appname/pull_err
curl http://localhost:7070/appname/pull_suc
curl http://localhost:7070/appname/prepare_out
curl http://localhost:7070/appname/prepare_err
curl http://localhost:7070/appname/prepare_suc
curl http://localhost:7070/appname/start_out
curl http://localhost:7070/appname/start_err
curl http://localhost:7070/appname/start_suc
curl http://localhost:7070/appname/stop_out
curl http://localhost:7070/appname/stop_err
curl http://localhost:7070/appname/stop_suc
curl http://localhost:7070/appname/log/clean_out
curl http://localhost:7070/appname/log/clean_err
curl http://localhost:7070/appname/log/clean_suc
curl http://localhost:7070/appname/log/view_out
curl http://localhost:7070/appname/log/view_err
curl http://localhost:7070/appname/log/view_suc
```

TODO..

## Usage: Via Ruby

TODO..

# TODO

- [ ] README (Usage via Ruby, Pult config, Licence)
- [ ] HTTP API swagger documentation WEB interface
- [ ] Live Stdout / Stderr / Pid of tasks, running in background
- [ ] Tests

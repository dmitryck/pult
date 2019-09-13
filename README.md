# Pult

**UNDER COUNSTRICTION! This is **DEV** version (0.0.*x*)

Development progress can be reached at [CHANGELOG](./CHANGELOG.md)

Ruby *>= 2.3.0* require

# What is Pult?

Ruby or HTTP interface for your app tasks or services, described in yml file(s).

In another words, it is an API, that can be configured and running as a http server, or just been used via Ruby.

# Installation

```bash
gem install pult
```

# Usage

## Usage: Via HTTP server

Put `pult.yml` anywere into your project folder.

Some kind of `<project>/config/pult.yml`:
```yaml
#
# Rails, for example
#
appname:
  test:       'pause 20 && echo 123'

  # allow combine actions of the same level
  up:         [pull, prepare, start]
  restart:    [stop, start]

  pull:       git pull

  prepare:    rails assets:precompile

  # if var is upcase, it will be required in API as a param ($PORT)
  start:      rails s -e production -p $PORT

  # if var is downcase, it will be not required, just local stuff ($f)
  stop:       f=tmp/pids/server.pid; if [ -f "$f" ]; then rm $f; fi

  # allow grouping actions in sublevels
  log:
    clean:    >log/production.log
    view:     cat log/production.log
```

Then in your project folder run:
```bash
pult server
```

Thats it! Pult API server is running (default port is *7070*).

Now, you can:
```bash
# See your tasks
curl 'http://localhost:7070/api/appname/test'
curl 'http://localhost:7070/api/appname/up'
curl 'http://localhost:7070/api/appname/restart'
curl 'http://localhost:7070/api/appname/pull'
curl 'http://localhost:7070/api/appname/prepare'
curl 'http://localhost:7070/api/appname/start'
curl 'http://localhost:7070/api/appname/stop'
curl 'http://localhost:7070/api/appname/log/clean'
curl 'http://localhost:7070/api/appname/log/view'

# Next, test task example only (same for others)

# Run your tasks 'just in time' (can, but not preferably)
curl -X POST 'http://localhost:7070/api/appname/test'

# Run your tasks in a background (preferably)
curl -X POST 'http://localhost:7070/api/appname/test_job'

# See results (Stdout/Stderr, success) of your tasks after running
curl 'http://localhost:7070/api/appname/test_out'
curl 'http://localhost:7070/api/appname/test_err'
curl 'http://localhost:7070/api/appname/test_success'
```

## Usage: Via Ruby

TODO..

# TODO

- [ ] README (Usage via Ruby, Pult config, Licence)
- [ ] HTTP API swagger documentation WEB interface
- [ ] Live Stdout / Stderr / Pid of tasks, running in background
- [ ] Tests

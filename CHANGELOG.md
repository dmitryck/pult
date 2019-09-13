# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.14] - 2019-13-09
### Status
- Dev version

### Updates
- Fix and new pattern for env vars yml (UPCASED and downcased)
- New default port for API server (7070)
- Add README Installation, Usage, TODO

## [0.0.13] - 2019-13-09
### Status
- Dev version

### Updates
- Add `pult` CLI (with `pult server|s` command for run API server)

## [0.0.9] - 2019-11-09
### Status
- Dev version

### Updates
- Default pult root is `pwd`
- Config `pult.yml` can be in root or root`/config` folder
- Autoset `config.dir` in panel yml for apps, equals to project root
- `curl -X POST <url>` API request work now (`-d ''` need earlier)

## [0.0.8] - 2019-11-08
### Status
- Dev version

### Updates
- Fix and refactoring API
- Add JSON Swagger documentation for API
- Ruby version req

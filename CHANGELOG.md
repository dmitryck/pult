# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.21] - 2019-07-10
### Status
- Dev version

### Updates
- Add `service` provider (for system services, api path is `s`)

## [0.0.20] - 2019-26-09
### Status
- Dev version

### Updates
- Fix/Ref `rake` provider, add `rails` command for `<command> --tasks`

## [0.0.19] - 2019-23-09
### Status
- Dev version

### Updates
- Fix `rake` provider (was only last action in rake nested action)
- Fix CHANGELOG releases nums

## [0.0.18] - 2019-23-09
### Status
- Dev version

### Updates
- Fix panel compile when `.pult.yml` has only appname
- Fix `rake` provider (merge in current panel app)

## [0.0.17] - 2019-22-09
### Status
- Dev version

### Updates
- Providers pattern for comliping panel hash
- `pult` provider added for `.pult.yml` (was, but not in pattern)
- `rake` provider added for rake tasks (**new**!)
- `PULT_RAKEPATH` env is `r` by default (prefix in API)

## [0.0.16] - 2019-19-09
### Status
- Dev version

### Updates
- Pattern `.pult.yml` in root of project
- Refactoring `Panel` obj (separated `App`, `Runner` modules with `Injector` and `DotAccessible`)
- Simplify `PULT_<name>` envs;
- Add `PULT_MULTIACT` env (types of multi action in panel `join` or `clone`)

## [0.0.15] - 2019-15-09
### Status
- Dev version

### Updates
- Fix `example/pult.yml`
- Update and refactoring README.md (add Use cases and other descriptions)
- Add summary text in `pult.gemspec` for rubygems.org

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

# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [1.0.4] - 2020-05-10
### Fixed
- Instead of relying solely on `ENV['USER']` for replacing `USER` with the actual user (which fails when run in `cron`), an intermediary variable `user` (in `main()`) is set to `ENV['USER']` first and, if that's empty, `x%( whoami ).chomp` next.

## [1.0.3] - 2020-01-23
### Added
- "Batch" functionality added; now, you can call `rsync.rb backup main,extra,etc` by separating targets with commas.

### Changed
- Merged functions `join_path` and `use_current` into a more sensible `update_path`
- Broke some functionality in function `sync` into `get_partial_cmd`
- Moved main script functionality into own function `main` 

## [1.0.2] - 2019-12-30
### Added
- License

### Changed
- Repository name changed; the name *RubySync* already exists as a [gem](https://rubygems.org/gems/rubysync).

## [1.0.1] - 2019-12-01
### Added
- Readme and changelog
- [`yard`][yard] style inline "docstrings"

### Changed
- Small syntactic changes
    - `sync` definition: `files: nil` -> `files = nil`
    - `sync` call: `files: files` -> `files`
    - `Socket::gethostname` -> `Socket.gethostname`

## [1.0] - 2019-12-17
### Added
- Initial version

[yard]: https://rubydoc.info/gems/yard/file/docs/GettingStarted.md

# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

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

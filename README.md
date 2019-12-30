# rsync.rb

## Overview

This is a wrapper of `rsync` in Ruby. The goal of *rsync.rbx* is to simplify backups with a central remote, e.g. a NAS. Each machine that backs up to the central remote should be quick to setup using this wrapper by modifying the appropriate targets and fields.

### Why

I originally wrote `rsync` wrapper scripts in Bash, but ran into limitations. I also wanted to consolidate the scripts, as many had significant overlaps with each other. Therefore, I sought an alternative language that:

- supports easy installation, especially with `apt`
- supports easy importing of libraries/modules, without being a separate installation
- includes a configuration reader, preferably built-in

Python fits these conditions readily, but I wanted to try a new language and I also did not want to create individual separate environments on each machine. (This is avoidable if I only use the standard library, however.) I tried a couple of other languages but ran into conflicts with my wants above. Ruby fit all of my requirements, even came pre-installed on some of my machines, and is very similar to Python (although in other ways, drastically different).

## Usage

```
$ ruby rsync.rb direction target

Arguments:
  direction     either 'backup' or 'restore'; affects `source` and `dest`
  target        a section in config.yaml; e.g. 'setA' in the example

```

## Requirements

This code was tested using the following:

- Ruby 2.3+ on Debian *stretch* & Ubuntu *bionic*

## Setup

1. [Configure](config.yaml.example) your settings and rename the file to `config.yaml`.

## Disclaimer

This project is not affiliated with or endorsed by `rsync`. See [`LICENSE`](LICENSE) for more detail.

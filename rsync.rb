#!/usr/bin/env ruby
require "yaml"

# Replace instances of 'USER' or 'DEVICE' with appropriate values.
#
# @param what [String] The target to replace; either 'USER' or 'DEVICE'.
# @param replace [String] The replacement string; replaces instances of `what`
#   in `path`.
# @param path [String] A path that may contain `what`: if so, replace it with
#   `replace`.
# @return [String] `path` with instances replaced, if `what` exists. Otherwise,
#   just `path.
def use_current(what, replace, path)
    unless what == 'USER' or what == 'DEVICE'
        raise ArgumentError, "Invalid replacement"
    end
    return path unless path.include? what
    path[what] = replace
    return path
end

# If necessary, join root and relative for a full path.
#
# @param root [String, nil] The root directory defined in config.yaml.
# @param relative [String, nil] A relative path under root. If `nil`, the
#   relative path doesn't exist.
# @return [String] May be `root + relative`; if `relative` is `nil`,
#   just `root`.
def join_path(root, relative)
    # Be careful - either the end of root or beginning of relative should
    # have a slash, preferably at the tail of root.
    if root.nil? and relative.nil?
        raise "Both root and relative are empty"
    end
    return relative if root.nil?
    return root if relative.nil?
    return root + relative
end

# Synchronize from a source to a destination.
#
# @param direction [String] The direction of sync; either 'backup' or 'restore'
# @param source [String] The source; syncs to `dest`, but if `direction` is
#   'restore', `source` becomes `dest`, and `dest` becomes `source`.
# @param dest [String] The destination; see note for `source`.
# @param args [Array] An array of arguments to be supplied to rsync.
# @param files [Array, nil] An optional array of files by path. If defined,
#   rsync recursive is disabled. Files must be relative to the `source` path.
#   Only those files will be synchronized.
# @return [true, false, nil] If the command exists, command success is true and
#   command failure is false; if the command doesn't exist, nil
def sync(direction, source, dest, args, files = nil)
    unless direction == 'backup'
        source, dest = dest, source
    end

    # Gather args: common and direction-specific
    arg = ''
    n = direction == 'backup' ? 1 : 2
    unless args[0]['common'].nil? or args[0]['common'].empty?
       arg << args[0]['common'][0] << ' '
    end
    unless args[n][direction].nil? or args[n][direction].empty?
       arg << args[n][direction][0]
    end

    command = "rsync #{arg} "

    if files.nil?
        command << "-R #{source} "
    else
        files.each { |file| file.prepend(source) }
        files = files.join(' ')
        command << "#{files} "
    end

    command << "#{dest} | grep -vi 'skipping non-regular file'"

    puts "Source:\n    #{source}\n\n"
    puts "Destination:\n    #{dest}\n\n"
    puts "Sync command:\n    #{command}\n\n"
    puts "Syncing..."

    return system(command)
end

# Start of the script.
config = YAML.load_file('config.yaml')

# If the optional device name is missing, use the hostname instead.
if config['device'].to_s.empty?
    require "socket"
    config['device'] = Socket.gethostname
end

# Sanitize args.
unless ARGV[0] == 'backup' or ARGV[0] == 'restore'
    abort("Invalid argument: #{ARGV[0]} should be 'backup' or 'restore'")
end

target = config['paths'][ARGV[1]]

if target.nil?
    abort("Invalid argument: #{ARGV[1]} is not a valid target")
end

# Get paths from config, and if necessary, manipulate them.
root = config['paths']['root']

local = join_path(
    root['local'],
    target['local']
    )

remote = join_path(
    root['remote'],
    target['remote']
    )

# Replace USER with username. We only check local for now,
# because the idea is using a central remote with multiple clients.
local = use_current(
    'USER',
    ENV['USER'],
    local
    )

# Likewise, since the central remote contains the backups by device name,
# we only check remote for now.
remote = use_current(
    'DEVICE',
    config['device'],
    remote
    )

if target['files'].nil?
    files = nil
else
    files = target['files'].split(',')
end

# Finally, sync using all the args.
sync(
    ARGV[0],
    local,
    remote,
    config['args'],
    files
    )

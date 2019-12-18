#!/usr/bin/env ruby
require "yaml"

# Replace instances of 'USER' or 'DEVICE' with appropriate values
def use_current(what, replace, path)
    return path unless what == 'USER' or what == 'DEVICE'
    return path unless path.include? what
    path[what] = replace
    return path
end

# If necessary, join root and relative for a full path.
def join_path(root, relative)
    # Be careful - either the end of root or beginning of relative should
    # have a slash, preferably at the tail of root.
    return root if relative.nil?
    return root + relative
end

# Sync from source to dest.
def sync(direction, source, dest, args, files: nil)
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
        command << "#{files} "
    end

    command << "#{dest} | grep -vi 'skipping non-regular file'"

    return system(command)
end

# Start of the script.
config = YAML.load_file('config.yaml')

# If the device name is missing (because it isn't necessary),
# use the hostname instead.
if config['device'].to_s.empty?
    require "socket"
    config['device'] = Socket::gethostname
end

# Sanitize args.
unless ARGV[0] == 'backup' or ARGV[0] == 'restore'
    abort("Invalid argument: #{ARGV[0]} should be 'backup' or 'restore'")
end

target = config['paths'][ARGV[1]]

if target.nil?
    abort("Invalid argument: #{ARGV[1]} is not a valid target")
end


root = config['paths']['root']

local = target['local']

unless root['local'].nil?
    local = join_path(
        root['local'],
        local
        )
end

# Replace USER with username. We only check local for now,
# because the idea is using a central remote with multiple clients.
local = use_current(
    'USER',
    ENV['USER'],
    local
    )

remote = target['remote']

unless root['remote'].nil?
    remote = join_path(
        root['remote'],
        remote
        )
end

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
    files = target['files'].split(',').join(' ')
end

# Finally, sync using all the args.
sync(
    ARGV[0],
    local,
    remote,
    config['args'],
    files: files
    )

# clear terminal screen
def clear
    system 'clear'
end

def title
    title = "  __                    ___                    \n /    _     _  |_  _     |   _  _   _ |   _  _ \n \\__ |  \\/ |_) |_ (_)    |  |  (_| (_ |( (- |  \n        /  |                                   "
    puts title
end

def installing_missing_gems(&block)
    yield
  rescue LoadError => e
    gem_name = e.message.split('--').last.strip
    install_command = 'gem install ' + gem_name
    
    # install missing gem
    puts 'Probably missing gem: ' + gem_name
    print 'Auto-install it? [yN] '
    gets.strip =~ /y/i or exit(1)
    system(install_command) or exit(1)
    
    # retry
    Gem.clear_paths
    puts 'Trying again ...'
    require gem_name
    retry
  end
# frozen_string_literal: true

require 'httparty'
require 'json'
require 'terminal-table'
require 'colorize'


require_relative '../api/api'
require_relative 'classes'
require_relative 'json-read-write'
require_relative 'portfolio'
require_relative 'help'
require_relative 'user'
require_relative 'general'
require_relative 'password'

path_to_users_file = './json/users/users.json'
path_to_portfolio_file = "./json/portfolios/default.json"

############################################################
###### MENU SYSTEM DISPLAY AND HANDLING ####################
############################################################

# logged out menu display
def top_level_menu(menu_title = "Welcome To CryptoTracker")
    clear
    menu_options = ['Login', 'Quit']
    rows = []
    menu_options.each_with_index do |menu_option, index|
        rows << ["#{index + 1}. #{menu_option}"]
    end
    table = Terminal::Table.new :title => menu_title.colorize(:cyan), :rows => rows
    title
    puts table
end

# logged out menu handling
def top_level_menu_selection(selection, path_to_users_file, username, password)
    retries ||= 0
    begin
    case selection
    when 1 # attempts to log user in
        # clear
        # puts "Username flag is: #{username}"
        # puts "Password flag is: #{password}"
        if username == ""
            puts "Enter username:\n"
            username = gets.strip.chomp
            puts "Password:\n"
            password = gets.strip.chomp
        end
        users_json = read_json_file(path_to_users_file)
        valid = validate_username(username, password, users_json)
        if valid == "password_error"
            return [false]
        end
        if valid
            user_object_array = get_user_data(users_json, username)
            active_user = create_user_object(user_object_array)
            clear
            puts "Welcome #{active_user.name}, you are logged in.\n"
            return [true, username, active_user]
        else
            puts "Access denied for username: #{username}\n"
            return [false, username]
        end
    when 2 # quit
        return [false, "exit"]
    else
        raise error
    end
    rescue
        retry if (retries += 1) < 3
        puts "You have entered incorrect login information. Goodbye."
        return [false]
    end
end

# logged in User menu display
def logged_in_main_menu(menu_title = "Welcome To Crypto Tracker")
    menu_options = ['View Portfolio', 'Add/Remove Crypto', 'Help', 'Quit']
    rows = []
    menu_options.each_with_index do |menu_option, index|
        rows << ["#{index + 1}. #{menu_option}"]
    end
    table = Terminal::Table.new :title => menu_title.colorize(:cyan), :rows => rows
    # title
    puts table
end

# logged in User menu selection handling
def logged_in_menu_selection(selection)
    clear
    case selection
    when 1
        # portfolio
        clear
        return [true, "show_portfolio"]
    when 2
        # add a crypto
        return [true, "add_crypto"]
    when 3
        # help
        clear
        return [true, "show_help"]
    when 4
        # quit
        return [false, "exit"]
    else
        return [true, "error"]
    end
end

# logged in Admin menu display
def logged_in_admin_main_menu(menu_title = "Crypto Tracker Admin")
    # Top level Welcome menu
    menu_options = ['Create User', 'Show All Users', 'Deactivate User', 'Quit']
    rows = []
    menu_options.each_with_index do |menu_option, index|
        rows << ["#{index + 1}. #{menu_option}"]
    end
    table = Terminal::Table.new :title => menu_title.colorize(:cyan), :rows => rows
    # title
    puts table
end

# logged in Admin menu selection handling
def admin_logged_in_menu_selection(selection, path_to_users_file, path_to_portfolio_file)
    case selection
    when 1
        #create user
        clear
        create_user(path_to_users_file)
        return [true, "fusion22"]
    when 2
        # display users
        clear
        users_json = read_json_file(path_to_users_file)
        display_user_info(users_json)
        return [true, "fusion22"]
    when 3
        # deactivate a user
        file_data = read_json_file(path_to_users_file)
        deactivate_user(file_data, path_to_users_file)
        return [true, "fusion22"]
    when 4
        #quit
        return [false, "exit"]
    else
        # error
        clear
        return [true, "error"]
    end
end
############################################################
###### END MENU SYSTEM METHODS #############################
############################################################
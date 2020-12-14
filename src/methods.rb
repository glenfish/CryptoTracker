# frozen_string_literal: true
# begin
require 'httparty'
require 'json'
require 'terminal-table'
require 'colorize'

# path_to_users_file = './json/users/users.json'


def display_user_info(users_json)
    rows =[]
    users_json.each_with_index do |user, index|
        name = users_json[index]['name']
        username = users_json[index]['username']
        password = users_json[index]['password']
        status = users_json[index]['active']
        creation_date = users_json[index]['user_created']
        rows << [name,username,password,status,creation_date]
        if index < (users_json.size - 1)
            rows << :separator
        else
            table = Terminal::Table.new :title => "Users".colorize(:cyan), :headings => ["Name", "Username", "Pass", "Active", "Joined"], :rows => rows
            puts table  
        end
    end

end

def get_user(path_to_users_file)
    file = File.open(path_to_users_file)
    file_data = file.read
    return JSON.parse(file_data)
end

def get_portfolio(path_to_portfolio_file)
    # return JSON portfolio data
end

def validate_username(username, users_json)
    users_json.each_with_index do |user, index|
        username_current = user['username']
        active_current = user['active']
        # puts "Looking at: #{username_current} = #{username}"
        # puts "User is active? #{active_current}"
        if username_current == username && active_current == true
            # puts "#{username} was selected"
            return username
        elsif username_current == username && active_current == false
            # puts "#{username} is not active"
            return false
        end
    end
    return false
end


def top_level_menu(menu_title = "Welcome To Crypto Tracker")
    # Top level Welcome menu
    menu_options = ['Login', 'Create User', 'Help', 'Quit', 'Show All Users']
    rows = []
    menu_options.each_with_index do |menu_option, index|
        rows << ["#{index + 1}. #{menu_option}"]
    end
    table = Terminal::Table.new :title => menu_title.colorize(:cyan), :rows => rows
    puts table
end

def top_level_menu_selection(selection, path_to_users_file)
    case selection
    when 1
        #login
        system 'clear'
        puts "Enter username:\n"
        username = gets.strip.chomp
        users_json = get_user(path_to_users_file)
        valid = validate_username(username, users_json)
        if valid
            # puts "You are successfully logged in, #{username}\n"
            return [true, "logged_in"]
        else
            # puts "Access denied, #{username} user doesn't exist or account inactive!\n"
            return [false, "not_logged_in"]
        end
    when 2
        #create user
        system 'clear'
        puts "create a user"
        return [true, "create_user"]
    when 3
        # help
        system 'clear'
        puts "show help"
        return [true, "show_help"]
    when 4
        # quit
        return [false, "exit"]
    when 5
        system 'clear'
        users_json = get_user(path_to_users_file)
        display_user_info(users_json)
        return [true, "users"]
    else
        # error
        raise AppError
    end
end

# rescue
#     puts "error"
#     # retry
# end
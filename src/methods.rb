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


def top_level_menu(menu_title = "Welcome To Crypto Tracker")
    # Top level Welcome menu
    menu_options = ['Login', 'Create User', 'Help', 'Quit']
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
        puts "user logs in"
    when 2
        #create user
        puts "create a user"
    when 3
        # help
        puts "show help"
    when 4
        # quit
        puts "goodbye"
        exit
    when 5
        system 'clear'
        users_json = get_user(path_to_users_file)
        display_user_info(users_json)
    else
        # error
        raise AppError
    end
end

# rescue
#     puts "error"
#     # retry
# end
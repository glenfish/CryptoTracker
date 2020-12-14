# frozen_string_literal: true
begin
    require 'httparty'
    require 'json'
    require 'terminal-table'
    require 'colorize'


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


def top_level_menu_selection(selection)
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
    else
        # error
        raise AppError
    end
end


rescue
    puts "error"
    retry
end
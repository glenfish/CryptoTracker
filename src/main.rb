# frozen_string_literal: true

require 'httparty'
require 'json'
require 'terminal-table'
require 'colorize'
require 'active_support'
require_relative './methods/menu'
path_to_users_file = './json/users/users.json'
path_to_portfolio_file = "./json/portfolios/tester.json" #default
active_user = []

# flag handling *************************************************
flags = []
ARGV.each do |arg|
    flags << arg.strip.chomp
end
ARGV.clear
username_flag = ""
password_flag = ""
if flags.length == 1
    flag1 = flags[0] # get the help flag
elsif flags.length == 2
    username_flag = flags[0]
    password_flag = flags[1]
end
# allowed: -h, --h, -help or --help
if flag1 == "-h" or flag1 == "--h" or flag1 == "-help" or flag1 == "--help" # allow for variations on help request via flag
    clear
    title
    show_help # show the help information
    exit # quit
end

# end flag handling *********************************************

# START CONTROL FLOW
logged_in = false
while !logged_in
    begin
    case
    when (username_flag == "" || password_flag == "") # if no flag was captured for username, show the 'logged out' top level menu
        top_level_menu("CryptoTracker :: You Are Logged Out") # Optionally pass a title to the Main Menu
        user_selection = gets.strip.chomp.to_i # get user selection
        select = top_level_menu_selection(user_selection, path_to_users_file, username_flag, password_flag)
    else # if username_flag and password_flag was captured, proceed to automatically log in with the arguments passed
        select = top_level_menu_selection(1, path_to_users_file, username_flag, password_flag)
    end
    if select[0] == false 
        # clear
        title
        exit
    elsif
        logged_in = select[0] # sets logged in status to true
    end
    active_user = select[2] # passes back and assigns the active user object
    rescue
        retry
    end
end
while logged_in
    while active_user.admin == true # admin user, not regular user
        logged_in_admin_main_menu("#{active_user.name}'s Admin Menu") # Optionally pass a title to the Main Menu
        user_selection = gets.strip.chomp.to_i # get user selection
        select = admin_logged_in_menu_selection(user_selection, path_to_users_file, path_to_portfolio_file) # array is returned with true/false for logged in at index 0, and a custom value for each action chosen at index 1
        if select[0] == false
            clear
            title
            puts "when lambo?\n\n"
            exit
        elsif
            logged_in = select[0] # sets logged in status to true
        end
    end
    while active_user.admin == false # regular user, not admin user
        logged_in_main_menu("Crypto Portfolio Tracker Main Menu") # Optionally pass a title to the Main Menu
        user_selection = gets.strip.chomp.to_i # get user selection
        begin
        select = logged_in_menu_selection(user_selection)
        rescue
            retry
        end
        if select[0] == false
            clear
            title
            puts "to the moon!\n\n"
            exit
        elsif
            logged_in = select[0] # sets logged in status to true
        end
        if select[1] == "show_portfolio"
            # show portfolio code
            portfolio_assets_quantities_array = read_portfolio_json(path_to_portfolio_file, active_user)
            show_portfolio(portfolio_assets_quantities_array, active_user)
            # end show portfolio code
        elsif select[1] == "add_crypto"
            add_crypto_to_portfolio(active_user)
        elsif select[1] == "show_help"
            show_help
        end
    end
end
# END CONTROL FLOW
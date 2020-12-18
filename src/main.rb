# frozen_string_literal: true

require 'httparty'
require 'json'
require 'terminal-table'
require 'colorize'
require_relative './methods/menu'
path_to_users_file = './json/users/users.json'
path_to_portfolio_file = "./json/portfolios/tester.json" #default
active_user = ""
def title
    title = "  __                    ___                    \n /    _     _  |_  _     |   _  _   _ |   _  _ \n \\__ |  \\/ |_) |_ (_)    |  |  (_| (_ |( (- |  \n        /  |                                   "
    puts title
end

# flag handling *************************************************
flag1 = ARGV[0] # get the flag
# flag2 = ARGV[1]
# flag3 = ARGV[2]
ARGV.clear # clear argv so we don't have a problem with gets
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
    top_level_menu("CryptoTracker :: You Are Logged Out") # Optionally pass a title to the Main Menu
    user_selection = gets.strip.chomp.to_i # get user selection
    select = top_level_menu_selection(user_selection, path_to_users_file)
    if select[0] == false
        clear
        title
        exit
    elsif
        logged_in = select[0] # exits or sets logged in status to true
    end
    active_user = select[2] # passes back the active user object
    rescue
        retry
    end
end
while logged_in
    while select[1] == "fusion22" # admin user (hard coded for now for use with this one username)
        logged_in_admin_main_menu() # Optionally pass a title to the Main Menu
        user_selection = gets.strip.chomp.to_i # get user selection
        select = admin_logged_in_menu_selection(user_selection, path_to_users_file, path_to_portfolio_file) # array is returned with true/false for logged in at index 0, and a custom value for each action chosen at index 1
        if select[0] == false
            clear
            title
            exit
        elsif
            logged_in = select[0] # exits or sets logged in status to true
        end
    end
    while select[1] != "fusion22" # regular user, not admin user
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
            exit
        elsif
            logged_in = select[0] # exits or sets logged in status to true
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
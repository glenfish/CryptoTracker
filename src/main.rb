# frozen_string_literal: true

require 'httparty'
require 'json'
require 'terminal-table'
require 'colorize'
require_relative 'methods'
require_relative 'classes'
path_to_users_file = './json/users/users.json'
path_to_portfolio_file = "./json/portfolios/glenfish.json"
active_user = ""
# START CODE
logged_in = false
while !logged_in
    begin
    top_level_menu("Crypto Portfolio Tracker - You Are Logged Out") # Optionally pass a title to the Main Menu
    user_selection = gets.strip.chomp.to_i # get user selection
    active_selection = top_level_menu_selection(user_selection, path_to_users_file)
    active_selection[0] == false ? exit : logged_in = active_selection[0] # exits or sets logged in status to true
    active_user = active_selection[2] # passes back the active user object
    rescue
        retry
    end
end
while logged_in
    while active_selection[1] == "fusion22" # admin user (hard coded for now for use with this one username)
        logged_in_admin_main_menu() # Optionally pass a title to the Main Menu
        user_selection = gets.strip.chomp.to_i # get user selection
        active_selection = admin_logged_in_menu_selection(user_selection, path_to_users_file, path_to_portfolio_file) # array is returned with true/false for logged in at index 0, and a custom value for each action chosen at index 1
        active_selection[0] == false ? exit : logged_in = active_selection[0] # exits or sets logged in status to true
    end
    while active_selection[1] != "fusion22" # regular user, not admin user
        logged_in_main_menu("Crypto Portfolio Tracker Main Menu") # Optionally pass a title to the Main Menu
        user_selection = gets.strip.chomp.to_i # get user selection
        begin
        active_selection = logged_in_menu_selection(user_selection, path_to_users_file, path_to_portfolio_file)
        rescue
            retry
        end
        active_selection[0] == false ? exit : logged_in = active_selection[0] # exits or sets logged in status to true
        if active_selection[1] == "show_portfolio"
            # show portfolio code
            portfolio_assets_quantities_array = read_portfolio_json(path_to_portfolio_file, active_user)
            show_portfolio(portfolio_assets_quantities_array, active_user)
            # end show portfolio code
        elsif active_selection[1] == "add_crypto"
            #call add crypto method
            add_crypto_to_portfolio(active_user)
        end
    end
end
# END CODE
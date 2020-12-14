# frozen_string_literal: true
# begin
require 'httparty'
require 'json'
require 'terminal-table'
require 'colorize'


require_relative 'methods'


path_to_users_file = './json/users/users.json'
path_to_portfolio_file = "./json/portfolios/glenfish.json"

# START CODE
logged_in = false
while !logged_in
    top_level_menu("Crypto Portfolio Tracker - You Are Logged Out") # Optionally pass a title to the Main Menu
    user_selection = gets.strip.chomp.to_i # get user selection
    active_selection = top_level_menu_selection(user_selection, path_to_users_file)
    active_selection[0] == false ? exit : logged_in = active_selection[0] # exits or sets logged in status to true
end
while logged_in
    while active_selection[1] == "fusion22" # change this to use user object attr subclass of user
        logged_in_admin_main_menu() # Optionally pass a title to the Main Menu
        user_selection = gets.strip.chomp.to_i # get user selection
        active_selection = admin_logged_in_menu_selection(user_selection, path_to_users_file, path_to_portfolio_file) # array is returned with true/false for logged in at index 0, and a custom value for each action chosen at index 1
        active_selection[0] == false ? exit : logged_in = active_selection[0] # exits or sets logged in status to true
    end
    while active_selection[1] != "fusion22" # change this to use user object attr
        logged_in_main_menu("Crypto Portfolio Tracker Main Menu") # Optionally pass a title to the Main Menu
        user_selection = gets.strip.chomp.to_i # get user selection
        active_selection = logged_in_menu_selection(user_selection, path_to_users_file, path_to_portfolio_file)
        active_selection[0] == false ? exit : logged_in = active_selection[0] # exits or sets logged in status to true
        if active_selection[1] == "show_portfolio"
            # show portfolio code
            portfolio_assets_quantities_array = read_portfolio_json(path_to_portfolio_file)
            show_portfolio(portfolio_assets_quantities_array)
            # end show portfolio code
        end
    end
end
# END CODE

# puts "which test file... 1, 2, 3 or 4?\n"
# choice = gets.chomp.to_i
# case choice
#     when 1
#     api_test_file = './json/api_cached/temp-1.json'
#     when 2
#     api_test_file = './json/api_cached/temp-2.json'
#     when 3
#     api_test_file = './json/api_cached/temp-3.json'
#     when 4
#     api_test_file = './json/api_cached/temp-4.json'
#   else
#     api_test_file = './json/api_cached/schema.json'
# end

# puts "big list... y or n ?\n"
# if gets.chomp == "y"
#     portfolio_array = %w[BTC ETH XRP USDT BCH LTC LINK ADA DOT BNB XLM USDC BSV EOS XMR WBTC TRX XEM XTZ LEO FIL CRO NEO DAI VET REV ATOM AAVE DASH WAVES HT MIOTA UNI ZEC ETC YFI THETA BUSD COMP CEL MKR SNX OMG DOGE UMA KSM FTT ONT ZIL ALGO SUSHI OKB BTT BAT TUSD RENBTC DCR NEXO ZRX DGB PAX HUSD AVAX REN QTUM HBAR AMPL ICX ABBC CELO LRC EGLD HEDG STX LUNA KNC RSR REP EWT LSK OCEAN BTG SC QNT RUNE CVT NANO BAND MANA ZB NMR ENJ ANT MAID SNT CHSB XVG NXM RVN]
# else
#     portfolio_array = %w[BTC ETH XRP USDT BCH LTC LINK ADA]
# end

# portfolio = portfolio_array.join(',')
# api_link = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=' + portfolio
# api_key = '' # user enters this at run time for security
# def get_crypto(response, portfolio_array)
#   rows =[]
#   portfolio_array.each do |crypto|
#     name = response['data'][crypto]['name']
#     symbol = response['data'][crypto]['symbol']
#     price = format('%0.2f', response['data'][crypto]['quote']['USD']['price']).gsub(/(\d)(?=\d{3}+\.)/, '\1,')
#     rows << [name, symbol, "$" + price]
#   end

#   table = Terminal::Table.new :title => "Portfolio".colorize(:cyan), :headings => ['Name'.colorize(:cyan), 'Symbol'.colorize(:cyan), 'Price USD'.colorize(:cyan)], :rows => rows
#   puts table
#   puts "\nThere are a total of #{portfolio_array.length + 1} cryptos"
# end

# def call_api(api_link)
#   response = HTTParty.get(api_link,
#                           { headers: { 'X-CMC_PRO_API_KEY' => api_key,
#                                        'Accept' => 'application/json' } })
#   JSON.parse(response.body)
# end

# def call_dummy_api(api_test_file)
#     file = File.open(api_test_file)
#     file_data = file.read
#     return JSON.parse(file_data)
# end

# dummy_response = call_dummy_api(api_test_file)

# get_crypto(dummy_response, portfolio_array)
# raise AppError
# rescue
#   puts "error"
#   retry
# end
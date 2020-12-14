# frozen_string_literal: true
begin
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
    file = File.open(path_to_portfolio_file)
    file_data = file.read
    return JSON.parse(file_data)
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
    menu_options = ['Login', 'Create User', 'Help', 'Quit']
    rows = []
    menu_options.each_with_index do |menu_option, index|
        rows << ["#{index + 1}. #{menu_option}"]
    end
    table = Terminal::Table.new :title => menu_title.colorize(:cyan), :rows => rows
    puts table
end

def logged_in_main_menu(menu_title = "Welcome To Crypto Tracker")
    # Top level Welcome menu
    menu_options = ['Help', 'Portfolio', 'Quit']
    rows = []
    menu_options.each_with_index do |menu_option, index|
        rows << ["#{index + 1}. #{menu_option}"]
    end
    table = Terminal::Table.new :title => menu_title.colorize(:cyan), :rows => rows
    puts table
end

def logged_in_admin_main_menu(menu_title = "Crypto Tracker Admin")
    # Top level Welcome menu
    menu_options = ['Create User', 'Show All Users', 'Quit']
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
            return [true, username]
        else
            # puts "Access denied, #{username} user doesn't exist or account inactive!\n"
            return [false, username]
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

def logged_in_menu_selection(selection, path_to_users_file, path_to_portfolio_file)
    case selection
    when 1
        # help
        system 'clear'
        puts "show help"
        return [true, "show_help"]
    when 2
        # help
        system 'clear'
        # puts "show portfolio"
        return [true, "show_portfolio"]
    when 3
        # quit
        return [false, "exit"]
    else
        # error
        raise AppError
    end
end

def admin_logged_in_menu_selection(selection, path_to_users_file, path_to_portfolio_file)
    case selection
    when 1
        #create user
        system 'clear'
        puts "create a user"
        return [true, "create_user"]
    when 2
        system 'clear'
        users_json = get_user(path_to_users_file)
        display_user_info(users_json)
        return [true, "users"]
    when 3
        # quit
        return [false, "exit"]
    else
        # error
        raise AppError
    end
end

# def show_portfolio
#     system 'clear'
#     puts "which test file... 1, 2, 3 or 4?\n"
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
# system 'clear'
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
#   puts "\nYour portfolio has a total of #{portfolio_array.length + 1} cryptos\n"
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
# end

# method to read portfolio json
def read_portfolio_json(path_to_portfolio_file)
    portfolio_json = get_portfolio(path_to_portfolio_file)
    # p portfolio_json
    # puts "\n"
    portfolio_array = []
    portfolio_array << portfolio_json['username']
    # portfolio_json.each do |key, value|
    portfolio_json['data'].each do |key, value|
            symbol = key
            quantity = value['asset_quantity']
            portfolio_array << [symbol, quantity]
    end
        # portfolio_array << portfolio_json['data'][key]['asset_quantity']
    # end
    # p portfolio_array
    # puts "\n"
    return portfolio_array


end











rescue
    puts "application error"
    # retry
end
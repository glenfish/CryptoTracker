# frozen_string_literal: true

require 'httparty'
require 'json'
require 'terminal-table'
require 'colorize'

path_to_users_file = './json/users/users.json'
path_to_portfolio_file = "./json/portfolios/glenfish.json"

# clear terminal screen
def clear
    system 'clear'
end

# write JSON data to file
def write_json_file(json, filepath)
    File.open(filepath,"w") do |f|
        f.write(json.to_json)
    end
end

def check_duplicate_user(users, new_username) # iterate over an array of hashes and check for instances of username that match
    users.each do |existing_username|
        if existing_username['username'] == new_username
            return true
        end
    end
    return false
end

def deactivate_user(users, path_to_users_file) # change active to false for a specific user in the users.json file
    puts "Enter username to make inactive:\n"
    username = gets.strip.chomp
    users.each do |existing_username|
        if existing_username['username'] == username
            # confirm you want to deactivate the user
            puts "You are about to deactivate #{existing_username['username']}. Sure?"
            if gets.strip.chomp.downcase == 'y'
                # deactivate the user
                existing_username['active']=false
                write_json_file(users, path_to_users_file)
                puts "#{username} user has been deactivated"
                return
            else
            puts "User remains active"
            return
            end
        end
    end
    puts "User does not exist"
end

# create a new user and push to users.json
def create_user(path_to_users_file)
    file_data = get_user(path_to_users_file)
    user_attributes = {"Name: "=> "name", "Username: " => "username", "Password: " => "password"}
    user_hash = Hash.new
    user_attributes.each_with_index do |(k,v),i|
        puts "#{k}\n"
        value = gets.strip.chomp
        user_hash[v] = value
    end
    user_hash['active'] = true
    user_hash['user_created'] = Time.now.strftime("%Y-%m-%d")

    if !check_duplicate_user(file_data, user_hash['username']) # look for exisitng instances of username before creating user
        puts "You are about to add a new user. Are you sure? y/n\n"
            if gets.strip.chomp.to_s == "y"
                file_data.push(user_hash)
                write_json_file(file_data, path_to_users_file)
                puts "User Created!\n"
            else
                puts "User creation aborted.\n"
                return
            end
    else 
        puts "This username already exists"
        return
    end

        
end

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
    parsed_user_json = JSON.parse(file_data)
    # p parsed_user_json
    return parsed_user_json
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
    clear
    menu_options = ['Login', 'Help', 'Quit']
    rows = []
    menu_options.each_with_index do |menu_option, index|
        rows << ["#{index + 1}. #{menu_option}"]
    end
    table = Terminal::Table.new :title => menu_title.colorize(:cyan), :rows => rows
    puts table
end

def logged_in_main_menu(menu_title = "Welcome To Crypto Tracker")
    # Top level Welcome menu
    menu_options = ['Help', 'View Portfolio', 'Quit']
    rows = []
    menu_options.each_with_index do |menu_option, index|
        rows << ["#{index + 1}. #{menu_option}"]
    end
    table = Terminal::Table.new :title => menu_title.colorize(:cyan), :rows => rows
    puts table
end

def logged_in_admin_main_menu(menu_title = "Crypto Tracker Admin")
    # Top level Welcome menu
    menu_options = ['Create User', 'Show All Users', 'Deactivate User', 'Quit']
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
        # clear
        puts "Enter username:\n"
        username = gets.strip.chomp
        users_json = get_user(path_to_users_file)
        valid = validate_username(username, users_json)
        if valid
            clear
            puts "Welcome #{username}, you are logged in.\n"
            return [true, username]
        else
            puts "Access denied, #{username} user doesn't exist or account inactive!\n"
            return [false, username]
        end
    when 2
        # help
        clear
        puts "show help"
        return [true, "show_help"]
    when 3
        # quit
        return [false, "exit"]
    # when 5
        # clear
        # users_json = get_user(path_to_users_file)
        # display_user_info(users_json)
        # return [true, "users"]
    else
        
    end
end

def logged_in_menu_selection(selection, path_to_users_file, path_to_portfolio_file)
    clear
    case selection
    when 1
        # help
        clear
        puts "show help"
        return [true, "show_help"]
    when 2
        # help
        clear
        # puts "show portfolio"
        return [true, "show_portfolio"]
    when 3
        # quit
        return [false, "exit"]
    else
        return [true, "error"]
    end
end

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
        users_json = get_user(path_to_users_file)
        display_user_info(users_json)
        return [true, "fusion22"]
    when 3
        # deactivate user
        file_data = get_user(path_to_users_file)
        deactivate_user(file_data, path_to_users_file)
        return [true, "fusion22"]
    when 4
        #quit
        return [false, "exit"]
    else
        # error
        raise AppError
    end
end

def show_portfolio(portfolio_assets_quantities_array)
    clear


    # puts "big list... y or n ?\n"
    # if gets.chomp == "y"
    portfolio_array = %w[BTC ETH XRP USDT BCH LTC LINK ADA DOT BNB XLM USDC BSV EOS XMR WBTC TRX XEM XTZ LEO FIL CRO NEO DAI VET REV ATOM AAVE DASH WAVES HT MIOTA UNI ZEC ETC YFI THETA BUSD COMP CEL MKR SNX OMG DOGE UMA KSM FTT ONT ZIL ALGO SUSHI OKB BTT BAT TUSD RENBTC DCR NEXO ZRX DGB PAX HUSD AVAX REN QTUM HBAR AMPL ICX ABBC CELO LRC EGLD HEDG STX LUNA KNC RSR REP EWT LSK OCEAN BTG SC QNT RUNE CVT NANO BAND MANA ZB NMR ENJ ANT MAID SNT CHSB XVG NXM RVN]
    # else
        # portfolio_array = %w[BTC ETH XRP USDT BCH LTC LINK ADA]
    # end
    # p portfolio_assets_quantities_array
    output = []
    portfolio_assets_quantities_array.each do |element|
        symbol = element[0]
        portfolio_array.map do |crypto|
        output << crypto if crypto == symbol
        end
    end
    portfolio_array = output

    portfolio = portfolio_array.join(',')
    api_link = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=' + portfolio
    api_key = '' # user enters this at run time for security
    def get_crypto(response, portfolio_array, portfolio_assets_quantities_array)
    rows =[]
    grand_total = 0.0
    portfolio_array.each do |crypto|
        name = response['data'][crypto]['name']
        symbol = response['data'][crypto]['symbol']
        price = format('%0.2f', response['data'][crypto]['quote']['USD']['price']).gsub(/(\d)(?=\d{3}+\.)/, '\1,')
        quantity = 0
        portfolio_assets_quantities_array.each do |element|
            # p "symbol: #{element[0]} qty: #{element[1]}"
            if symbol == element[0]
                quantity = element[1]
            end
        end
        grand_total += quantity * response['data'][crypto]['quote']['USD']['price']
        total = format('%0.2f', quantity * response['data'][crypto]['quote']['USD']['price']).gsub(/(\d)(?=\d{3}+\.)/, '\1,')
        rows << [name, symbol, quantity, "$" + price, "$" + total]
    end
    rows << :separator
    grand_total = format('%0.2f', grand_total).gsub(/(\d)(?=\d{3}+\.)/, '\1,')
    rows << ['Grand Total','','','','$' + grand_total]
    table = Terminal::Table.new :title => "Portfolio".colorize(:cyan), :headings => ['Name'.colorize(:cyan), 'Symbol'.colorize(:cyan), 'Quantity'.colorize(:cyan), 'Price USD'.colorize(:cyan), 'Total USD'.colorize(:cyan)], :rows => rows
    puts table
    puts "\n" + Time.now.strftime("%Y-%m-%d %H:%M") + "\nYour portfolio has a total of #{portfolio_array.length} digital assets.\n\n"
    end

    def call_api(api_link, api_key, filepath = "./json/api_cached/latest.json")
    response = HTTParty.get(api_link,
                            { headers: { 'X-CMC_PRO_API_KEY' => api_key,
                                        'Accept' => 'application/json' } })
    parsed = JSON.parse(response.body)
    write_json_file(parsed, filepath)
    return parsed
    end

    def call_dummy_api(api_test_file)
        file = File.open(api_test_file)
        file_data = file.read
        return JSON.parse(file_data)
    end
    # handles the I/O of selecting the portfolio file source
    puts "1. Use Locally Cached API Test Data\n2. Get Live CoinMarketCap.com API Data\n"
    api_course_selection = gets.strip.chomp.to_i
    clear
    case api_course_selection
    when 1
        begin
        instructions = "Select a cached API test file... 1/2/3/4\nOr for the most recent cached API file (for testing/demo), select 5\n\n"
        instructions += "NOTE: If portfolio has changed since last cached, run a new live api call.\n".colorize(:green)
        puts instructions
        choice = gets.chomp.to_i
        case choice
            when 1
            api_test_file = './json/api_cached/temp-1.json'
            when 2
            api_test_file = './json/api_cached/temp-2.json'
            when 3
            api_test_file = './json/api_cached/temp-3.json'
            when 4
            api_test_file = './json/api_cached/temp-4.json'
            when 5
            api_test_file = './json/api_cached/latest.json'
        else
            api_test_file = './json/api_cached/schema.json'
        end
        rescue
        puts "Please enter a number between 1 and 4"
        retry
        end
        begin
        clear
        dummy_response = call_dummy_api(api_test_file) # cached local call
        get_crypto(dummy_response, portfolio_array, portfolio_assets_quantities_array)
        rescue
        puts "Your portfolio has changed. Run a fresh API call to get the latest data"
    end
        
    when 2
        begin
        puts "Enter API key:\n"
        api_key = gets.strip.chomp
        clear
        puts "*** ... loading live data ... ***\n\n"
        response = call_api(api_link, api_key) # live call
        get_crypto(response, portfolio_array, portfolio_assets_quantities_array)
        rescue
            puts "Error: api key does not match"
        end
    end
end # end show_portfolio method

# method to read portfolio json
def read_portfolio_json(path_to_portfolio_file)
    portfolio_json = get_portfolio(path_to_portfolio_file)
    # p portfolio_json
    # puts "\n"
    portfolio_array = []
    # portfolio_array << portfolio_json['username']
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
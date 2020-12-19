require_relative '../api/api'

def waiting(symbol=".")
    i = 0
    loop do
        print symbol
        sleep(0.006)
        i += 1
        if i == 90
            break
        end
    end
end

# create portfolio object
def create_portfolio_object(username)
    portfolio_object = Portfolio.new(username)
    return portfolio_object
end

# add a new crypto entry to portfolio, or changes an existing entry. Can set quantity = 0 to as a form of quasi delete.
def add_crypto_to_portfolio(active_user)
    path_to_portfolio_file = "./json/portfolios/#{active_user.username}.json"
    portfolio_json = read_json_file(path_to_portfolio_file)
    # p portfolio_json
    puts "Enter the crypto SYMBOL:\n"
    symbol = gets.strip.chomp.upcase
    puts "Enter the quantity:\n"
    quantity = gets.strip.chomp.to_f
    if quantity > 0.0
        puts "Please confirm: #{quantity} #{symbol} (y/n)" # verify user wants to add crypto to portfolio
    elsif quantity == 0.0
        puts "Please confirm you are deleting #{symbol} (y/n)" # does not delete, just sets quantity = 0
    end
    if gets.strip.chomp.downcase == 'y'
        json= {"username":active_user.username,"data":portfolio_json['data'].merge({symbol=>{"asset_name"=>"", "asset_quantity"=>quantity, "asset_buy_date"=>Time.now.strftime("%Y-%m-%d"), "asset_sell_date"=>"", "usd_price"=>"", "btc_price"=>"", "usd_profit"=>"", "btc_profit"=>""}})}
        write_json_file(json, path_to_portfolio_file)
        puts "Your portfolio was updated!"
    else
        puts "Your portfolio was not changed"
    end
rescue

end

def show_portfolio(portfolio_assets_quantities_array, active_user = "")
    clear
    active_user_name = active_user.name
    api_key = active_user.api_key
    puts "#{active_user_name}, Select either cached or live crypto pricing:\n"
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
        output << crypto if (crypto == symbol && element[1] > 0.0)
        end
    end
    portfolio_array = output

    portfolio = portfolio_array.join(',')
    api_link = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol='
    live_api_link = api_link + portfolio

    
    # handles the I/O of selecting the portfolio file source
    puts "1. Locally Cached\n2. Live API\n"
    api_file_selection = gets.strip.chomp.to_i
    clear
    case api_file_selection
    when 1
        begin
        instructions = "Please select a cached API test file 1/2/3/4\n\n"
        # instructions += "NOTE: If portfolio has changed since last cached, run a new live api call.\n".colorize(:green)
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
        dummy_response = read_json_file(api_test_file) # cached local call
        get_crypto(dummy_response, portfolio_array, portfolio_assets_quantities_array,active_user)
        # rescue
        # puts "Your portfolio has changed. Run a fresh API call to get the latest data"
    end
        
    when 2
        # begin
        # puts "Enter API key:\n"
        # api_key = gets.strip.chomp
        # puts api_key
        if !api_key.match(/(...\X-)/) 
            puts "Error: api key does not match"
            return
        end
        print "... loading live data "
        waiting
        response = call_api(live_api_link, api_key) # live call
        clear
        get_crypto(response, portfolio_array, portfolio_assets_quantities_array, active_user)
    end

end # end show_portfolio method

# method to read portfolio json
def read_portfolio_json(path_to_portfolio_file,active_user)
    path_to_portfolio_file = "./json/portfolios/#{active_user.username}.json"
    portfolio_json = read_json_file(path_to_portfolio_file)
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
rescue
end

def get_crypto(response, portfolio_array, portfolio_assets_quantities_array, active_user)
    rows =[]
    grand_total = 0.0
    portfolio_array.each do |crypto|
        name = response['data'][crypto]['name']
        symbol = response['data'][crypto]['symbol']
        price = format('%0.2f', response['data'][crypto]['quote']['USD']['price']).gsub(/(\d)(?=\d{3}+\.)/, '\1,')
        quantity = 0
        portfolio_assets_quantities_array.each do |element|
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
    rows << ["Grand Total",'','','','$' + grand_total]
    # table = Terminal::Table.new :title => "#{active_user_name}", :headings => ['Name'.colorize(:cyan), 'Symbol'.colorize(:cyan), 'Quantity'.colorize(:cyan), 'Price USD'.colorize(:cyan), 'Total USD'.colorize(:cyan)], :rows => rows

    table = Terminal::Table.new
    table.title = "#{active_user.name}'s Crypto Portfolio".colorize(:blue)
    table.headings = ['Name'.colorize(:blue), 'Symbol'.colorize(:blue), 'Quantity'.colorize(:blue), 'Price USD'.colorize(:blue), 'Total USD'.colorize(:blue)]
    table.rows = rows
    table.style = {:width => 100}
    puts table
    puts "Data supplied by CoinMarketCap.com"
    puts "\nUsername: #{active_user.username}\n" + Time.now.strftime("%Y-%m-%d %H:%M") + "\nYour portfolio has a total of #{portfolio_array.length} digital assets.\n\n"
rescue
    
end
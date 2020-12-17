class User
    attr_reader :name, :username, :active, :api_key
    attr_writer 
    attr_accessor 

    def initialize(name, username, password, api_key)
        @name = name
        @username = username
        @password = password
        @api_key = api_key
        @active = true
        @user_created = Time.now.strftime("%Y-%m-%d")
    end

    
    
    # methods
    def to_s
        return "Name: #{@name} Username: #{@username} Password: ******** Active: #{@active} Created: #{@user_created}"
    end

    def show_password
        return @password
    end
    
end

class Portfolio
    attr_reader
    attr_writer
    attr_accessor

    def initialize(username)
        @username = username
    end

    # methods
    def to_s
        return @username
    end

    def portfolio_path
        return "./json/portfolios/#{@username}.json"
    end

    def create_empty_portfolio
        return {"username":"#{@username}","data":{"BTC":{"asset_name":"","asset_quantity":0,"asset_buy_date":"2020-12-14","asset_sell_date":"","usd_price":"","btc_price":"","usd_profit":"","btc_profit":""}}}
    end

end
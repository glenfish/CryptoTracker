class Users
    attr_reader
    attr_writer :password
    attr_accessor :name, :username, :active

    def initialize(name, username, password)
        @name = name
        @username = username
        @password = password
        @active = true
        @user_created = Time.now.strftime("%Y-%m-%d")
    end

    
    
    # methods
    def to_s
        return "Name: #{@name} Username: #{@username} Password: #{@password} Active: #{@active} Created: #{@user_created}"
    end
    

end
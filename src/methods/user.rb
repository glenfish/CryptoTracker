def create_user_object(user_object_array)
    file = File.open('api/api_key.txt')
    api_key = file.read # get the API key
    active_user = User.new(user_object_array[0], user_object_array[1], user_object_array[2], user_object_array[3], api_key) # create user object with (name, username, password, admin, api_key)
    return active_user # return the user object
end

def check_duplicate_user(users, new_username) # iterate over an array of hashes and check for instances of username that match
    users.each do |user|
        if user['username'] == new_username
            return true
        end
    end
    return false
end

# iterate over an array of hashes and return name, username, password and admin array
def get_user_data(users, username)
    user_array = []
    users.each do |user|
        if user['username'] == username
            user_array << user['name']
            user_array << user['username']
            user_array << user['password']
            user_array << user['admin']
        end
    end
    return user_array
end

# change active to false for a specific user in the users.json file
def deactivate_user(users, path_to_users_file)
    puts "Enter username to make inactive:\n"
    username = gets.strip.chomp
    if username == "fusion22"
        clear
        puts "Sorry! You cannot deactivate this admin user."
        return
    end
    users.each do |user|
        if user['username'] == username and username != "fusion22" # cant delete admin with password 'fusion22'
            # confirm you want to deactivate the user
            puts "You are about to deactivate #{user['username']}. Sure? (y/n)"
            choice = gets.strip.chomp.downcase
            if choice.match(/^y/) 
                # deactivate the user
                user['active']=false
                write_json_file(users, path_to_users_file)
                clear
                puts "#{username} user has been deactivated"
                return
            else
            clear
            puts "User remains active"
            return
            end
        end
    end
    clear
    puts "User does not exist"
end

# create a new user and push to users.json
def create_user(path_to_users_file)
    user_object_array = []
    puts "* Create new user *"
    file_data = read_json_file(path_to_users_file)
    user_attributes = {"Name: "=> "name", "Username: " => "username", "Password: " => "password", "Is Admin?: (y/n) " => "admin"}
    user_hash = Hash.new
    user_attributes.each_with_index do |(k,v),i|
        puts "#{k}\n"
        value = gets.strip.chomp
        if v == "admin"
            value.downcase == "y" ? value = true : value = false
        end
        if v == "password"
            value = encrypt(value)
        end
        user_hash[v] = value
        user_object_array << value
    end
    user_hash['active'] = true
    user_hash['user_created'] = Time.now.strftime("%Y-%m-%d")

    if !check_duplicate_user(file_data, user_hash['username']) # true = duplicate username, false = ok to add user
        puts "You are about to add a new user. Are you sure? y/n\n"
        choice = gets.strip.chomp.to_s.downcase
        if choice == "y" || choice == "yes"
            file_data.push(user_hash)
            write_json_file(file_data, path_to_users_file)
            create_user_object(user_object_array) # calls method to create the user object using array of name, username and password
            portfolio_object = create_portfolio_object(user_hash['username']) # calls a method to create a portfolio object and write a blank portfolio json file
            unless user_hash['admin']
                write_json_file(portfolio_object.create_empty_portfolio, portfolio_object.portfolio_path)
            end
            puts "User Created!\n"
        else
            puts "User creation aborted.\n" # existing username found in users.json
            return
        end
    else 
        puts "This username already exists"
        return
    end

        
end

# display a table of all users (viewable only by Admins)
def display_user_info(users_json)
    rows =[]
    users_json.each_with_index do |user, index|
        name = users_json[index]['name']
        username = users_json[index]['username']
        password = decrypt(users_json[index]['password'])
        users_json[index]['admin'] == true ? admin = "admin".colorize(:red) : admin = "user".colorize(:blue)
        users_json[index]['active'] == true ? status = "yes".colorize(:green) : status = "no".colorize(:red)
        creation_date = users_json[index]['user_created']
        rows << [name,username,password,admin, status,creation_date]
        if index < (users_json.size - 1)
            rows << :separator
        else
            table = Terminal::Table.new :title => "Users".colorize(:cyan), :headings => ["Name".colorize(:cyan), "Username".colorize(:cyan), "Password".colorize(:cyan), "Type".colorize(:cyan), "Active".colorize(:cyan), "Joined".colorize(:cyan)], :rows => rows
            puts table  
        end
    end

end

# checks to see if username exists in users.json file
def validate_username(username, password, users_json)
    users_json.each_with_index do |user, index|
        name_current = user['name']
        username_current = user['username']
        password_current = decrypt(user['password'])
        active_current = user['active']
        # puts "Looking at: #{username_current} = #{username}"
        # puts "User is active? #{active_current}"
        if username_current == username && active_current == true && password_current == password
            # puts "#{username} was selected"
            return username
        elsif username_current == username && active_current == true && password_current != password
            clear
            # puts "Incorrect username or password. Please try again."
            return "password_error"
        elsif username_current == username && active_current == false
            # puts "#{username} is not active"
            return false
        end
    end  
    return false
end
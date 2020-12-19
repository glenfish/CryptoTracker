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

#activate or deactive a user
def activate_deactivate(file_data, path_to_users_file)
    clear
    puts "1. Activate User\n2. Deactivate User\n3. Go back\n"
    choice = gets.strip.chomp.to_i
    case choice
    when 1
        activate_user(file_data, path_to_users_file)
    when 2
        deactivate_user(file_data, path_to_users_file)
    when 3
        clear
        return
    end
end

# change active to false for a specific user in the users.json file
def deactivate_user(users, path_to_users_file)
    puts "Enter username to make inactive:\n"
    username = gets.strip.chomp
    if username == "admin"
        clear
        puts "Sorry! You cannot deactivate this admin user."
        return
    end
    users.each do |user|
        if user['username'] == username and username != "admin" # cant delete admin user
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

def activate_user(users, path_to_users_file)
    puts "Enter username to make active:\n"
    username = gets.strip.chomp
    users.each do |user|
        if user['username'] == username
            # confirm you want to deactivate the user
            puts "You are about to activate #{user['username']}. Sure? (y/n)"
            choice = gets.strip.chomp.downcase
            if choice.match(/^y/) 
                # activate the user
                user['active']=true
                write_json_file(users, path_to_users_file)
                clear
                puts "#{username} user has been activated"
                return
            else
            clear
            puts "No change to user"
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
    is_admin_user = ''
    puts "* Create new user *"
    file_data = read_json_file(path_to_users_file)
    user_attributes = {"Name: "=> "name", "Username: " => "username", "Password: " => "password", "Is Admin?: (y/n) Note: only regular non-admin users can have portfolios" => "admin"}
    user_hash = Hash.new
    user_attributes.each_with_index do |(k,v),i|
        puts "#{k}\n"
        value = gets.strip.chomp
        if v == "admin"
            value.downcase == "y" ? value = true : value = false
            is_admin_user = value
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
        if is_admin_user
            puts "You are about to add a new Admin User. Are you sure? y/n\n"
        else
            puts "You are about to add a new Regular User. Are you sure? y/n\n"
        end
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
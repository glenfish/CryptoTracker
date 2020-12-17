# Method to show help information
def show_help()
    file = File.open('./methods/content/help_content.txt')
    file_data = file.read
    puts file_data
end
# frozen_string_literal: true

# read JSON data from file
def read_json_file(filepath)
    file = File.open(filepath)
    file_data = file.read
    return JSON.parse(file_data)
end

# write JSON data to file
def write_json_file(json, filepath)
    File.open(filepath,"w") do |f|
        f.write(json.to_json)
    end
end
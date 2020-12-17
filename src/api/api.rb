def call_api(api_link, api_key, filepath = "./json/api_cached/latest.json")
    response = HTTParty.get(api_link,
                            { headers: { 'X-CMC_PRO_API_KEY' => api_key,
                                        'Accept' => 'application/json' } })
    parsed = JSON.parse(response.body)
    write_json_file(parsed, filepath) # writes the most recent live API call to latest.json
    return parsed
end
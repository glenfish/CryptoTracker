require_relative '../main.rb'

describe 'call_dummy_api' do
  it 'should return JSON data' do
    expect(call_dummy_api('./json/api_cached/temp-1.json')).to be_truthy
    expect(call_dummy_api('./json/api_cached/temp-1.json')).to have_key("status")
  end
end
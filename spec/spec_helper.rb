config.include JSON::SchemaMatchers

#schema file
config.json_schemas[:my_schema] = "../json/api_cached/schema.json"
#inline
config.json_schemas[:inline_schema] = '{"type": "string"}'
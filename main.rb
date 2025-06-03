require_relative 'Adapter'

 
puts OllamaClient.server_available?
client = OllamaClient.new('llama2:7b')
puts OllamaClient.list_models

client.setUpModel





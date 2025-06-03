require_relative 'Adapter'



client = OllamaClient.new("ALIENTELLIGENCE/imagegenaiprompter:latest");
#client.setUpModel
#puts client.generate("Привет")
puts client.deleteModel
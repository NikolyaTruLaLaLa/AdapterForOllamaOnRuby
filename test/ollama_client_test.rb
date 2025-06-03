require 'test_helper'
require_relative '../Adapter'

class OllamaClientTest < Minitest::Test
  def setup
    @client = OllamaClient.new('llama2:7b')
  end

  def test_server_connection
    assert OllamaClient.server_available?
  end
  def test_model_answer
    
    ans = @client.generate("Привет")
    
    assert ans.any?, "Должны быть получены данные о прогрессе"
   

    
  end
end
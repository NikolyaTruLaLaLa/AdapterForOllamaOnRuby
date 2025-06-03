require 'test_helper'
require_relative '../Adapter'
require 'webmock'

class OllamaClientTest < Minitest::Test
  def setup
    @client = OllamaClient.new('llama2:7b')
    stub_request(:get, "http://localhost:11434/api/tags")
      .to_return(status: 200, body: '{"models":[]}', headers: {})

  end

  def test_server_connection
    assert OllamaClient.server_available?
  end
  def test_model_answer
    
    ans = @client.generate("Привет")
    
    assert ans.any?, "Должны быть получены данные о прогрессе"
   


  end
end
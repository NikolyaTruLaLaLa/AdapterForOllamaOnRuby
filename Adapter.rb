require 'httparty'
require 'json'

class OllamaClient

  API_BASE = 'http://localhost:11434/api'.freeze


  def initialize(model_name, api = 'http://localhost:11434/api')
    @model_name = model_name
      @API_BASE_URL = api
    
  end


  def generate(prompt, stream: false, options: {})
    body = {
      model: @model_name,
      prompt: prompt,
      stream: stream,
      options: options
    }.compact.to_json

    send_request('/generate', body, stream: stream)
  end


  def chat(messages, stream: false, options: {})
    body = {
      model: @model_name,
      messages: messages,
      stream: stream,
      options: options
    }.compact.to_json

    send_request('/chat', body, stream: stream)
  end

  def setUpModel()
      puts "Начинаем скачивание модели"
      system("ollama pull #{@model_name}")
      puts "Готово"
    end


  def push_model(insecure: false, stream: false)
    body = { name: @model_name, insecure: insecure, stream: stream }.to_json
    send_request('/push', body, stream: stream)
    print "Готово"
  end

  def delete_model
    body = { name: @model_name }.to_json
    send_request('/delete', body, method: :delete)
  end
  ####
  def self.list_models
    response = HTTParty.get("#{API_BASE}/tags")
    JSON.parse(response.body)['models'] rescue []
  end

  def pull_model(stream: false)
    body = { name: @model_name, stream: stream }.to_json
    send_request('/pull', body, stream: stream)
  end

  def self.server_available?
    response = HTTParty.get("#{API_BASE}/tags", timeout: 10)
    response.success?
  rescue
    false
  end

  private


  def send_request(endpoint, body, stream: false, method: :post)
      url = "#{@API_BASE_URL}#{endpoint}"

      options = {
        headers: { 'Content-Type' => 'application/json' },
        body: body,
        timeout: 300  # Увеличиваем таймаут до 5 минут
      }

      if stream
        options[:stream_body] = true
        response = HTTParty.post(url, options)
      Enumerator.new do |yielder|
        response.body.each_line do |line|
          next if line.strip.empty?
          parsed = JSON.parse(line) rescue nil
          yielder << parsed if parsed
        end
      end
      else
        case method
        when :delete
          HTTParty.delete(url, options)
        else
          HTTParty.post(url, options)
        end
      end
      rescue Net::ReadTimeout => e
        { 'error' => "Timeout: #{e.message}" }
      rescue SocketError, Errno::ECONNREFUSED => e
        { 'error' => "Connection failed: #{e.message}" }
  end
  
      
end


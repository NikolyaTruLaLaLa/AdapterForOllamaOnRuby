require 'fileutils'
require 'open3'

class OllamaClient
  

  def initialize(model_name)
    @model_name = model_name
  end



  # генерация
  def generate(prompt)

  command = "ollama run #{@model_name} '#{prompt}'"
  full_response = ""
  Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
    stdin.puts(prompt)
    stdin.close
    stdout.each_line { |line| full_response += line.chomp + " "}

    unless wait_thr.value.success?
      puts "Ошибка: #{stderr.read}"
    end
  end
  full_response.strip()
  end

  def self.list_models
    response = HTTParty.get("#{API_BASE}/tags")
    JSON.parse(response.body)['models'] rescue []
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

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

  # скачана ли модель?
  def isReady?()
    res = false
    Open3.popen3("ollama list") do |stdin, stdout, stderr, wait_thr|
      stdout.each_line { |line| res = res || line.include?(@model_name)}
    end
    res
  end

  # скачивание
  def setUpModel()
    puts "Начинаем скачивание модели"
    system("ollama pull #{@model_name}")
    puts "Готово"
  end


  def deleteModel()
    system("ollama rm #{@model_name}")
  end
end

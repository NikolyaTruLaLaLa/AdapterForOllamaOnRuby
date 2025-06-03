require 'open-uri'
require 'fileutils'

def install_ollama
  case RUBY_PLATFORM.downcase
  when /darwin/ # macOS
    set_up_for_macos

  when /linux/
    set_up_for_linux
  when /mswin|mingw|cygwin/ # Windows
    set_up_for_windows
  else
    puts "Ваша операционная система не поддерживается."
    puts "Пожалуйста, скачайте Ollama вручную с https://ollama.com/download"
  end
end

def download_file(url, filename)
  puts "Скачиваем #{filename}..."
  File.open(filename, 'wb') do |file|
    file << URI.open(url).read
  end
rescue => e
  puts "Ошибка при скачивании: #{e.message}"
  exit(1)
end

def unzip_file(zip_file)
  puts "Распаковываем #{zip_file}..."
  if RUBY_PLATFORM.downcase.include?('darwin')
    system("unzip #{zip_file} -d /Applications/")
  else
    # Для других систем может потребоваться дополнительная обработка
    system("unzip #{zip_file}")
  end
rescue => e
  puts "Ошибка при распаковке: #{e.message}"
  exit(1)
end

def set_up_for_macos()
  puts "Устанавливаем Ollama для macOS..."
  download_url = 'https://ollama.com/download/Ollama-darwin.zip'
  zip_file = 'Ollama-darwin.zip'
  
  download_file(download_url, zip_file)
  unzip_file(zip_file)
  FileUtils.rm(zip_file)
  
  puts "Установка завершена. Запустите приложение Ollama из папки Applications."
end

def set_up_for_linux()
  puts "Устанавливаем Ollama для Linux..."
  # Для Linux предлагается скрипт установки
  download_url = 'https://ollama.com/install.sh'
  script_file = 'install.sh'
  
  download_file(download_url, script_file)
  FileUtils.chmod('+x', script_file)
  
  puts "Запускаем скрипт установки..."
  system("./#{script_file}")
  FileUtils.rm(script_file)

end

def set_up_for_windows()
  puts "Устанавливаем Ollama для Windows..."
  download_url = 'https://ollama.com/download/OllamaSetup.exe'
  exe_file = 'OllamaSetup.exe'
  
  download_file(download_url, exe_file)
  
  puts "Запускаем установщик..."
  system("start #{exe_file}")
  puts "Пожалуйста, завершите установку через графический интерфейс."
end

# Запуск установки
puts "Начинаем установку Ollama..."
install_ollama
puts "Готово!"
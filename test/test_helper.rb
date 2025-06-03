require 'minitest/autorun'

require 'webmock/minitest'  # Это ключевое изменение!
require_relative '../Adapter'  # Или правильный путь к вашему файлу

# Включаем WebMock и разрешаем только локальные соединения
WebMock.enable!
WebMock.disable_net_connect!(allow_localhost: true)
# Добавьте пути к вашему коду
$LOAD_PATH.unshift File.expand_path('../Adapter.rb')
require 'minitest/autorun'

require 'webmock/minitest'  
require_relative '../Adapter' 

# Включаем WebMock и разрешаем только локальные соединения
WebMock.enable!
WebMock.disable_net_connect!(allow_localhost: true)

$LOAD_PATH.unshift File.expand_path('../Adapter.rb')
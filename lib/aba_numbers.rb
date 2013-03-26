module AbaNumbers

  ROOT_PATH = File.expand_path(File.dirname(File.dirname(__FILE__)))
  LIB_PATH = File.join ROOT_PATH, 'lib'
  DB_PATH = File.join ROOT_PATH, 'db'
  TMP_PATH = File.join ROOT_PATH, 'tmp'

end

$LOAD_PATH.unshift(AbaNumbers::LIB_PATH) unless $LOAD_PATH.include?(AbaNumbers::LIB_PATH)

require 'aba_numbers/version'
require 'aba_numbers/validation'
require 'aba_numbers/database'

require 'yaml'

require_relative 'meme-translator/api/api.rb'
require_relative 'meme-translator/translator.rb'

config = YAML::load(File.read('./lib/config.yml'))

secret = config['secret']
location = config['location']
api = Api.new(secret, location)

passes = config['passes'] || 5

filename = ARGV[0]

raise "File doesn't exist" unless File.exist?(filename)

translator = Translator.new(api, passes)

begin
  new_content = translator.translate_file(File.read(filename))
rescue Exception => e
  puts "Something went wrong. It's likely that your file is not a valid JSON file, or does not adhere to the expected format."
  exit 1
end

File.write(filename, JSON.generate(new_content))
puts "Successfully translated your file!"

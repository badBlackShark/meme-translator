require 'json'

class Translator
  # Change this to the languages you want this to randomly choose from
  @@languages = {
    'en' => 'English',
    'ja' => 'Japanese',
    'it' => 'Italian',
    'ar' => 'Arabic',
    'da' => 'Danish',
    'nl' => 'Dutch',
    'fi' => 'Finnish',
    'fr' => 'French',
    'de' => 'German',
    'el' => 'Greek',
    'ko' => 'Korean',
    'fa' => 'Persian',
    'pl' => 'Polish',
    'ru' => 'Russian',
    'es' => 'Spanish',
    'sv' => 'Swedish'
  }.freeze

  def initialize(api, passes)
    @api = api
    @passes = passes
  end

  def translate_file(raw)
    json = JSON.parse(raw)
    lines = json.values.map { |h| h.values.size }.sum
    line = 1
    json.keys.each do |key|
      json[key].keys.each do |k|
        langs = @@languages.keys.sample(@passes) << 'en'
        if json[key][k].start_with?("{$")
          puts "Skipping phrase '#{json[key][k]}', as it isn't localized."
        else
          puts "Starting with phrase: '#{json[key][k]}'"
          (@passes + 1).times do |i|
            from = i == 0 ? nil : langs[i - 1]
            json[key][k] = translate_phrase(json[key][k], langs[i], from)
          end

          if json[key][k].size <= 15 || json[key][k].end_with?(".")
            json[key][k] = json[key][k][0...-1]
          end

          puts "Final output after #{@passes + 1} passes: '#{json[key][k]}'"
          puts "Completed line #{line}/#{lines}."
          puts ""
          line += 1
        end
      end
    end

    return json
  end

  def translate_single_phrase(phrase)
    langs = @@languages.keys.sample(@passes) << 'en'
    puts "Starting with phrase: '#{phrase}'"
    (@passes + 1).times do |i|
      from = i == 0 ? nil : langs[i - 1]
      phrase = translate_phrase(phrase, langs[i], from)
    end

    puts "Final output after #{@passes + 1} passes: '#{phrase}'"
    puts ""
  end

  private

  def translate_phrase(phrase, to, from)
    tries = 1
    loop do
      begin
          puts "Translating phrase '#{phrase}' into #{@@languages[to]}."
          return JSON.parse(@api.translate(phrase.gsub("\"", "\\\""), to, from: from)).first['translations'].first['text'].gsub("\\\"", "\"")
      rescue Exception => e
        puts e
        if tries == 5
          puts "Program cannot recover. Exiting now."
          exit 1
        else
          puts "Something went wrong on attempt #{tries}/5. Trying again in 10 seconds"
          tries += 1
          sleep 10
        end
      end
    end
  end
end

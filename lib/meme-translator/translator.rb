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
    json.keys.each do |key|
      json[key].keys.each do |k|
        langs = @@languages.keys.sample(@passes) << 'en'
        if json[key][k].start_with?("{")
          puts "Skipping phrase '#{json[key][k]}', as it isn't localized."
        else
          puts "Starting with phrase: '#{json[key][k]}'"
          (@passes + 1).times do |i|
            from = i == 0 ? nil : langs[i - 1]
            json[key][k] = translate_phrase(json[key][k], langs[i], from)
          end

          puts "Final output after #{@passes + 1} passes: '#{json[key][k]}'"
          puts ""
        end
      end
    end

    return json
  end

  private

  def translate_phrase(phrase, to, from)
    puts "Translating phrase '#{phrase}' into #{@@languages[to]}."
    return JSON.parse(@api.translate(phrase.gsub("\"", "\\\""), to, from: from)).first['translations'].first['text'].gsub("\\\"", "\"")
  end
end

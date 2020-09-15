require 'httparty'
require 'securerandom'

class Api
  BASE_URL = 'https://api.cognitive.microsofttranslator.com/'
  TYPE = 'application/json'

  def initialize(secret, location)
    @secret = secret
    @location = location
  end

  def translate(text, to, from: nil)
    if text.length > 10000
      raise 'Translation text limit exceeded!'
    end

    response = post_request('translate', parameters: "to=#{to}&from=#{from}", body: "[{\"Text\":\"#{text}\"}]")

    return response.body
  end

  private

  def post_request(endpoint, parameters: "", body: "")
    url = "#{BASE_URL}#{endpoint}?api-version=3.0&#{parameters}"

    headers = {}
    headers['Ocp-Apim-Subscription-Key'] = @secret
    headers['Ocp-Apim-Subscription-Region'] = @location if @location
    headers['X-ClientTraceId'] = SecureRandom.uuid
    headers['Content-Type'] = TYPE
    headers['Content-Length'] = body.length.to_s

    return HTTParty.post(url, headers: headers, body: body)
  end
end

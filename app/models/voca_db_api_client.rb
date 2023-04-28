class VocaDbApiClient
  def initialize
    @base_url = "https://vocadb.net/api"
  end
    
  def get_random_song
    song_id = rand(1..494001)
    uri = URI("#{@base_url}/songs/#{song_id}")
    response = Net::HTTP.get_response(uri)
    case response
    when Net::HTTPSuccess
      res = JSON.parse(response.body)
      
      search_query = URI.encode_www_form({search_query: "#{res['name']}+#{res['artistString']}"})
      {
        artist: res["artistString"],
        song_name: res["name"],
        url: "https://www.youtube.com/results?#{search_query}"
      }
    else
      {
        error_message: "曲の取得に失敗しました。\nもう一度実行してください。"
      }
    end
  end
end

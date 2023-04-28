class VocaDbApiClient
  # IDに相当する整数を生成する
  # 2023年4月22日までの楽曲をカバー
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
      {
        artist: res["artistString"],
        song_name: res["name"]
      }
    else
      puts "Error"
    end
  end
end

class VocaDbApiClient
    # IDに相当する整数を生成する
    # 2023年4月22日までの楽曲をカバー
    def initialize
      @base_url = "https://vocadb.net/api"
      @song_id = rand(1..494001)
    end
    
    def get_random_song
      uri = URI("#{@base_url}/songs/#{@song_id}")
      response = Net::HTTP.get_response(uri)
      case response
      when Net::HTTPSuccess
        res = JSON.parse(response.body)
        song_name = res["name"]
      else
        puts "Error"
      end
    end

    def get_random_artist
      uri = URI("#{@base_url}/songs/#{@song_id}")
      response = Net::HTTP.get_response(uri)
      case response
      when Net::HTTPSuccess
        res = JSON.parse(response.body)
        artist = res["artistString"]
      else
        puts "Error"
      end
    end
end

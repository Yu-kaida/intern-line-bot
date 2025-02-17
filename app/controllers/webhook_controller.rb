require 'line/bot'

class WebhookController < ApplicationController
  protect_from_forgery except: [:callback] # CSRF対策無効化

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      head 470
    end

    events = client.parse_events_from(body)
    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          if event.message['text'].include?('おすすめ教えて')
            voca_db_api_client = VocaDbApiClient.new
            vocalo_info = voca_db_api_client.get_random_song
            if vocalo_info.keys.include?(:error_message)
              message = text_message(vocalo_info[:error_message])
            else
              message = text_message("今回のおすすめはこちらです\n\n【アーティスト】\n#{vocalo_info[:artist]}\n【楽曲名】\n#{vocalo_info[:song_name]}\n【URL】\n#{vocalo_info[:url]}")
            end
          else
            message = text_message("「おすすめ教えて」と入力してください！")
          end
          client.reply_message(event['replyToken'], message)
        when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
          response = client.get_message_content(event.message['id'])
          tf = Tempfile.open("content")
          tf.write(response.body)
        end
      end
    }
    head :ok
  end

  private
  def text_message(text)
    {
      type: "text",
      text: 
    }
  end
end

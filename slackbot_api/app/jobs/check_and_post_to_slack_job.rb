class CheckAndPostToSlackJob < ApplicationJob
  queue_as :default

  PHRASES = [
      "girls",
      "stupid"
  ]

  def perform(*args)
    PHRASES.each do |phrase|
      if detect_hateful_speech(phrase, args[0]["text"])
        post_to_slack(args[0]["channel"])
        return
      end
    end
  end

  def detect_hateful_speech(phrase, text)
    text.include?(phrase)
  end

  def post_to_slack(channel)
    Slack.configure do |config|
      config.token = CONFIG
    end

    channel = "general" unless channel.present?
    client = Slack::Web::Client.new
    client.chat_postMessage(channel: channel, "text": "Using this type of phrasing is not in alignment with our organisation values.",
                            "attachments": [
                                {
                                    "text": "Please consider talking to Dialogbot to understand better our values around inclusivity and diversity.",
                                    "color": "#3AA3E3",
                                    "attachment_type": "default",
                                    "actions": [
                                        {
                                            "url": "",
                                            "text": "Speak with Dialogbot",
                                            "type": "button",
                                        }
                                    ]
                                }
                            ]
    )
  end

end
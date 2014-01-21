module Spree::Admin::SmsHelper

  module Sms48
    require 'net/http'
    require 'digest'

    def self.snd from, to, msg, status_url
      phone = get_phone to

      msg = msg.encode("cp1251")

      msg = URI::encode(msg);
      dlr = URI::encode(status_url);

      checksumm = md5("#{EMAIL}#{md5(PASS)}#{phone}");

      res = Net::HTTP.get('sms48.ru',
                          "/send_sms.php?login=#{EMAIL}&to=#{phone}&msg=#{msg}&from=#{from}&check2=#{checksumm}&dlr_url=#{dlr}")
      return res == "1"
    end

    def self.get_phone phone
      phone.gsub!(/[- ]/, '')
      "7#{/.*(\d{10})/.match(phone)[1]}"
    end

    def self.md5 text
      Digest::MD5.hexdigest(text)
    end

    def self.count
      check = md5("#{EMAIL}#{md5(PASS)}")
      Net::HTTP.get('sms48.ru', "/get_balance?login=#{EMAIL}&check=#{check}").to_i
    end
  end
end

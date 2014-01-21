class Spree::Admin::SmsController < Spree::Admin::ResourceController
  #before_filter :except => :index

  require 'net/http'

  helper_method :clone_object_url

  def index
    @sms = Sms.order("datetime(updated_at) DESC")
  end

  def new
#    @review = Spree::Review.new(:title => params[:title], :text => params[:text])
    @sms = Sms.new #(news_params);
    #@newsItem = News.new #(news_params);
  end

  def edit
    if (!params['id'].blank?)
      @sms = Sms.find_by(:id=>params['id'] )
    end
  end

  def update
    @sms = Sms.new( news_params )

    if @sms.save
      redirect_to action:"index"
    else
      render :action => "edit"
    end

  end

  def create

#    @newsItem = News.create(:title=>params[:title], :text => params[:text])
    @params = params
    @userapp = params["userapp"]["id"]
    @sms = Sms.new( news_params )
    result = sent_message_to_epochta_ru (@sms)
    if (result['result'])
      flash[:success] = Spree.t('status.successfully')
      if @sms.save
        #sent_message_to_sms_gt ( @sms )
        #redirect_to admin_sms_path
        redirect_to action:"index"
        return
      else
        render :action => "new"
      end
    elsif (result['error'])
      flash[:error] = Spree.t('status.error') + result['error'].to_s
      render :action => "new"
    end
  end

#  def show
#        session[:return_to] ||= request.referer
#        redirect_to( :action => :edit )
#      end

#  def clone
#    @new = @newsItem.duplicate
#
#    if @new.save
#      flash[:success] = Spree.t('notice_messages.product_cloned')
#    else
#      flash[:success] = Spree.t('notice_messages.product_not_cloned')
#    end
#
#    redirect_to edit_admin_news_url(@new)
#  end

  private

  def find_resource
    @newsItem = Sms.find_by(:id => params[:id])
  end

  def news_params
    params.require(:sms).permit(:from, :to, :text, :id)
  end

  def collection_url
    "/admin/sms"
  end

  def model_class
    "#{controller_name.classify}s".constantize
  end

#    def model_name
#      parent_data[:model_name].gsub('spree/', '')
#    end
##
#    def object_name
#      controller_name.singularize
#    end


#    def location_after_new
#      spree.admin_news_url(@newsItem)
#    end

  def location_after_save
    spree.edit_admin_news_url(@newsItem)
  end


  def clone_object_url resource
    clone_admin_news_url resource
  end

  def sent_message_to_epochta_ru( sms )
    sms_info = {}
    #require 'net/http'
    require 'digest'
    @sms_api_version = '3.0'
    @sms_key_private='81bd53c53bb31a3d7645b601a59cf371'
    @sms_key_public='a291987b4a7628aca2367c98a4f2da79'
    @URL_GAREWAY ='http://atompark.com/api/sms'
    @testMode='' #value: 1 (test mode: message not sent)
    @name = 'Test addressbook' # message in UTF-8
    @description = 'Test description' # message in UTF-8
    #@name = 'Test addressbook' # message in UTF-8
    #@description = 'Test description' # message in UTF-8

    address_book_control_sum_params = {"version"=>@sms_api_version, "action"=>"addAddressbook", "key"=>@sms_key_public, "name"=>@name, "description"=>@description, "test"=>@testMode}

    #Create Address Book
    json = create_address_book (address_book_control_sum_params)
    if (json['result'])
      idAddressBook = json['result']['addressbook_id'].to_s
    elsif (json['error'])
      error = json["error"] + ": "+ json['code']
      sms_info['error'] = error
      return sms_info
    end
    #End Create Address Book

    phones = sms.to.split(',')
    phones.each do |phone|
      #Add Phone to Address Book
      from = sms.from #"person_var"

      phone_control_sum_params = {"version"=>@sms_api_version, "action"=>"addPhoneToAddressBook", "key"=>@sms_key_public, "idAddressBook"=>idAddressBook, "phone"=>phone, "variables"=>from, "test"=>@testMode}
      json = add_phone_to_address_book (phone_control_sum_params)
      if (json["result"])
        phone_id = json["result"]["phone_id"].to_s
      elsif (json["error"])
        error = json["error"] + ": "+ json["code"]
        sms_info['error'] = error
        return sms_info
      end
      #End Add Phone to Address Book
    end


    #Check Balance
    #http://atompark.com/api/sms/3.0/getUserBalance?key=public_key&sum=control_sum&currency=USD
    @currency = "RUB" #"USD"
    balance_control_sum_params = {"version"=>@sms_api_version, "action"=>"getUserBalance", "key"=>@sms_key_public, "currency"=>@currency, "test"=>@testMode}
    json = check_balance (balance_control_sum_params)
    if (json["result"])
      balance_currency = json["result"]["balance_currency"]
      currency = json["result"]["currency"]
    elsif (json["error"])
      error = json["error"] + ": "+ json["code"]
      sms_info['error'] = error
      return sms_info
    end
    #End Check Balance

    #calculates price of campaign sending
    #http://atompark.com/api/sms/3.0/checkCampaignPrice?key=public_key&sum=control_sum&sender=Info&text=Testing%20SMS&list_id=1234
    @currency = "RUB" #"USD"
    @sender = sms.from #"testCompanyName" #Идентификатор отправителя
    @text = sms.text #"Проверим, хватает ли денег на запланированную рассылку. Тестируем отправку смс сообщения через ePochta SMS." #Текст сообщения
    @list_id = idAddressBook #Идентификатор адресной книги

    check_campaign_price_control_sum_params = {"version"=>@sms_api_version, "action"=>"checkCampaignPrice", "key"=>@sms_key_public, "sender"=>@sender, "text"=>@text, "list_id"=>@list_id, "test"=>@testMode}
    json = check_campaign_price (check_campaign_price_control_sum_params)
    if (json["result"])
      check_campaign_price = json["result"]["price"]
    elsif (json["error"])
      error = json["error"] + ": "+ json["code"]
      sms_info['error'] = error
      return sms_info
    end
    #End calculates price of campaign sending
    if (balance_currency.nil?)
      error = "balance not found"
      sms_info['error'] = error
      return sms_info
    elsif (check_campaign_price.nil?)
      error = "sms campaign price not found"
      sms_info['error'] = error
      return sms_info
    end

    if (balance_currency >= check_campaign_price)
      #А теперь по созданной адресной книге отправим рассылку
      datetime = '' #Для планировки рассылки на заданное время
      batch = '0' # (0 = разослать за одну итерацию) Для рассылки по частям – количество смс в 1й отправке
      batchinterval = '0' #(0 = разослать за одну итерацию) Для рассылки по частям – интервал между отправками
      sms_lifetime = '0' #Время жизни смс (0 = максимум)
      control_phone = '' #Контрольный номер телефона. Контроль качества. Задается в международном виде.
      #@userapp = 'adec' #Идентификатор приложения
      #http://atompark.com/api/sms/3.0/createCampaign?key=public_key&sum=control_sum&sender=Info&text=Testing%20SMS&list_id=1234&datetime=&batch=0&batchinterval=0&sms_lifetime=0&controlnumber=
      create_campaign_control_sum_params = {"version"=>@sms_api_version, "action"=>"createCampaign", "key"=>@sms_key_public, "sender"=>@sender, "text"=>@text, "list_id"=>@list_id, "datetime"=>datetime, "batch"=>batch, "batchinterval"=>batchinterval, "sms_lifetime"=>sms_lifetime, "controlnumber"=>control_phone, "test"=>@testMode}
      json = createc_campaign ( create_campaign_control_sum_params )
      if (json["result"])
        create_campaign_price = json["result"]["price"]
        create_campaign_id = json["result"]["id"]
        create_campaign_currency = json["result"]["currency"]
      elsif (json["error"])
        error = json["error"] + ": "+ json["code"]
        sms_info['error'] = error
        return sms_info
      end
    else
      sms_info['error'] = error
    end

    sms_info['result'] = "Done Successfully!"
    return sms_info
  end

  def calculate_control_sum params_unordered
    #require 'digest'
    #Hash[params_unordered.sort]
    control_sum = ''
    params_unordered.sort.map do |key, value|
      control_sum += value
    end
    control_sum += @sms_key_private
    control_sum_md5 = Digest::MD5.hexdigest(control_sum)
    return control_sum_md5
  end

  def create_address_book sms_params
    control_sum_md5 = calculate_control_sum (sms_params)
    encode_url = URI.encode("#{@URL_GAREWAY}/#{sms_params['version']}/#{sms_params['action']}?key=#{sms_params['key']}&sum=#{control_sum_md5}&name=#{sms_params['name']}&description=#{sms_params['description']}&test=#{sms_params['test']}")
    request_url = URI.parse(encode_url)
    result = Net::HTTP.get(request_url)
    json = JSON.parse(result) # json = ActiveSupport::JSON.decode(result)
    return json
  end

  def add_phone_to_address_book sms_params
    control_sum_md5 = calculate_control_sum (sms_params)
    #http://atompark.com/api/sms/3.0/addPhoneToAddressBook?key=public_key&sum=control_sum&idAddressBook=2432&phone=380638962555&variables=test
    encode_url = URI.encode("#{@URL_GAREWAY}/#{sms_params['version']}/#{sms_params['action']}?key=#{sms_params['key']}&sum=#{control_sum_md5}&idAddressBook=#{sms_params['idAddressBook']}&phone=#{sms_params['phone']}&variables=#{sms_params['variables']}&test=#{sms_params['test']}")
    request_url = URI.parse(encode_url)
    result = Net::HTTP.get(request_url)
    json = JSON.parse(result) # json = ActiveSupport::JSON.decode(result)
    return json
  end

  def check_balance sms_params
    control_sum_md5 = calculate_control_sum (sms_params)
    #http://atompark.com/api/sms/3.0/getUserBalance?key=public_key&sum=control_sum&currency=USD
    encode_url = URI.encode("#{@URL_GAREWAY}/#{sms_params['version']}/#{sms_params['action']}?key=#{sms_params['key']}&sum=#{control_sum_md5}&currency=#{sms_params['currency']}&test=#{sms_params['test']}")
    request_url = URI.parse(encode_url)
    result = Net::HTTP.get(request_url)
    json = JSON.parse(result) # json = ActiveSupport::JSON.decode(result)
    return json
  end

  def check_campaign_price sms_params
    control_sum_md5 = calculate_control_sum (sms_params)
    #http://atompark.com/api/sms/3.0/checkCampaignPrice?key=public_key&sum=control_sum&sender=Info&text=Testing%20SMS&list_id=1234
    encode_url = URI.encode("#{@URL_GAREWAY}/#{sms_params['version']}/#{sms_params['action']}?key=#{sms_params['key']}&sum=#{control_sum_md5}&sender=#{sms_params['sender']}&text=#{sms_params['text']}&list_id=#{sms_params['list_id']}&test=#{sms_params['test']}")
    request_url = URI.parse(encode_url)
    result = Net::HTTP.get(request_url)
    json = JSON.parse(result) # json = ActiveSupport::JSON.decode(result)
    return json
  end


  def createc_campaign sms_params
    control_sum_md5 = calculate_control_sum (sms_params)
    #http://atompark.com/api/sms/3.0/createCampaign?key=public_key&sum=control_sum&sender=Info&text=Testing%20SMS&list_id=1234                                                                                                          &datetime=&batch=0&batchinterval=0&sms_lifetime=0&controlnumber=
    encode_url = URI.encode("#{@URL_GAREWAY}/#{sms_params['version']}/#{sms_params['action']}?key=#{sms_params['key']}&sum=#{control_sum_md5}&sender=#{sms_params['sender']}&text=#{sms_params['text']}&list_id=#{sms_params['list_id']}&datetime=#{sms_params['datetime']}&batch=#{sms_params['batch']}&batchinterval=#{sms_params['batchinterval']}&sms_lifetime=#{sms_params['sms_lifetime']}&controlnumber=#{sms_params['controlnumber']}&test=#{sms_params['test']}&userapp=#{@userapp}")
    request_url = URI.parse(encode_url)
    result = Net::HTTP.get(request_url)
    json = JSON.parse(result) # json = ActiveSupport::JSON.decode(result)
    return json
  end

  def sent_message_to_sms_gt( sms )
    begin
      # problematic code
      gate_url = "http://78.46.32.24:1200"
      login = 'e27a813ff0849afc01e849105b7f7006'
      code = 'Jt66lX8iFd34Mg9sLVyrThx8SYyLonxd'
      to = sms.to
      from = sms.from # имя/название/номер отправителя (максимум 11 символов)
      msg = Rack::Utils.escape( sms.text ) #сообщение (UTF-8)
      encode_url = URI.encode("#{gate_url}/?login=#{login}&code=#{code}&to=#{to}&from=#{from}&msg=#{msg}")
      request_url = URI.parse(encode_url)
      result = Net::HTTP.get(request_url)
      json = JSON.parse(result) # json = ActiveSupport::JSON.decode(result)
      if (json['status'] == 'error' )
        flash[:error] = Spree.t('sms_not_sent') + "#{json['status']} #{json['meta']}"
      else
        flash[:notice] = Spree.t('sms_sent_ok') + "#{json['status']} #{json['meta']}"
      end
##      puts "#{json['status']} #{json['meta']}"
##      #rails method 2
##      require 'open-uri'
##      response = open('example.com').read
#
#      #redirect_to action:"index"
    rescue Errno::EHOSTUNREACH
      flash[:error] = Spree.t('sms_server_not_available') + ". " + Spree.t('sms_not_sent') + "."
        # log the error
      # let the User know
    rescue
      # handle other exceptions
      flash[:error] = Spree.t('unknown_error') + ". " + Spree.t('sms_not_sent') + "."
    end
  end
end



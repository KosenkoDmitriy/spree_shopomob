class Spree::Admin::ContactsController < Spree::Admin::ResourceController
  before_filter :load_contact_names

  def new
    @item = Spree::Contact.new
  end

  def edit
    @item = Spree::Contact.find(params[:id])
  end

  def update
    @item = Spree::Contact.find(params[:id])
    @item.attributes = contact_params
    if (params['contact']['key'].present? && params['contact']['value'].present? && params['contact']['contact_type'].present?)
      values = params['contact']['contact_type'].split(',')
      @item.contact_type = values[0]
      @item.prefix = values[1]
    end
    if @item.save
      if params[:images]
        params[:images].each { |image|
          @item.build_picture if @item.picture.blank?
          @item.picture.image = image
          @item.picture.save!
        }
      end
      redirect_to action:"index"
    else
      render :action => "new"
    end
  end

  def create
    @item = Spree::Contact.new ( contact_params )
    #if (params['key'].present? && params['value'].present? && params['prefix'].present? && params['contact_type'].present?)
    if (params['contact']['key'].present? && params['contact']['value'].present? && params['contact']['contact_type'].present?)
      values = params['contact']['contact_type'].split(',')
      @item.contact_type = values[0]
      @item.prefix = values[1]
      if @item.save
        if params[:images]
          params[:images].each { |image|
            @item.build_picture if @item.picture.blank?
            @item.picture.image = image
            @item.save!
          }
        end
        redirect_to action:"index"
      else
        render :action => "new"
      end
    else
      render :action => "new"
    end
  end

  private
  def model_class
    "Spree::#{controller_name.classify}".constantize
  end

  def contact_params
    params.require(:contact).permit(:key, :value, :prefix, :contact_type)
  end

  protected
  def load_contact_names
    @contact_types = [ ["phone for call", "tel:,call"], ["phone for sms", "tel:,sms"], ["email main", "mailto:, "], ["email second (cc)", "mailto:,cc"], ["skype", "skype:,call"], ["web url", "http://,url"] ]
    #<%= select_tag(:option, options_for_select([['All', 1], ['Co', 2], ['Bought', 3], ['View', 4], ['Top API', 5]], :selected => params[:option])) %>

    #@prefix_names = {"for phone for call"=>"call", "for sms" => "sms", "for skype" => "call", "for main email" => "", "for email (cc)" => "cc", "for web url" => "url" }
    #@event_names =  Spree::Activator.event_names.map { |name| [Spree.t("events.#{name}"), name] }
  end

end

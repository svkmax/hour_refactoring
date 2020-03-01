# frozen_string_literal: true

# in general luck of guards for each method in controller
# check required params for method and generate user message.
# params without daddy object(promo_message)
# rails way is require promo_message object in params
# so it will be promo_message[:date_from], promo_message[:date_to]
# promo_message[:body] etc. 
# But if this feature works, so we cant change interface without client side
class PromoMessagesController < ApplicationController
  # do not know what instance variable 'provider' for, 
  # looks like it is redundant

  def new
    promo_user_params
    @message = PromoMessage.new
    # if here is complex logic, I think it should be separate classes,
    # one with sql's other with params checker guard which describes whole controller methods.
    # This is a simples way with fat model, fat models can be fixed with
    # service objects or by separating models from business logic or
    # by presenter pattern or several more ways.
    # if we stay with extra method we hiding params which required for method
    users(date_from: params[:date_from], date_to: params[:date_to]).page(params[:page])
  end

  # I prefer dry/transaction for complex logic of saving
  # but for now, or in simplest way I think ith should be moved at least 
  # in model, or create service object, but again, service object should be generalized
  # to avoid situation with tons different service objects where each have own rules 
  # and own interface to use
  def create
    @message = PromoMessage.new(promo_message_params)
    # looks like paging here is redundant but, not sure maybe some 
    # client can use this variable, but it is local, magic monkey patching 
    users = users.page(params[:page])

#   what if fail?
    if @message.save && send_message(users.map(&:phone))
      redirect_to promo_messages_path, notice: 'Messages Sent Successfully!'
    else 
      render :new
    end
  end

  # due to REST we can not use extra words in endpoint naming
  #  so download_csv goes to GET csv
  # assume that it is rails and all lib folder is autoloaded 
  def csv
    # if we stay with extra method we hiding params which required for method
    promo_user_params
    users = users
    send_data Csv.contacts(users), filename: "promotion-users-#{Time.zone.today}.csv"
  end

  private
  
  # also should be moved in place where business logic is
  # as it is simplified example I assume that in real life there is connection between 
  # promo_message and user, so maybe it can go there(in PromoMessage class)
  def send_message(recipients)
    # not necessary optimization, just for fun
    # did not use it in real life
    promo_send_job = PromoMessagesSendJob.method(:perform_later)
    # if ruby 2.7 can use numbered params
    recipients.each { promo_send_job.call(@1)} 
  end

  # i think such methods should not be in controller
  # but just for minimum dry for now
  # if we have presenter or other layer of abstraction such methods goes there
  def users
    User.published_between_users(date_from: params[:date_from], 
                                 date_to: params[:date_to],
                                 published_ads_counts: 1)
  end

  def promo_message_params
    params.permit(:body, :date_from, :date_to)
  end

  def promo_user_params
    params.require(:date_from, :date_to)
  end
end

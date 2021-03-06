class ConversationsController < ApplicationController

  before_action :authenticate_user!

  def index
    @users = User.all
    @conversations = Conversation.all
  end

 # def new
 #    @conversation = current_user.conversations.build
 #  end

  def new
    @conversation = Conversation.new
    
  end

  def create
    if Conversation.between(params[:sender_id], params[:recipient_id]).present?
      @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    end
    redirect_to conversation_messages_path(@conversation)
  end


    def destroy
    #@conversation.destroy
    #ids = params[:ids].split(",")
    @conversation.messages = Conversation.where("id in (#{ids})").destroy

  end 

  private
    def conversation_params
      params.permit(:sender_id, :recipient_id)
    end

end


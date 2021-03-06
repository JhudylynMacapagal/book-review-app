class MessagesController < ApplicationController
  
  before_action :find_conversation

  def index
    @messages = @conversation.messages

    if @messages.length > 5
      @over_five = true
      @messages = @messages[-5..-1]
    end

    if params[:m]
      @over_five = false
      @messages = @conversation.messages
    end

    @message = @conversation.messages.new

  end

  def create
    @message = @conversation.messages.new(message_params)
    if @message.save
      redirect_to conversation_messages_path(@conversation)
    end
  end

  def new
    @message = @conversation.messages.new
  end
     

     def preload
      @conversation = Conversation.find(params[:conversation_id])
          respond_to do |format|
      format.html
      format.json{render json: @messages.to_json}
    end
       
     end

  private

    def message_params
      params.require(:message).permit(:body, :user_id)
    end

    def find_conversation
      @conversation = Conversation.find(params[:conversation_id])
    end
    
end


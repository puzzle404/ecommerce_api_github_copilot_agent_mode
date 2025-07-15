class ChatMessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @chat_messages = current_user.chat_messages.order(created_at: :asc)
    @chat_message = ChatMessage.new
  end

  def create
    @chat_message = current_user.chat_messages.create(chat_params)
    ai = AiClient.new
    @chat_message.update(answer: ai.chat_response(@chat_message.message, current_user))

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to chat_messages_path }
    end
  end

  private

  def chat_params
    params.require(:chat_message).permit(:message)
  end
end

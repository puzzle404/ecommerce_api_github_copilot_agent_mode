class AiClient
  def initialize
    @client = OpenAI::Client.new(access_token:)
  end

  def purchases_summary(user)
    purchases = user.purchases.includes(:product).order(purchase_date: :desc).limit(5)
    @list = purchases.map do |p|
      "- #{p.product.name} x#{p.quantity} $#{p.total_price}"
    end.join("\n")
    prompt = "Solo si el usuario tiene purchases, Resume las ultimas compras del usuario explicandole que son sus compras:\n" + @list

    response = @client.chat(parameters: {
      model: 'gpt-3.5-turbo',
      messages: [{ role: 'user', content: prompt }]
    })

    response.dig('choices', 0, 'message', 'content')
  end

  def access_token
    Rails.application.credentials.dig(:openai, :api_key)
  end

  def chat_response(message, user = nil)
    prompt = message.to_s
    if user
      info = "Usuario: email #{user.email}"
      info += ", direccion #{user.address}" if user.address.present?
      prompt = "#{prompt}\n\nInformacion del usuario: #{info}"
    end

    response = @client.chat(parameters: {
      model: 'gpt-3.5-turbo',
      messages: [{ role: 'user', content: prompt }]
    })
    response.dig('choices', 0, 'message', 'content')
  end
end

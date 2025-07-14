class AiClient
  def initialize
    @client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
  end

  def purchases_summary(user)
    purchases = user.purchases.includes(:product).order(purchase_date: :desc).limit(5)
    list = purchases.map do |p|
      "- #{p.product.name} x#{p.quantity} $#{p.total_price}"
    end.join("\n")

    prompt = "Resume las ultimas compras del usuario:\n" + list

    response = @client.chat(parameters: {
      model: 'gpt-3.5-turbo',
      messages: [{ role: 'user', content: prompt }]
    })

    response.dig('choices', 0, 'message', 'content')
  end
end

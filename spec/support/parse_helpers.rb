module Request
  module ParseHelpers
    def parsed_response
      @result ||= JSON.parse(response.body, symbolize_names: true)
    end
  end
end

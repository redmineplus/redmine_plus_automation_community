module AutomationNodes
  module Actions
    class WebRequestCodeError < StandardError; end

    class SendWebRequestService < ::AutomationNodes::Actions::EntityService
      def call
        begin
          response = send_request
          success(message: node_message(:success, url:, response: response))
        rescue WebRequestCodeError, StandardError => e
          failure(message: node_message(:failure_web_request, error: e.message))
        end
      end

      private

      def send_request
        method = node.method.upcase
        headers = prepare_headers
        body = prepare_body

        response = HTTParty.send(method.downcase, url, headers: headers, body: body)

        validate_response(response)
        response
      end

      def url
        @url ||= replace_tokens(node.url)
      end

      def prepare_headers
        return {} if node.headers.blank?
        headers = {}
        node.headers.split("\n").each do |header|
          key, value = header.split(":", 2).map(&:strip)
          headers[key] = replace_tokens(value) if key && value
        end
        headers
      end

      def prepare_body
        case node.body_type
        when "json"
          body = replace_tokens(node.body)
          JSON.parse(body).to_json
        when "issue_data"
          RedminePlusAutomation::IssueJsonHandler.new(entity).to_json
        else
          ""
        end
      end

      def validate_response(response)
        return if node.expected_response_codes.blank?

        expected_codes = node.expected_response_codes.split(",").map(&:strip).map(&:to_i)
        unless expected_codes.include?(response.code)
          raise WebRequestCodeError, "Unexpected response code: #{response.code}. Expected one of: #{expected_codes.join(', ')}"
        end
      end
    end
  end
end

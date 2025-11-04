module AutomationNodes
  module Conditions
    class QueryScope < AutomationNodes::Condition
      store :metadata, accessors: %i[filter operator values], coder: JSON

      def run!(_pipeline)
        success(message: node_message(:success))
      end
    end
  end
end

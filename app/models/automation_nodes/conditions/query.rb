module AutomationNodes
  module Conditions
    class Query < AutomationNodes::Condition
      store :metadata, accessors: %i[filter operator values], coder: JSON

      def run!(pipeline)
        ::AutomationNodes::Conditions::QueryService.call(pipeline, self)
      end
    end
  end
end

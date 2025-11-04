module AutomationNodes
  module Branches
    class ForEach < AutomationNodes::Branch
      store :metadata, accessors: %i[related_issues link_types], coder: JSON

      def run!(pipeline)
        AutomationNodes::Branches::ForEachService.call(pipeline, self)
      end
    end
  end
end

module AutomationNodes
  module Actions
    class CloneIssue < AutomationNodes::Action
      store :metadata, accessors: %i[issue], coder: JSON

      def run!(pipeline)
        ::AutomationNodes::Actions::CloneIssueService.call(pipeline, self)
      end
    end
  end
end

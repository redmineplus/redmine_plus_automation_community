module AutomationNodes
  module Actions
    class CreateIssue < AutomationNodes::Action
      store :metadata, accessors: %i[issue], coder: JSON

      def run!(pipeline)
        ::AutomationNodes::Actions::CreateIssueService.call(pipeline, self)
      end
    end
  end
end

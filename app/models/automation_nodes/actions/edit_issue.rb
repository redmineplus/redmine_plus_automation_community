module AutomationNodes
  module Actions
    class EditIssue < AutomationNodes::Action
      store :metadata, accessors: %i[issue], coder: JSON

      def run!(pipeline)
        ::AutomationNodes::Actions::EditIssueService.call(pipeline, self)
      end
    end
  end
end

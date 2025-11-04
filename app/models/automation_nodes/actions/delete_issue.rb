module AutomationNodes
  module Actions
    class DeleteIssue < AutomationNodes::Action
      def run!(pipeline)
        ::AutomationNodes::Actions::DeleteIssueService.call(pipeline, self)
      end
    end
  end
end

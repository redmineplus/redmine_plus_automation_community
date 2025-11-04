module AutomationNodes
  module Actions
    class CommentIssue < AutomationNodes::Action
      store :metadata, accessors: %i[comment], coder: JSON

      def run!(pipeline)
        ::AutomationNodes::Actions::CommentIssueService.call(pipeline, self)
      end
    end
  end
end

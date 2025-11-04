module AutomationNodes
  module Actions
    class EditComment < AutomationNodes::Action
      store :metadata, accessors: %i[comment_text target_comment], coder: JSON

      def run!(pipeline)
        ::AutomationNodes::Actions::EditCommentService.call(pipeline, self)
      end
    end
  end
end
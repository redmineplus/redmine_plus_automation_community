module AutomationNodes
  module Actions
    class DeleteAttachment < AutomationNodes::Action
      store :metadata, accessors: %i[delete_type regex], coder: JSON

      def run!(pipeline)
        ::AutomationNodes::Actions::DeleteAttachmentService.call(pipeline, self)
      end
    end
  end
end

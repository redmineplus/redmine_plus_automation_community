module AutomationNodes
  module Actions
    class CreateSubtask < AutomationNodes::Action
      store :metadata, accessors: %i[issue], coder: JSON

      def run!(pipeline)
        ::AutomationNodes::Actions::CreateSubtaskService.call(pipeline, self)
      end
    end
  end
end

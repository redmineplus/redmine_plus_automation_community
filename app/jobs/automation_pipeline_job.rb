class AutomationPipelineJob < ApplicationJob
  def self.schedule(trigger, entity, async: true)
    pipeline = trigger.automation_rule.automation_pipelines.scheduled.create!(entity: entity, author: User.current)
    pipeline.log(trigger, pipeline.entity_name)

    async ? perform_later(pipeline.id) : perform_now(pipeline.id)
  end

  def perform(pipeline_id)
    pipeline = AutomationPipeline.find_by(id: pipeline_id)
    return unless pipeline
    return unless pipeline.scheduled?

    User.current.as_automation_admin do
      pipeline.in_progress!
      pipeline.run!
      pipeline.complete! if pipeline.in_progress?
    end
  end
end

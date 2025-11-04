class AutomationBranchJob < ApplicationJob
  def self.schedule(main_pipeline, branch, entity, async: true)
    pipeline = branch.automation_rule.automation_pipelines.scheduled.create!(
      entity: entity,
      automation_branch: branch,
      author: main_pipeline.author
    )
    pipeline.log(branch, pipeline.entity_name)

    if async
      perform_later(pipeline.id)
    else
      perform_now(pipeline.id)
    end
  end

  def perform(pipeline_id)
    pipeline = AutomationPipeline.find_by(id: pipeline_id)
    return unless pipeline
    return unless pipeline.scheduled?
    return unless pipeline.automation_branch

    User.current.as_automation_admin do
      pipeline.in_progress!
      pipeline.run!
      pipeline.complete! if pipeline.in_progress?
    end
  end
end

module AutomationNodes
  class Branch < AutomationNode
    has_many :automation_pipelines, foreign_key: :automation_branch_id
  end
end

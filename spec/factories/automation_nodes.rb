FactoryBot.define do
  factory :automation_node do
    sequence(:name) { |n| "Node #{n}" }
    association :automation_rule
    uuid { SecureRandom.uuid }
    position { 1 }
  end

  factory :automation_branch, parent: :automation_node
  factory :branch_for_each, parent: :automation_branch, class: "AutomationNodes::Branches::ForEach"

  factory :automation_trigger, parent: :automation_node, class: "AutomationNodes::Trigger"
  factory :trigger_issue_comment_created, parent: :automation_node, class: "AutomationNodes::Triggers::IssueCommentCreated"
  factory :trigger_issue_comment_updated, parent: :automation_node, class: "AutomationNodes::Triggers::IssueCommentUpdated"
  factory :trigger_issue_comment_deleted, parent: :automation_node, class: "AutomationNodes::Triggers::IssueCommentDeleted"
  factory :trigger_value_changed, parent: :automation_node, class: "AutomationNodes::Triggers::ValueChanged"

  factory :automation_action, parent: :automation_node
  factory :action_clone_issue, parent: :automation_action, class: "AutomationNodes::Actions::CloneIssue"
  factory :action_comment_issue, parent: :automation_action, class: "AutomationNodes::Actions::CommentIssue"
  factory :action_create_issue, parent: :automation_action, class: "AutomationNodes::Actions::CreateIssue"
  factory :action_create_subtask, parent: :automation_action, class: "AutomationNodes::Actions::CreateSubtask"
  factory :action_edit_comment, parent: :automation_action, class: "AutomationNodes::Actions::EditComment"
  factory :action_edit_issue, parent: :automation_action, class: "AutomationNodes::Actions::EditIssue"
end

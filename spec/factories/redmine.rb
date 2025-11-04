FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    description { "Description of #{name}" }
    identifier { name.downcase.gsub(" ", "_") }
    trackers { [Tracker.first || create(:tracker)] }
    time_entry_activities { [TimeEntryActivity.default || create(:time_entry_activity, is_default: true)] }
  end

  factory :issue do
    sequence(:subject) { |n| "Issue #{n}" }
    description { "Description of #{subject}" }
    project
    author { User.first || create(:user) }
    tracker { project.trackers.first }
    priority { IssuePriority.default || create(:issue_priority, is_default: true) }
    status { tracker.default_status }
  end

  factory :tracker do
    sequence(:name) { |n| "Tracker #{n}" }
    default_status { IssueStatus.first || create(:issue_status) }
  end

  factory :issue_status do
    sequence(:name) { |n| "Status #{n}" }
  end

  factory :issue_priority do
    sequence(:name) { |n| "Priority #{n}" }
  end

  factory :issue_category do
    sequence(:name) { |n| "Category #{n}" }
    project
  end

  factory :issue_relation do
    issue_from { create(:issue) }
    issue_to { create(:issue, project: issue_from.project) }
    relation_type { IssueRelation::TYPE_RELATES }
  end

  factory :version do
    sequence(:name) { |n| "Version #{n}" }
    project
    effective_date { Date.today + 1.month }
  end

  factory :user do
    sequence(:login) { |n| "user#{n}" }
    firstname { "Firstname" }
    lastname { "Lastname" }
    mail { "#{ login }@example.com" }
    password { "password" }
    admin { false }
  end

  factory :group, class: "Group" do
    sequence(:lastname) { |n| "Group #{n}" }
    sequence(:firstname) { |n| "Group #{n}" }
  end

  factory :member do
    user
    project
    roles { [create(:role)] }
  end

  factory :role do
    sequence(:name) { |n| "Role #{n}" }
    position { 1 }
    assignable { true }
    builtin { false }
    permissions { [:view_issues, :add_issues, :add_issue_notes, :save_queries, :view_gantt, :view_calendar,
                   :view_time_entries, :view_news, :comment_news, :view_documents, :view_wiki_pages, :view_wiki_edits,
                   :view_messages, :add_messages, :view_files, :browse_repository, :view_changesets,
                   :view_automation_rules, :manage_automation_rules] }
    issues_visibility { "default" }
    users_visibility { "all" }
    time_entries_visibility { "all" }
    automation_rules_visibility { "all" }
    all_roles_managed { true }
    settings { {} }
    default_time_entry_activity_id { nil }
  end

  factory :member_role do
    member { create(:member) }
    role { create(:role) }
  end

  factory :custom_field do
    sequence(:name) { |n| "Custom Field #{n}" }
    field_format { "text" }
    is_required { false }
    is_for_all { true }
    is_filter { true }
    editable { true }
    visible { true }
    format_store { {"user_role"=>[], "edit_tag_style"=>""} }
  end

  factory :issue_custom_field, parent: :custom_field, class: "IssueCustomField"
  factory :issue_priority_custom_field, parent: :custom_field, class: "IssuePriorityCustomField"
  factory :user_custom_field, parent: :custom_field, class: "UserCustomField"
  factory :project_custom_field, parent: :custom_field, class: "ProjectCustomField"
  factory :version_custom_field, parent: :custom_field, class: "VersionCustomField"

  factory :enumeration do
    sequence(:name) { |n| "Enumeration #{n}" }
    active { true }
  end

  factory :time_entry_activity, parent: :enumeration, class: "TimeEntryActivity"

  factory :time_entry do
    issue
    project { issue.project }
    activity { project.activities.first }
    association(:author, factory: :user)
    user { author }
    hours { 1 }
    spent_on { Date.today }
  end

  factory :journal_detail do
    journal
    property { "attr" }
    prop_key { "subject" }
    old_value { "old subject" }
    value { "new subject" }
  end

  factory :journal do
    user
    notes { "Some notes" }
    notify { false }

    after(:create) do |journal, evaluator|
      journal.details << create(:journal_detail, journal: journal)
    end
  end

  factory :issue_journal, parent: :journal do
    association :journalized, factory: :issue
  end

  factory :project_journal, parent: :journal do
    association :journalized, factory: :project
  end
end

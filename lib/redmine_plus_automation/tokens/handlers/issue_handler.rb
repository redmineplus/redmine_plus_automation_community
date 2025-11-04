module RedminePlusAutomation
  module Tokens
    module Handlers
      class IssueHandler < BaseHandler
        allowlist_attribute :id, :subject, :description, :estimated_hours, :is_private, :done_ratio,
                            :start_date, :due_date, :created_on, :updated_on, :closed_on
        allowlist_custom_method :url
        allowlist_association project: "Project", author: "User", assigned_to: "User", parent: "Issue", root: "Issue",
                              status: "IssueStatus", priority: "IssuePriority", category: "IssueCategory",
                              tracker: "Tracker", fixed_version: "Version"
        allowlist_custom_association first_comment: "Journal", last_comment: "Journal"

        def self.custom_field_klass
          @custom_field_klass ||= IssueCustomField
        end

        def first_comment
          object.journals.where.not(notes: "").first
        end

        def last_comment
          object.journals.where.not(notes: "").last
        end
      end
    end
  end
end

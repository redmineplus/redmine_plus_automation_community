module RedminePlusAutomation
  module AutomationTriggers
    class MonitoredFields
      include Redmine::I18n

      def self.all
        task_native_fields + custom_fields
      end

      def self.task_native_fields
        [
          {
            id: 'tracker_id',
            name: ::I18n.t('field_tracker')
          },
          {
            id: 'project_id',
            name: ::I18n.t('field_project')
          },
          {
            id: 'subject',
            name: ::I18n.t('field_subject')
          },
          {
            id: 'description',
            name: ::I18n.t('field_description')
          },
          {
            id: 'status_id',
            name: ::I18n.t('field_status')
          },
          {
            id: 'priority_id',
            name: ::I18n.t('field_priority')
          },
          {
            id: 'assigned_to_id',
            name: ::I18n.t('field_assigned_to')
          },
          {
            id: 'fixed_version_id',
            name: ::I18n.t('field_fixed_version')
          },
          {
            id: 'start_date',
            name: ::I18n.t('field_start_date')
          },
          {
            id: 'due_date',
            name: ::I18n.t('field_due_date')
          },
          {
            id: 'estimated_hours',
            name: ::I18n.t('field_estimated_hours')
          },
          {
            id: 'closed_on',
            name: ::I18n.t('field_closed_on')
          },
          {
            id: 'category_id',
            name: ::I18n.t('field_category')
          }
        ].map { |field| field.merge(group: ::I18n.t('label_issue_plural')) }
      end

      def self.custom_fields
        IssueCustomField.all.map do |cf|
          {
            id: "issue.cf_#{cf.id}",
            name: cf.name,
            group: ::I18n.t('label_custom_field_plural')
          }
        end
      end
    end
  end
end
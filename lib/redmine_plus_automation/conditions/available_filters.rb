module RedminePlusAutomation
  module Conditions
    class AvailableFilters
      include Redmine::I18n

      def self.all
        query = IssueQuery.new
        query.available_filters.map do |field, field_options|
          if /^cf_\d+\./.match?(field)
            group = (field_options[:through] || field_options[:field]).try(:name)
          elsif field =~ /^(.+)\./
            # association filters
            group = "field_#{$1}".to_sym
          elsif field_options[:type] == :relation
            group = :label_relations
          elsif field_options[:type] == :tree
            group = query.is_a?(IssueQuery) ? :label_relations : nil
          elsif %w(member_of_group assigned_to_role).include?(field)
            group = :field_assigned_to
          elsif field_options[:type] == :date_past || field_options[:type] == :date
            group = :label_date
          elsif %w(estimated_hours spent_time).include?(field)
            group = :label_time_tracking
          elsif %w(attachment attachment_description).include?(field)
            group = :label_attachment
          elsif [:string, :text, :search].include?(field_options[:type])
            group = :label_string
          end
          
          if group
            { group: ::I18n.t(group), value: field, label: field_options[:name], type: field_options[:type] }
          else
            { value: field, label: field_options[:name], type: field_options[:type] }
          end
        end
      end
    end
  end
end

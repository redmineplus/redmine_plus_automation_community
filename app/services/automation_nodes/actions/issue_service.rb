module AutomationNodes
  module Actions
    class IssueService < ::AutomationNodes::Actions::EntityService

      private

      def prepare_action_entity
        issue = super
        issue.safe_attributes = native_fields_attrs
        issue.custom_field_values = custom_fields_attrs
        issue
      end

      # @note order is important!
      def token_fields
        %w[project_id tracker_id status_id priority_id author_id assigned_to_id fixed_version_id is_private]
      end

      def node_metadata
        return @node_metadata if @node_metadata

        @node_metadata = {}
        issue_data = node.metadata['issue'] || {}
        (token_fields & issue_data.keys).each { |k| @node_metadata[k] = issue_data[k] }
        issue_data.each { |k, v| @node_metadata[k] ||= v }
        @node_metadata
      end

      def issue_metadata
        @issue_metadata ||= node_metadata.each_with_object({}) do |(key, value), obj|
          value = value.is_a?(Hash) ? value["value"] : value
          obj[key] = token_fields.include?(key) ? resolve_token(value) : replace_tokens(value)
        end
      end

      def native_fields_attrs
        issue_metadata.select { |key, _| key !~ /^cf_/ }
      end

      def custom_fields_attrs
        issue_metadata.select { |key, _| key =~ /^cf_/ }.transform_keys { |key| key.gsub("cf_", "") }
      end

      def issue_author_id
        issue_metadata.dig("author_id") || automation_user.id
      end
    end
  end
end

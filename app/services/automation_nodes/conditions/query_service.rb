module AutomationNodes
  module Conditions
    class QueryService < ::AutomationService
      def call
        valid? || failure(message: node_message(:failure_config))
        filter_exists? || failure(message: node_message(:failure, filter_name: filter_name))
        condition_satisfied? || skipped(message: node_message(:skipped))

        success(message: node_message(:success))
      end

      private

      def valid?
        filter_name.present? && filter_operator.present?
      end

      def filter_exists?
        query.available_filters.has_key?(filter_name)
      end

      def condition_satisfied?
        query.base_scope.exists?(id: entity.id)
      end

      def filter_name
        node.filter[:value]
      end

      def filter_operator
        node.operator[:value]
      end

      def filter_values
        node.values.map { |v| v[:value] }
      end

      # @todo should set project?
      def query
        return @query if @query

        @query = IssueQuery.new
        @query.name = "-" # @note name should not be blank in order for #statement to be applied
        @query.filters = {}
        @query.group_by = nil
        @query.column_names = nil
        @query.sort_criteria = nil
        @query.add_filter(filter_name, filter_operator, filter_values)
        @query
      end
    end
  end
end

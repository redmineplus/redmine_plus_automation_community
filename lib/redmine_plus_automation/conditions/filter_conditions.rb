module RedminePlusAutomation
  module Conditions
    class FilterConditions
      attr_reader :filter

      AVAILABLE_OPERATORS = [
        '*~', # string, text, search,
        '<=', # date, date_past, integer, float,
        'lm', # date, date_past,
        '=', # list, list_with_history, list_status, list_optional, list_optional_with_history, list_subprojects, date, date_past, string, integer, float, relation, tree,
        'o', # list_status,
        '=p', # relation,
        '!o', # relation,
        '$', # string, text,
        'c', # list_status,
        '!*', # list_optional, list_optional_with_history, list_subprojects, date, date_past, string, text, integer, float, relation, tree,
        'nw', # date,
        '*o', # relation,
        '><t-', # date, date_past,
        't+', # date,
        '^', # string, text,
        '>t+', # date,
        '*', # list_status, list_optional, list_optional_with_history, list_subprojects, date, date_past, string, text, integer, float, relation, tree,
        'm', # date, date_past,
        '<t-', # date, date_past,
        't-', # date, date_past,
        '!', # list, list_with_history, list_status, list_optional, list_optional_with_history, list_subprojects, string, relation,
        '!ev', # list_with_history, list_status, list_optional_with_history,
        '><', # date, date_past, integer, float,
        '>=', # date, date_past, integer, float,
        '~', # string, text, search, tree,
        '!p', # relation,
        'y', # date, date_past,
        'cf', # list_with_history, list_status, list_optional_with_history,
        '!~', # string, text, search,
        'ld', # date, date_past,
        '=!p', # relation,
        'ev', # list_with_history, list_status, list_optional_with_history,
        'nm', # date,
        '><t+', # date,
        'w', # date, date_past,
        'l2w', # date, date_past,
        '>t-', # date, date_past,
        '<t+', # date,
        'nd', # date,
        'lw', # date, date_past,
        't' # date, date_past
      ].freeze

      def initialize(filter)
        @filter = filter.to_sym
      end

      def conditions
        operators = IssueQuery.operators_by_filter_type[filter.to_sym].map do |operator|
          { value: operator, label: IssueQuery.operators_labels[operator] }
        end

        operators.select { |i| AVAILABLE_OPERATORS.include?(i[:value]) }
      end
    end
  end
end

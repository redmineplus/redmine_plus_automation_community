module RedminePlusAutomation
  module Tokens
    module Processor
      # Main method to replace tokens in a given text based on a context.
      # @param text [String] The string containing tokens like {{issue.subject}}.
      # @param context [Hash] A hash of objects, e.g., { issue: @issue, project: @project }.
      # @return [String] The processed string with valid tokens replaced.
      def self.replace(text, context = {})
        context[:initiator] ||= User.current
        context[:now] ||= Time.current
        context[:today] ||= Date.today

        text.to_s.gsub(/{{\s*([\w\.\(\)\d]+)\s*}}/) do |match|
          token_string = $1
          resolve_token(token_string, context) || match
        end
      end

      # Tries to resolve a single token string (e.g., "issue.project.name").
      # @param token_string [String] The content of the token, e.g., "issue.project.id" or "now.plus_days(30)"
      # @param context [Hash] The object context.
      # @return [String, Object, nil] The resolved value or nil.
      def self.resolve_token(token_string, context)
        return nil if token_string.blank?

        # Regex to handle simple attributes and method calls like "today.plus_days(30)"
        parts = token_string.to_s.scan(/([\w]+)(?:\((\d+)\))?/).map { |part, arg| { name: part, arg: arg } }

        entity_name = parts.first[:name].to_sym
        current_object = context[entity_name]
        return nil unless current_object

        # Process each part of the token chain (e.g., issue -> author -> cf_4)
        parts.each_with_index do |part_info, index|
          return nil unless current_object

          # For the first part, the object is already set from the context.
          next if index == 0

          handler_class = find_handler_for(current_object)
          return nil unless handler_class

          handler = handler_class.new(current_object)
          part_name = part_info[:name].to_sym
          arg = part_info[:arg]

          current_object = handler.value_for(part_name, arg)
        end

        # Format the final value
        # format_value(current_object)
        current_object
      end

      # Finds the appropriate handler for a given object by checking its class and ancestors.
      def self.find_handler_for(object)
        # This allows for more flexible mapping (e.g., a User object can be handled by UserHandler)
        # It also allows other plugins to register handlers for core classes.
        Registry.handlers.each do |key, handler|
          object_class_name = object.is_a?(String) ? object : object.class.name
          if handler.name.include?(object_class_name)
            return handler
          end
        end

        nil
      end

      # @todo formatting
      # Formats the final resolved value into a string.
      def self.format_value(value)
        return '' if value.nil?
        return I18n.l(value.to_date) if value.is_a?(Date) || value.is_a?(Time)
        value.to_s
      end
    end
  end
end

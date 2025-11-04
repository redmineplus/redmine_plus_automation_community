module AutomationNodes
  module Triggers
    class ValueChanged < AutomationNodes::Trigger
      store :metadata, accessors: %i[change_type monitored_fields], coder: JSON

      def triggered?
        all_monitored_fields.empty? || all_monitored_fields.any? { |field| field_triggered?(field) }
      end

      private

      def all_monitored_fields
        @all_monitored_fields ||= monitored_fields.map { |field| field["value"] }.compact_blank
      end

      def native_field_triggered?(field)
        return if entity.saved_changes[field].blank?

        case change_type
        when "any_change"
          entity.saved_changes[field].present?
        when "value_added"
          entity.saved_changes[field].first.blank?
        when "value_deleted"
          entity.saved_changes[field].last.blank?
        else
          false
        end
      end

      def custom_field_triggered?(field)
        return unless (cfv = entity.custom_field_values.detect { |cfv| cfv.custom_field.id = field })

        case change_type
        when "any_change"
          cfv.value_was != cfv.value
        when "value_added"
          cfv.value_was.blank? && cfv.value.present?
        when "value_deleted"
          cfv.value_was.present? && cfv.value.blank?
        else
          false
        end
      end

      def field_triggered?(field)
        if field.start_with?("cf_")
          custom_field_triggered?(field.gsub("cf_", "").to_i)
        else
          native_field_triggered?(field)
        end
      end
    end
  end
end

module RedminePlusAutomation
  module Tokens
    module Handlers
      class BaseHandler
        include Redmine::I18n

        attr_reader :object

        def initialize(object)
          @object = object
        end

        # Retrieves a value for a given token part (attribute or method).
        # It checks against allowlists before attempting to access the data.
        # @param part [Symbol, String] The attribute or method name.
        # @param arg The argument for custom methods with arguments
        # @return [Object, nil] The resulting value or nil if not allowlisted/found.
        def value_for(part, arg = nil)
          part_sym = part.to_sym

          if (match = part.to_s.match(/^cf_(\d+)$/))
            if object.respond_to?(:custom_value_for)
              cf_id = match[1].to_i
              value_object = object.custom_value_for(cf_id)
              return value_object&.value
            end

            return nil # The object does not support custom fields.
          end

          if (self.class.allowlisted_attributes.include?(part_sym) || self.class.allowlisted_associations.keys.include?(part_sym)) && object.respond_to?(part_sym)
            return object.public_send(part_sym)
          end

          if (self.class.allowlisted_custom_methods.include?(part_sym) || self.class.allowlisted_custom_associations.include?(part_sym)) && self.respond_to?(part_sym)
            return self.public_send(part_sym)
          end

          if self.class.allowlisted_argument_custom_methods.include?(part_sym) && self.respond_to?(part_sym)
            # @todo handle errors
            return self.public_send(part_sym, arg)
          end

          nil # Not allowlisted or does not exist
        end

        def url
          Rails.application.routes.url_helpers.polymorphic_url(object, host: Setting.host_name, protocol: Setting.protocol)
        end

        # --- allowlisting Class Methods ---
        # This API allows handlers to define exactly which tokens are safe to process.
        class << self
          def allowlisted_attributes
            @allowlisted_attributes ||= []
          end

          def allowlist_attribute(*attrs)
            attrs.each { |attr| allowlisted_attributes << attr unless allowlisted_attributes.include?(attr) }
          end

          def allowlisted_associations
            @allowlisted_associations ||= {}
          end

          def allowlist_association(assocs)
            assocs.each { |assoc, klass| allowlisted_associations[assoc] ||= klass }
          end

          def allowlisted_custom_associations
            @allowlisted_custom_associations ||= {}
          end

          def allowlist_custom_association(assocs)
            assocs.each { |assoc, klass| allowlisted_custom_associations[assoc] ||= klass }
          end

          def allowlisted_custom_methods
            @allowlisted_custom_methods ||= []
          end

          def allowlist_custom_method(*methods)
            methods.each { |method| allowlisted_custom_methods << method unless allowlisted_custom_methods.include?(method) }
          end

          def allowlisted_argument_custom_methods
            @allowlisted_argument_custom_methods ||= []
          end

          def allowlist_argument_custom_method(*methods)
            methods.each { |method| allowlisted_argument_custom_methods << method unless allowlisted_argument_custom_methods.include?(method) }
          end

          def custom_field_klass
            nil
          end

          def token_key
            @token_key ||= RedminePlusAutomation::Tokens::Registry.handlers.invert[self]
          end

          def prepare_token(id:, value: id, description: nil, community_edition: false)
            { id: id, value: "{{#{value}}}", community_edition: community_edition, description: description || l("automation_tokens.#{id}") }
          end

          def tokens(key = token_key, associations: true, community_edition: false)
            tokens = []
            allowlisted_attributes.each { |attr| tokens << prepare_token(id: "#{key}.#{attr}", community_edition: community_edition) }
            allowlisted_custom_methods.each { |attr| tokens << prepare_token(id: "#{key}.#{attr}") }
            allowlisted_argument_custom_methods.each { |attr| tokens << prepare_token(id: "#{key}.#{attr}", value: "#{key}.#{attr}(X)") }

            if custom_field_klass
              custom_field_klass.visible.sorted.map do |cf|
                tokens << prepare_token(id: "#{key}.cf_#{cf.id}", description: "(#{cf.name}) custom field '#{cf.field_format}' format")
              end
            end

            if associations
              allowlisted_associations.each do |assoc, klass|
                handler = RedminePlusAutomation::Tokens::Processor.find_handler_for(klass)
                next unless handler

                assoc_tokens = handler.tokens("#{key}.#{assoc}", associations: false)
                tokens.concat(assoc_tokens)
              end

              allowlisted_custom_associations.each do |assoc, klass|
                handler = RedminePlusAutomation::Tokens::Processor.find_handler_for(klass)
                next unless handler

                assoc_tokens = handler.tokens("#{key}.#{assoc}", associations: false)
                tokens.concat(assoc_tokens)
              end
            end

            tokens
          end
        end
      end
    end
  end
end

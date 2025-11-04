module RedminePlusAutomation
  module Tokens
    module Handlers
      class DateHandler < BaseHandler
        allowlist_attribute :day, :year, :month
        allowlist_argument_custom_method :plus_days, :plus_weeks, :plus_months, :plus_years,
                                         :minus_days, :minus_weeks, :minus_months, :minus_years

        class << self
          def root_token
            prepare_token(id: token_key, description: l("automation_tokens.#{token_key}.#{token_key}"))
          end

          def tokens(key = token_key, associations: true)
            [root_token] + super
          end
        end

        def plus_days(count)
          object + count.to_i.days
        end

        def plus_weeks(count)
          object + count.to_i.weeks
        end

        def plus_months(count)
          object + count.to_i.months
        end

        def plus_years(count)
          object + count.to_i.years
        end

        def minus_days(count)
          object - count.to_i.days
        end

        def minus_weeks(count)
          object - count.to_i.weeks
        end

        def minus_months(count)
          object - count.to_i.months
        end

        def minus_years(count)
          object - count.to_i.years
        end
      end
    end
  end
end

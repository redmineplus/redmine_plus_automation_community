module RedminePlusAutomation
  module Tokens
    module Handlers
      class DateTimeHandler < DateHandler
        allowlist_attribute :day, :month, :year, :sec, :min, :hour
        allowlist_argument_custom_method :plus_days, :plus_weeks, :plus_months, :plus_years,
                                         :minus_days, :minus_weeks, :minus_months, :minus_years
      end
    end
  end
end

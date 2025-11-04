require_relative "../../../spec_helper"

describe RedminePlusAutomation::Tokens::Handlers::DateTimeHandler do
  describe "#value_for" do
    let(:object) { Time.current }
    let(:handler) { described_class.new(object) }
    let(:argument) { 5 }

    it_behaves_like "automation token", "day", -> { object.day }
    it_behaves_like "automation token", "year", -> { object.year }
    it_behaves_like "automation token", "month", -> { object.month }
    it_behaves_like "automation token", "sec", -> { object.sec }
    it_behaves_like "automation token", "min", -> { object.min }
    it_behaves_like "automation token", "hour", -> { object.hour }
    it_behaves_like "automation token with argument", "plus_days", -> { object + argument.days }
    it_behaves_like "automation token with argument", "plus_weeks", -> { object + argument.weeks }
    it_behaves_like "automation token with argument", "plus_months", -> { object + argument.months }
    it_behaves_like "automation token with argument", "plus_years", -> { object + argument.years }
    it_behaves_like "automation token with argument", "minus_days", -> { object - argument.days }
    it_behaves_like "automation token with argument", "minus_weeks", -> { object - argument.weeks }
    it_behaves_like "automation token with argument", "minus_months", -> { object - argument.months }
    it_behaves_like "automation token with argument", "minus_years", -> { object - argument.years }
  end
end

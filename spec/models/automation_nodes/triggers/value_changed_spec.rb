require_relative '../../../spec_helper'

describe AutomationNodes::Triggers::ValueChanged, type: :model do
  describe "#triggered?" do
    let(:project) { FactoryBot.create(:project) }
    let(:custom_field) { FactoryBot.create(:issue_custom_field, projects: [project], trackers: project.trackers, field_format: "string") }
    let(:custom_field_value) { nil }
    let(:issue) { FactoryBot.create(:issue, project:, custom_field_values: { custom_field.id => custom_field_value }) }
    let(:monitored_fields) { [] }
    let(:metadata) { { change_type:, monitored_fields: } }
    let!(:trigger) { FactoryBot.create(:trigger_value_changed, metadata:) }

    subject { trigger.triggered? }

    before { trigger.entity = issue.reload }

    context "when changed_type is any_change" do
      let(:change_type) { "any_change" }

      context "when monitored_fields is empty" do
        it { is_expected.to be true }
      end

      context "when monitored_fields contains native_field" do
        let(:monitored_fields) { [{ "value" => "description" }] }

        context "when description is changed" do
          before { allow(issue).to receive(:saved_changes).and_return({ "description" => %w[old new] }) }
          it { is_expected.to be true }
        end

        context "when description is not changed" do
          it { is_expected.to be false }
        end
      end

      context "when monitored_fields contains custom_field" do
        let(:monitored_fields) { [{ "value" => "cf_#{custom_field.id}" }] }

        context "when custom field value is changed" do
          before { issue.custom_field_values = { custom_field.id => "new" } }
          it { is_expected.to be true }
        end

        context "when custom field value is not changed" do
          it { is_expected.to be false }
        end
      end
    end

    context "when changed_type is value_added" do
      let(:change_type) { "value_added" }

      context "when monitored_fields is empty" do
        it { is_expected.to be true }
      end

      context "when monitored_fields contains native_field" do
        let(:monitored_fields) { [{ "value" => "description" }] }

        context "when description is added" do
          before { allow(issue).to receive(:saved_changes).and_return({ "description" => [nil, "new"] }) }
          it { is_expected.to be true }
        end

        context "when description is changed" do
          before { allow(issue).to receive(:saved_changes).and_return({ "description" => %w[old new] }) }
          it { is_expected.to be false }
        end
      end

      context "when monitored_fields contains custom_field" do
        let(:monitored_fields) { [{ "value" => "cf_#{custom_field.id}" }] }

        context "when description is added" do
          before { issue.custom_field_values = { custom_field.id => "new" } }
          it { is_expected.to be true }
        end

        context "when description is changed" do
          let(:custom_field_value) { "old" }

          before { issue.custom_field_values = { custom_field.id => "new" } }
          it { is_expected.to be false }
        end
      end
    end

    context "when changed_type is value_deleted" do
      let(:change_type) { "value_deleted" }

      context "when monitored_fields is empty" do
        it { is_expected.to be true }
      end

      context "when monitored_fields contains native_field" do
        let(:monitored_fields) { [{ "value" => "description" }] }

        context "when description is deleted" do
          before { allow(issue).to receive(:saved_changes).and_return({ "description" => ["new", nil] }) }
          it { is_expected.to be true }
        end

        context "when description is changed" do
          before { allow(issue).to receive(:saved_changes).and_return({ "description" => %w[old new] }) }
          it { is_expected.to be false }
        end
      end

      context "when monitored_fields contains custom_field" do
        let(:monitored_fields) { [{ "value" => "cf_#{custom_field.id}" }] }

        context "when description is deleted" do
          let(:custom_field_value) { "old" }

          before { issue.custom_field_values = { custom_field.id => "" } }
          it { is_expected.to be true }
        end

        context "when description is changed" do
          let(:custom_field_value) { "old" }

          before { issue.custom_field_values = { custom_field.id => "new" } }
          it { is_expected.to be false }
        end
      end
    end
  end
end

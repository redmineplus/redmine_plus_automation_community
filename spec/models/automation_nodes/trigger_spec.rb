require_relative "../../spec_helper"

describe AutomationNodes::Trigger, type: :model do
  describe ".trigger_scope" do
    let(:global_automation_rule) { FactoryBot.create(:automation_rule) }
    let!(:global_trigger) { FactoryBot.create(:automation_trigger, automation_rule: global_automation_rule) }

    let(:disabled_automation_rule) { FactoryBot.create(:automation_rule, enabled: false) }
    let!(:disabled_trigger) { FactoryBot.create(:automation_trigger, automation_rule: disabled_automation_rule) }

    let(:project_1) { FactoryBot.create(:project) }
    let(:project_1_automation_rule) { FactoryBot.create(:automation_rule, projects: [project_1], is_for_all: false) }
    let!(:project_1_trigger) { FactoryBot.create(:automation_trigger, automation_rule: project_1_automation_rule) }

    let(:project_2) { FactoryBot.create(:project) }
    let(:project_2_automation_rule) { FactoryBot.create(:automation_rule, projects: [project_2], is_for_all: false) }
    let!(:project_2_trigger) { FactoryBot.create(:automation_trigger, automation_rule: project_2_automation_rule) }

    let(:entity) { nil }
    let(:options) { {} }
    subject { described_class.trigger_scope(entity, options).to_a }

    context "when no project context is available" do
      it "returns global and enabled triggers" do
        is_expected.to eq([global_trigger])
      end
    end

    context "when entity has project" do
      let(:entity) { FactoryBot.create(:issue, project: project_1) }

      it "returns global and specific project triggers" do
        is_expected.to match_array([global_trigger, project_1_trigger])
      end
    end

    context "when options has project" do
      let(:options) { { project: project_2 } }

      it "returns global and specific project triggers" do
        is_expected.to match_array([global_trigger, project_2_trigger])
      end
    end
  end

  describe "#triggered?" do
    let(:trigger) { FactoryBot.create(:automation_trigger) }

    subject { trigger.triggered? }

    it { is_expected.to be true }
  end
end

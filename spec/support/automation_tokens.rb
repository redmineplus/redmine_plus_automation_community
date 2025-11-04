RSpec.shared_examples "automation token" do |token, expected_value_proc|
  context token do
    let(:value) { handler.value_for(token) }
    let(:expected_value) { instance_exec(&expected_value_proc) }

    it "returns the correct value for #{token}" do
      expect(value).to eq(expected_value)
    end
  end
end

RSpec.shared_examples "automation token with argument" do |token, expected_value_proc|
  let(:value) { handler.value_for(token, argument) }
  let(:expected_value) { instance_exec(&expected_value_proc) }

  it "returns correct value for #{token}" do
    expect(value).to eq(expected_value)
  end
end

RSpec.shared_examples "automation token handler" do |factory_name|
  describe "#value_for" do
    let(:object) { FactoryBot.create(factory_name) }
    let(:handler) { described_class.new(object) }

    described_class.allowlisted_attributes.each do |attribute|
      it_behaves_like "automation token", attribute.to_s, -> { object.public_send(attribute) }
    end

    described_class.allowlisted_associations.keys.each do |association|
      it_behaves_like "automation token", association.to_s, -> { object.public_send(association) }
    end

    described_class.allowlisted_custom_methods.each do |method|
      it_behaves_like "automation token", method.to_s, -> { handler.public_send(method) }
    end

    described_class.allowlisted_custom_associations.keys.each do |association|
      it_behaves_like "automation token", association.to_s, -> { handler.public_send(association) }
    end

    if described_class.custom_field_klass
      context "with custom fields" do
        let(:custom_field) do
          params = { is_for_all: true }
          params[:tracker_ids] = [object.tracker_id] if factory_name == :issue
          FactoryBot.create("#{factory_name}_custom_field".to_sym, params)
        end
        let(:custom_field_value) { "Custom Value" }

        before do
          object.reload.custom_field_values = { custom_field.id.to_s => custom_field_value }
          object.save!
        end

        it "returns the correct value for a custom field" do
          value = handler.value_for("cf_#{custom_field.id}")
          expect(value).to eq(custom_field_value)
        end
      end
    end
  end
end

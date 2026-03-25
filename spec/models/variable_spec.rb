# frozen_string_literal: true

require "rails_helper"

RSpec.describe Variable, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    context 'when type is boolean' do
      subject { build(:variable, variable_type: :boolean) }

      it { should validate_presence_of(:boolean_success_message) }
      it { should validate_presence_of(:boolean_false_message) }
    end
  end

  describe "associations" do
    it { should belong_to(:repository) }
  end

  describe ".instance_variable" do
    context ".formatted" do
      context "when format blank and the variable is not boolean" do
        let(:variable) { create(:variable, format: nil, variable_type: :string) }

        it "should return the original value" do
          formatted_value = variable.formatted("a")
          expect(formatted_value).to eq "a"
        end
      end

      context "when string" do
        let(:variable) { create(:variable, format: "&:%", variable_type: :string) }

        it "should return formatted value" do
          formatted_value = variable.formatted("50")
          expect(formatted_value).to eq "50%"
        end

        context "when value is nil" do
          it "should return blank formatted value" do
            formatted_value = variable.formatted(nil)
            expect(formatted_value).to eq ""
          end
        end
      end

      context "when boolean" do
        let(:variable) do
          create(:variable,
                 variable_type: :boolean,
                 boolean_success_message: "Success",
                 boolean_false_message: "Fail")
        end

        context "when value is true" do
          it 'should return success message' do
            formatted_value = variable.formatted(true)
            expect(formatted_value).to eq "Success"
          end
        end

        context "when value is false" do
          it "should return fail message" do
            formatted_value = variable.formatted(false)
            expect(formatted_value).to eq "Fail"
          end
        end
      end
    end
  end
end

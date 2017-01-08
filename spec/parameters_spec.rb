require 'spec_helper'

describe StrictParameters::Parameters do
  let :person_attributes do
    {
      name: 'Billy',
      height: '175',
      age: 25
    }
  end

  let :person_params do
    {
      person: person_attributes
    }
  end

  let :dog_params do
    {
      dog: {
        age: 10,
        name: 'Lassy',
        breed: 'bulldog'
      }
    }
  end

  let :multiple_params do
    person_params.merge(dog_params)
  end

  describe "[]" do
    before do
      @params = StrictParameters::Parameters.new(person_attributes)
    end

    it "returns stored keys" do
      expect(@params[:name]).to eq 'Billy'
    end

    it "returns nil when no record present" do
      expect(@params[:random]).to be_nil
    end
  end

  describe "[]=" do
    before do
      @params = StrictParameters::Parameters.new(person_attributes)
    end

    it "assigns value to stored keys" do
      @params[:name] = 'Bobby'
      expect(@params[:name]).to eq 'Bobby'
    end
  end

  describe "require_hash" do
    before do
      @params = StrictParameters::Parameters.new(multiple_params)
    end

    it "raises ParameterMissing when no selected keys are present" do
      expect { @params.require_hash(:anything) }.to raise_error StrictParameters::ParameterMissing, /'anything' is not present/
    end

    it "returns a Parameters object of the selected keys" do
      @multiple_params = @params.require_hash(:person)

      expect(@multiple_params.to_h).to eq person_attributes.with_indifferent_access
      expect(@multiple_params[:dog]).to be_nil
    end
  end

  describe "permit" do
    before do
      @params = StrictParameters::Parameters.new(person_attributes)
    end

    it "returns a Parameters object filted on selected keys" do
      @permitted = @params.permit(
        name: StrictParameters::StringFilter,
        height: StrictParameters::IntegerFilter
      )
      expect(@permitted.to_h).to eq('name' => 'Billy', 'height' => 175)
    end

    it "supports array formatted key-type pairs" do
      @permitted = @params.permit([
          [:name, StrictParameters::StringFilter],
          [:height, StrictParameters::IntegerFilter]
        ]
      )
      expect(@permitted.to_h).to eq('name' => 'Billy', 'height' => 175)
    end

    it "returns an empty Parameters object on non key-type pair parameters" do
      expect(@params.permit(:name)).to be_empty
    end

    it "ignores ignores unmarched filters" do
      @permitted = @params.permit(potato: StrictParameters::StringFilter)
      expect(@permitted.to_h).to be_empty
    end

    it "raises FilterKeyUnsupported on unsupported key objects" do
      expect{ @params.permit(['keys'] => StrictParameters::StringFilter) }.to raise_error(
        StrictParameters::FilterKeyUnsupported,
        "filter key unsupported: 'Array'. Use String or Symbol."
      )
    end

    it "raises FilterTypeUnsupported on unsupported filter objects" do
      expect{ @params.permit(potato: Hash) }.to raise_error StrictParameters::FilterTypeUnsupported, "filter type unsupported: 'Hash'"
    end

    it "raises ConversionUnsupported on object that incorrectly implements conversion" do
      elem = Object.new
      allow(elem).to receive(:to_s) { 10 }
      @params = StrictParameters::Parameters.new(name: elem)

      expect { @params.permit(name: StrictParameters::StringFilter) }.to raise_error(
        StrictParameters::ConversionUnsupported,
        /conversion of '.+?Object.+?' unsupported for 'StrictParameters::StringFilter'/
      )
    end
  end
end 

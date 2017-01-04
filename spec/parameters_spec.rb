require 'spec_helper'
require 'pry'

describe StrictParameters::Parameters do
  let :attribute_params do
    {
      name: 'Billy',
      age: 25
    }
  end

  let :person_params do
    {
      person: flat_params
    }
  end

  describe "[]" do
    before do
      @params = StrictParameters::Parameters.new(attribute_params)
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
      @params = StrictParameters::Parameters.new(attribute_params)
    end

    it "assigns value to stored keys" do
      @params[:name] = 'Bobby'
      expect(@params[:name]).to eq 'Bobby'
    end
  end
end 

require 'spec_helper'

describe Assignment do

  before do
    @assignment = Assignment.new
  end

  subject { @assignment }

  it { should respond_to(:user) }
  it { should respond_to(:role) }

  it { should be_valid }
end

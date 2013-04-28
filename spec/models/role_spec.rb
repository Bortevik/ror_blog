require 'spec_helper'

describe Role do

  before do
    @role = Role.new
  end

  subject { @role }

  it { should respond_to(:name) }
  it { should respond_to(:users) }
  it { should respond_to(:assignments) }
  
  it { should be_valid }
end

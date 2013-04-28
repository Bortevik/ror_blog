require 'spec_helper'

describe Assignment do

  before do
    @assignment = Assignment.new
  end

  it { should respond_to(:user) }
  it { should respond_to(:role) }
end

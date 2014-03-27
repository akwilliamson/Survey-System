require 'spec_helper'

require './lib/survey'

describe Survey do
  it { should validate_presence_of :name }
  it { should_not allow_value(/\A[a-zA-Z]+\z/).for(:name) }
end



require 'spec_helper'

require './lib/question'

describe Question do
  it { should validate_presence_of :description }
  it { should ensure_length_of(:description).is_at_most(100)}
end


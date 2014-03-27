class Survey < ActiveRecord::Base
  validates :name, :presence => true
  validates :name, :format => { :with => /\A[a-zA-Z]+\z/ }

  @@this_survey = nil

  def self.current_survey(name_of_survey)
    selected_survey = Survey.where(:name => name_of_survey).first
    @@this_survey = selected_survey
    self.currently
  end

  def self.currently
    @@this_survey
  end
end

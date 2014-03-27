class Question < ActiveRecord::Base
  validates :description, :presence => true, :length => { :maximum => 100 }

  @@this_question = nil

  def self.current_question(description)
    question = Question.where(:description => description).first
    @@this_question = question
    self.currently
  end

  def self.currently
    @@this_question
  end

end

require 'active_record'
require 'pry'

require './lib/survey'
require './lib/question'
require './lib/option'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def main_menu
puts "******************************************"
puts "Welcome to the A&M survey system!"
puts "If you are the survey designer, press 'd'."
puts "If you are a survey taker press 't'."
puts "Press 'x' to exit the program"
puts "******************************************"

  main_menu_choice=nil
  until main_menu_choice == 'x'

  main_menu_choice = gets.chomp.downcase
  system "clear"

    case main_menu_choice
    when 'd'
      design_menu
    when 't'
      taker_menu
    when 'x'
      puts "Goodbye"
      exit
    else
      puts "Please make a valid entry. 'd', 't' or 'x'"
    end
  end
end

def design_menu
  puts "********************************************************"
  puts "Please press 'c' to create a survey."
  puts "Please press 'l' to list your surveys by name."
  puts "Please press 'q' to add questions to an existing survey."
  puts "Please press 'w' to list questions for a survey."
  puts "Please press 'x' to exit."
  puts "********************************************************"
  design_menu_choice = gets.chomp
  system "clear"
  case design_menu_choice
  when 'c'
    create_survey
  when 'l'
    list_surveys
  when 'q'
    choose_survey
  when 'w'
    list_questions
  when 'x'
    exit
  else
  main_menu
  end
end

def create_survey
  puts "\nEnter the name of the survey:\n"
  survey_name = gets.chomp.capitalize
  new_survey = Survey.create(:name => survey_name)
    if new_survey.save
      puts "'*#{new_survey.name}' has been created.*"
    else
      puts "That wasn't a valid survey name:"
      new_survey.errors.full_messages.each { |message| puts message}
    end
  puts "Add another? 'y' for yes 'n' to exit"
  choice = nil
  until choice == 'n'
    choice = gets.chomp
    system "clear"

    case choice
    when 'y'
      create_survey
    when 'n'
      design_menu
    else
      puts "Try again idiot."
    end
  end
end

def list_surveys
  puts "Here are all of your surveys:"
  survey = Survey.all
  survey.each { |survey| puts survey.name }
  puts "Enter 'q' to list a surveys questions."
  puts "Enter 'x' to return to the design menu."
  choice = nil
  until choice == 'x'
    choice = gets.chomp.downcase
    case choice
    when 'x'
      design_menu
      system "clear"
    when 'q'
      puts "Enter survey name:"
      choice = gets.chomp.capitalize
      survey = Survey.current_survey(choice)
      list_questions
    else
      puts "Invalid entry. Please try again"
      list_surveys
    end
  end
end

def list_questions
  survey = Survey.currently
  puts "Here are your questions:"
  questions = Question.all.where({:survey_id => survey.id})
  questions.each { |question| puts question.description}
  puts "Press 'l' to list your surveys again."
  puts "Press 'x' to return to the designer menu."
  choice = nil
  until choice == 'x'
    choice = gets.chomp.downcase
      system "clear"

    case choice
    when 'x'
      design_menu
    when 'l'
      list_surveys
    end
  end
end

def choose_survey
  puts "Which survey would you like to add questions to?"
  Survey.all.each { |survey| puts survey.name }
  name = gets.chomp.capitalize
  survey = Survey.current_survey(name)
  add_questions
end

def add_questions
  survey = Survey.currently
  puts "Please add your question here:"
  new_description = gets.chomp
  question = Question.create(:description => new_description, :survey_id => survey.id)
  Question.current_question(new_description)
  puts "Press 'o' to add options to this question"
  puts "Press 'y' to add another question to this survey"
  puts "Press 's' to add questions to a different survey"
  puts "Press 'x' to exit"
  question_choice = nil
  until question_choice == 'x'
    question_choice = gets.chomp
    case question_choice
    when 'y'
      add_questions
    when 'o'
      add_options
    when 's'
      choose_survey
    when 'x'
      main_menu
    else
    end
  end
end

def add_options
  question = Question.currently
  puts "Please enter option A."
  option_A = gets.chomp
  puts "#{option_A} has been added."

  puts "Please enter option B."
  option_B = gets.chomp
  puts "#{option_B} has been added."

  puts "Please enter option C."
  option_C = gets.chomp
  puts "#{option_C} has been added."

  puts "Please enter option D."
  option_D = gets.chomp
  puts "#{option_D} has been added."

  options = Option.create(
    {:descriptionA => option_A,
     :descriptionB => option_B,
     :descriptionC => option_C,
     :descriptionD => option_D,
     :question_id => question.id}
  )
  system "clear"

  puts "Your options have all been added!"
  puts "Press 'y' to add another question to this survey"
  puts "Press 's' to add questions to a different survey"
  puts "Press 'x' to exit"
  choice = nil
  until choice == 'x'
    choice = gets.chomp
    system "clear"

    case choice
    when 'y'
      add_questions
    when 's'
      choose_survey
    when 'x'
      main_menu
    else
    end
  end
end

main_menu

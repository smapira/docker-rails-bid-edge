class Category < ActiveRecord::Base
  acts_as_nested_set
  acts_as_followable
end
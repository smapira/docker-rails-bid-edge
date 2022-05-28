class Post < ApplicationRecord
  acts_as_followable
  acts_as_follower
  acts_as_messageable
  def mailboxer_email(object)
    p object
  end
end

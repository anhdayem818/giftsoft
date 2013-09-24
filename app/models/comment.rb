class Comment < ActiveRecord::Base
   
  include ActsAsCommentable::Comment

  attr_accessible :comment, :user_id, :author_name, :product
  after_create :finalize
  #author_name is used to allow users who not logged in be able to give comments
  validates :author_name, :presence => true, :unless => :user_login?
  validates :comment, :presence => true
  validate :exclude_bots
  
  def exclude_bots
    expr = /href=|http:/
    errors.add(:comment, 'invalid comment') if self.comment.match(expr)
  end
  
  def user_login?
    self.user.present?
  end
  
  belongs_to :commentable, :polymorphic => true

  #default_scope :order => 'created_at ASC'

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user, :class_name=>"Spree::User"
  
  def finalize
    self.delay.send_notifies
  end
  def send_notifies
    self.commentable.comments.group(:user_id).includes(:user).each do |com|
      if(com.user.present? && !com.user.eql?(self.user) && com.user.username != "admin")
        self.commentable.notifications.create!(:user_id => com.user.id)
        CommentMailer.notify(self, com.user).deliver
      end
    end
    admin = Spree::User.find_by_username("admin")
    self.commentable.notifications.create!(:user_id => admin.id)
    CommentMailer.notify(self, admin).deliver
  end

  def author
    if self.user.present?
      self.user.username
    else
      self.author_name
    end
  end
end

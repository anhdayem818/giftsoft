class CommentMailer < ActionMailer::Base
  def notify(comment, user)
    @user = user
    @comment = comment
    subject = "#{Spree::Config[:site_name]} #{t(:new_comment)}"
    mail(:to => user.email,
        :subject => subject)
  end
end

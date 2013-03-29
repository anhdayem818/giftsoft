module Spree
  ProductsHelper.module_eval do
    def comment_class(comment)
      if comment.user.present? && comment.user.admin_group?
        "admin"
      end
    end
    
    def avatar(comment)
      if comment.user.present? 
        if comment.user.admin_group?
          "avatars/admin.png"
        else 
          if comment.user.vip?
            "avatars/vip.png"
          else
            "avatars/guess.jpg"
          end
        end        
      else
        "avatars/guess.png"
      end
    end
  end
end

module Spree
  ProductsHelper.module_eval do
    def comment_class(comment)
      if comment.user.present? && admin_group?(comment.user)
        "admin"
      end
    end
    
    def avatar(comment)
      if comment.user.present? 
        if admin_group?(comment.user)
          "avatars/admin.png"
        else 
          if vip_user?(comment.user)
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

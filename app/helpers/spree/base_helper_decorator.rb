Spree::BaseHelper.module_eval do
  def taxons_tree(root_taxon, current_taxon, max_level = 1)
    return '' if max_level < 1 || root_taxon.children.empty?
    content_tag :ul, :class => 'nav nav-list' do
      root_taxon.children.map do |taxon|
        css_class = (current_taxon && current_taxon.self_and_ancestors.include?(taxon)) ? 'current active' : nil
        content_tag :li, :class => css_class do
          link_to(taxon.name, seo_url(taxon)) +
          taxons_tree(taxon, current_taxon, max_level - 1)
        end
      end.join("\n").html_safe
    end
  end
  def related_ariticle(taxon)
    @related_article = Article.where("title like '%#{taxon.name}%'").try(:first) if taxon.present?
    if @related_article.present?
      link_to(@related_article.title, main_app.article_path(@related_article), :class=>"pull-right").html_safe
    end
  end
  
  def admin_group?(user)
    user.has_spree_role?("admin") || user.has_spree_role?("sale")
  end
  
  def vip_user?(user)
    user.orders.select(&:paid?).sum(&:total) > 1000000
  end
end

Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "add_tab_share_file_to_admin_tab",
                     :insert_bottom => "[data-hook='admin_tabs']",
                     :text => "<%= render 'spree/admin/share_files/tab' %>",
                     :disabled => false)


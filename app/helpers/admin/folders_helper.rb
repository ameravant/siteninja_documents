module Admin::FoldersHelper

def build_tree(parent_id=nil)
    children = @folders.select { |tree_folder| tree_folder.parent_id == parent_id }
    ul_id = "tree_#{parent_id || '0'}"
    unless children.empty?
      concat "<ul id=\"#{ul_id}\" class=\"sortable\">\n"

      # Output the list elements for these children, and recursively
      # call build_menu for their children.
      for child in children
        concat "<li id=\"#{dom_id child}\" style=\"border-top: #ccc 1px solid; \">" + '<div class="folder-title">'
        concat image_tag("#{move_loc}", :class => "icon handle", :alt => "handle") + ' ' if children.size > 1
        concat link_to(h(child.title), [:admin, child, :assets], :class => !child.visible ? 'gray' : nil)
        concat ' ' + content_tag('span', '&mdash; hidden', :class => ' small gray') unless child.visible
        concat '</div><div class="folder-options">'
        unless child.permalink == "folders"
          concat ' ' + icon("Write", edit_admin_folder_path(child))
          concat ' ' + trash_icon(child, admin_folder_path(child), "#{child.title}")
        else
          concat ' ' + "<div style='width: 44px; height: 4px; float: right;'></div>"
        end
        concat '</div><div class="folder-assets">'
        concat icon("Document", [:admin, child, :assets]) + ' ' + link_to(child.assets_count, [:admin, child, :assets])
        concat "</div>" + clear
        build_tree(child.id)
        concat "</li>\n"
      end
      concat "</ul>\n"

      # Make this list sortable if more than 1 child is listed
      if children.size > 1
        concat sortable_element(ul_id,
          :url => reorder_admin_folders_path + "?folder_id=#{(parent_id || 0)}",
          :method => :put,
          :loading => "$('ajax_spinner').src='#{spinner_loc}'; $('reorder_status').show();",
          :success => "$('ajax_spinner').src='#{ok_loc}'",
          :failure => "$('ajax_spinner').src='#{exclamation_loc}'",
          :complete => visual_effect(:fade, "reorder_status", :delay => 1)
        )
      end
    end
  end

end


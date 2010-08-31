class FoldersController < ApplicationController
  unloadable # http://dev.rubyonrails.org/ticket/6001
  before_filter :get_folder_or_404
  add_breadcrumb "Home", "root_path" 
  add_breadcrumb "Documents", "documents_path"

  def show
    @page = Page.find_by_permalink("documents")
    @footer_pages = Page.find(:all, :conditions => {:show_in_footer => true}, :order => :footer_pos )
    begin
      @folder_tmp = []
      build_tree(@folder)
      for folder in @folder_tmp.reverse
        unless folder == @folder
          add_breadcrumb folder.title, folder_path(folder)
        else  
          add_breadcrumb folder.title
        end
      end
    end
  end
private

  def build_tree(current_folder)
    if current_folder.permalink != "top-folder"
      @folder_tmp << current_folder
      parent_folder = current_folder.parent
      build_tree(parent_folder)
    end  
  end
  def get_folder_or_404
    if params[:id]
      @folder = Folder.find_by_permalink(params[:id])
    else
      @folder = Folder.find_by_permalink("top-folder")
    end
    render_404 if @folder.blank?
  end
end

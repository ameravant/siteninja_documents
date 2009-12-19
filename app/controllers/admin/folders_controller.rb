class Admin::FoldersController < AdminController
  unloadable # http://dev.rubyonrails.org/ticket/6001
  before_filter :authorization
  before_filter :find_folder, :only => [:edit, :update, :delete, :show]
  before_filter :get_folders, :only => [:edit, :new, :create]
  before_filter :build_options, :only => [ :edit, :new, :create ]
  # Configure breadcrumbs
  add_breadcrumb "Documents", "admin_folders_path"

  def index
    @folders = Folder.all
  end

  def edit
  end

  def show
  end

  def new
    @folder = Folder.new
  end

  def create
    @folder = Folder.new params[:folder]
    if @folder.save
      flash[:notice] = "#{@folder.title.titleize} folder created."
      redirect_to admin_folders_path
    else
      render :action => "new"
    end
  end

  def destroy
    begin
      @folder = Folder.find_by_permalink params[:id]
      @folder.destroy
      flash[:notice] = "#{@folder.title} has been deleted."
      respond_to do |wants|
        wants.js
      end
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = 'Something went wrong.'
    end
    # redirect_to admin_folders_path
  end

  def update
    @folder = Folder.find_by_permalink params[:id]
    if @folder.permalink == "top-folder"
      params[:folder][:parent_id] =""
    end
    # permalink does not get regenerated
    if @folder.update_attributes params[:folder]
      flash[:notice] = "#{@folder.title} folder updated."
      redirect_to admin_folders_path
    else
      render edit_admin_folders_path(@folder)
    end
  end

  def reorder
    params["tree_#{params[:folder_id]}"].each_with_index do |id, position|
      Folder.update(id, :position => position + 1)
    end
    render :nothing => true
  end

  def restore
    @folder = Folder.find_by_permalink params[:id]
    @folder.update_attributes(:status => 'visible')
    respond_to :js
  end

  private

  def get_folders
    @folders = Folder.all
    @options_for_parent_id = []
    @options_for_parent_id_level = 0
  end

  def find_folder
    begin
      @folder = Folder.find_by_permalink!(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_folders_path
    end
  end

  def build_options(parent_id=nil)
    children = @folders.select { |tree_folder| tree_folder.parent_id == parent_id }
    @options_for_parent_id_level = @options_for_parent_id_level + 1

    unless children.empty?
      for child in children
        nbsp_string = '&nbsp;' * (@options_for_parent_id_level * @options_for_parent_id_level) unless @options_for_parent_id_level == 1
        @options_for_parent_id << ["#{nbsp_string}#{child.title}", child.id]
        build_options(child.id)
      end
    end

    @options_for_parent_id_level = @options_for_parent_id_level - 1
  end

  def authorization
    authorize(@permissions['documents'], "Documents")
  end

end


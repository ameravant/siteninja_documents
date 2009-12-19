resources :folders

namespace :admin do |admin|
  admin.resources :folders, :collection => {:reorder => :put} do |folder|
    folder.resources :assets
  end
end

documents '/documents', :controller => "folders", :action => "show", :permalink => "top-folder"


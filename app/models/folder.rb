class Folder < ActiveRecord::Base
  has_many :assets, :as => :attachable, :dependent => :destroy
  has_permalink :title
  validates_presence_of :title
  default_scope :order => "parent_id, position"
  named_scope :visible, :conditions => {:visible => true}

  def to_param
    self.permalink
  end
  
  def children
  	Folder.find(:all, :conditions => ["parent_id = ?", self.id])
  end
  def parent
  	Folder.find(:first, :conditions => ["id = ?", self.parent_id])
  end

end

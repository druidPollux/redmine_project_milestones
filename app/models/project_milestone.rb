class ProjectMilestone < ActiveRecord::Base
  unloadable

  belongs_to :issue, :dependent => :destroy
  belongs_to :project
  belongs_to :tracker
  has_many :issues

  validates_presence_of :subject
  #validates_uniqueness_of :issue_id

  if Rails::VERSION::MAJOR < 3
    named_scope :for_project, lambda{ |project_id|
      if project_id.present?
        { :conditions =>
          {:project_id => project_id}
        }
      end
    }

    named_scope :exclude_issue, lambda{ |issue_id|
      if issue_id.present?
        {
          :conditions => ["issue_id <> ?", issue_id]
        }
      end
    }
  else
    scope :for_project, lambda{ |project_id|
      if project_id.present?
        { :conditions =>
          {:project_id => project_id}
        }
      end
    }

    scope :exclude_issue, lambda{ |issue_id|
      if issue_id.present?
        {
          :conditions => ["issue_id <> ?", issue_id]
        }
      end
    }
  end
end

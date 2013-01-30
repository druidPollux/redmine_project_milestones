require_dependency 'issue'

module ProjectMilestonesPlugin
  module IssuePatch
    def self.included(base)
      base.extend(ClassMethods)
      
      base.send(:include, InstanceMethods)
      
      base.class_eval do
        belongs_to :project_milestone

        after_save :recalculate_due_date, :if => "self.project_milestone.present? && self.project_milestone.issue.present? && (self.project_milestone.issue.due_date < self.due_date)"
      end

    end
      
    module ClassMethods

    end
    
    module InstanceMethods
      def recalculate_due_date
        milestone_issue = self.project_milestone.issue
        milestone_issue.due_date = self.due_date
        milestone_issue.current_journal.notes = "##{self.id}" #FIXME 
        milestone_issue.save      
      end
    end
  end
end

require 'redmine'

Redmine::Plugin.register :redmine_project_milestones do
  name 'Вехи'
  author 'Roman Shipiev'
  description 'Плагин позволяет создавать вехи проекта (по сути, специальные задачи). Вехи-задачи автоматически закрываются, если все задачи, от которых зависит веха -- закрыты.'
  version '0.0.1'
  url 'https://github.com/rubynovich/redmine_project_milestones'
  author_url 'http://roman.shipiev.me'
  
  project_module :project_milestones do  
    permission :manage_milestones, :project_milestones => [:index], :public => true
  end
  
  menu :project_menu, :project_milestones, {:controller => :project_milestones, :action => :index}, :caption => :label_milestones, :param => :project_id, :if => Proc.new{ true }, :require => :member #FIXME
end

if Rails::VERSION::MAJOR < 3
  require 'dispatcher'
  object_to_prepare = Dispatcher
else
  object_to_prepare = Rails.configuration
end

object_to_prepare.to_prepare do
  [:issue].each do |cl|
    require "project_milestones_#{cl}_patch"
  end

  [ 
    [Issue, ProjectMilestonesPlugin::IssuePatch]
  ].each do |cl, patch|
    cl.send(:include, patch) unless cl.included_modules.include? patch
  end
end


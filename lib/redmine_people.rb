# This file is a part of Redmine CRM (redmine_contacts) plugin,
# customer relationship management plugin for Redmine
#
# Copyright (C) 2011-2015 Kirill Bezrukov
# http://www.redminecrm.com/
#
# redmine_people is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# redmine_people is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with redmine_people.  If not, see <http://www.gnu.org/licenses/>.

require 'people_acl'

Rails.configuration.to_prepare do
  require_dependency 'redmine_people/helpers/redmine_people'

  require_dependency 'acts_as_attachable_global/init'
  require_dependency 'redmine_people/patches/user_patch'
  require_dependency 'redmine_people/patches/application_helper_patch'
  require_dependency 'redmine_people/patches/users_controller_patch'

  require_dependency 'redmine_people/hooks/views_layouts_hook'
end

module RedminePeople
  def self.available_permissions
    [:edit_people, :view_people, :add_people, :delete_people, :edit_departments, :delete_departments, :manage_tags, :manage_public_people_queries]
  end

  def self.settings() Setting[:plugin_redmine_people] end

  def self.users_acl() Setting.plugin_redmine_people[:users_acl] || {} end

  def self.default_list_style
    return 'list_excerpt'
  end

  def self.url_exists?(url)
    require_dependency 'open-uri'
    begin
      open(url)
      true
    rescue
      false
    end
  end

end

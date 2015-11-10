# encoding: utf-8
#
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

require File.expand_path('../../test_helper', __FILE__)

class PeopleQueryTest < ActiveSupport::TestCase
  fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :versions,
           :trackers,
           :projects_trackers,
           :issue_categories,
           :enabled_modules,
           :custom_fields,
           :custom_values,
           :custom_fields_projects,
           :custom_fields_trackers

  fixtures :email_addresses if ActiveRecord::VERSION::MAJOR >= 4

  RedminePeople::TestCase.create_fixtures(Redmine::Plugin.find(:redmine_people).directory + '/test/fixtures/',
                            [:people_information, :departments, :custom_fields, :custom_values, :queries])

  def setup
    # Remove accesses operations
    Setting.plugin_redmine_people = {}

    @query = PeopleQuery.new(:name => '_')
    @admin = Person.find(1)
    @person_2 = Person.find(2)
    @person_4 = Person.find(4)

    @queries = PeopleQuery.order('id').all
  end

  def test_visible_and_visible?
    assert_equal ['Private query 2', 'Public query 1'], PeopleQuery.visible(@admin).pluck(:name).sort
    assert_equal ['Private query 2', 'Private query 3', 'Public query 1'], PeopleQuery.visible(@person_4).pluck(:name).sort
    assert_equal ['Private query 2', 'Public query 1'], PeopleQuery.visible(@person_2).pluck(:name).sort

    assert @queries[0].visible?( @person_4 )
    assert @queries[1].visible?( @person_4 )
    assert @queries[2].visible?( @person_4 )

    assert @queries[0].visible?( @person_2 )
    assert (not @queries[2].visible?( @person_2 ))
  end

  def test_editable_by?
    assert @queries[1].editable_by?(@admin)
    assert @queries[1].editable_by?(@person_4)
    assert (not @queries[1].editable_by?(@person_2))

    PeopleAcl.create(@person_2.id, ['manage_public_people_queries'])

    assert @queries[1].editable_by?(@person_2)
  end
end

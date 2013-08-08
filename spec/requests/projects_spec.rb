require 'spec_helper'

describe 'projects requests' do
  subject { page }

  describe 'get /projects' do
    before do
      visit projects_path
    end

    it {
      should have_title 'Hei projects!'
    }

    it {
      should have_selector "a[href*='#{new_project_path}']"
    }

    it ( 'should have some project cards' ) {
      should have_css '.project-cards li.project', count: Project.count
    }

    context 'with updated project' do
      let ( :project ) { Project.find_by_title 'Hei' }

      before do
        # save so its updated_at is heigher than others
        # to make it first in the list
        project.description = 'updatd'
        project.save

        visit projects_path
      end

      it ( 'should have most recently updated first' ) {
        should have_selector "li[data-project-id=\"#{project.id}\"]:first-child"
      }
    end

    it ( 'should have a search form' ) {
      should have_selector "form[method='get'][action*='#{projects_path}']"
    }

    describe 'search for: Hei' do
      before do
        fill_in 'q', with: 'Hei'
      end

      it ( 'should only show Hei project card' ) {
        click_button 'Search'
        should have_css '.project-cards li.project', count: 1
      }

    end

  end

  describe 'get /projects/new' do
    before { visit new_project_path }

    it {
      should have_title 'Hei New Project!'
    }

    it ( 'should have an insert form & submit button' ) {
      should have_selector "form[method='post'][action*='#{projects_path}'] input[type='submit']"
    }

    describe 'submit invalid' do
      it ( 'should not create a project' ) {
        expect { click_button 'Create Project' }.not_to change( Project, :count )
      }
    end

    describe 'submit with title' do
      before {
        fill_in 'Title', with: 'Submit with title'
      }

      it ( 'should create a project' ) {
        expect {
          click_button 'Create Project'
        }.to change( Project, :count ).by( 1 )
      }
    end
  end

  describe 'get /projects/:id' do
    let ( :project ) { Project.find_by_title 'Hei' }

    before do
      visit project_path( project )
    end

    it {
      should have_title "Hei #{project.title}!"
    }

    it ( "should show all the project's tags" ) {
      should have_css '.facet_header', count: project.tags.count
    }

    it ( 'should have an edit link' ) {
      should have_selector "a[href*='#{edit_project_path( project )}']"
    }
  end

  describe 'get project w/o contact' do
    let ( :project ) { Project.find_by_title 'nil_contact' }

    before { visit project_path( project ) }

    it {
      should have_title "Hei #{project.title}!"
    }
  end

  describe 'get /projects/:id/edit' do
    let ( :project ) { Project.first }

    before { visit edit_project_path( project ) }

    it {
      should have_title "Hei #{project.title}!"
    }

    it ( 'should have an update form & submit button' ) {
      should have_selector "form[method='post'][action*='#{project_path( project )}'] input[type='submit']"
    }

    it ( 'should have some form inputs' ) {
      should have_selector 'select[name="project[organization_id]"]'
      should have_selector 'select[name="project[contact_id]"]'
      should have_selector 'input[type="text"][name="project[title]"]'
      should have_selector 'input[type="text"][name="project[description]"]'
      should have_selector 'input[type="url"][name="project[repository_url]"]'
      should have_selector 'input[type="url"][name="project[app_url]"]'
      should have_selector 'input[type="url"][name="project[micropost_url]"]'
      should have_selector 'input[type="url"][name="project[news_url]"]'
      should have_selector 'input[type="url"][name="project[documentation_url]"]'

      # dates?
      
      should have_selector 'input[type="text"][name="project[tag_list]"]'
    }
  end

end

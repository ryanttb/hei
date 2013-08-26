require 'spec_helper'

describe ( 'tasks/import' ) {
  let ( :config ) { Hei::Application.config.hei }

  subject { rendered }

  before {
    render
  }

  it {
    should have_selector 'h1', text: 'Import Projects'
  }

  it ( 'should have import form' ) {
    should have_selector "form[action*='#{tasks_import_path}'][method='post'][enctype='multipart/form-data']"

    should have_selector 'label', text: I18n.t( 'tasks_import_file_label' )
    should have_selector 'input[type="file"][name="projects_csv"]'

    should have_selector 'input[type="submit"][value="Import"]'
  }

  # moved to spec/requests but left here to reference
#  context ( 'with posting valid csv file' ) {
#    before {
#      @file = fixture_file_upload( '/files/people.csv' );
#    }
#
#    it ( 'should import projects from a csv' ) {
#      post :import, projects_csv: @file
#      response.should be_success
#    }
#  }
}
class YaleAccessionSlipsController < ApplicationController
  
  set_access_control  "view_repository" => [:non_print_slip]

  layout 'yale_accession_slips'

  def non_print_slip
    @accession = Accession.find(params[:id], find_opts)
    @print = params[:print] != '0'
    render template: 'accessions/non_print_slip'
  end

end


class YaleAccessionSlipsController < ApplicationController
  
  set_access_control  "view_repository" => [:non_print_slip]

  layout 'yale_accession_slips'

  def non_print_slip
    to_resolve = find_opts.fetch("resolve[]")
    to_resolve << 'payment_summary::payments::authorizer'

    @accession = Accession.find(params[:id], {
      "resolve[]" => to_resolve,
    })

    @print = params[:print] != '0'
    render template: 'accessions/non_print_slip'
  end

end


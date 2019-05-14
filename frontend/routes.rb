ArchivesSpace::Application.routes.draw do
  [AppConfig[:frontend_proxy_prefix], AppConfig[:frontend_prefix]].uniq.each do |prefix|
    scope prefix do
      match('/plugins/yale-accession-slips/non-print-slip/:id' => 'yale_accession_slips#non_print_slip', :via => [:get])
    end
  end
end

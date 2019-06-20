class YaleAccessionSlipsController < ApplicationController
  
  set_access_control  "view_repository" => [:non_print_slip]

  layout 'yale_accession_slips'

  java_import Java::org::apache::fop::apps::FopFactory
  java_import Java::org::apache::fop::apps::Fop
  java_import Java::org::apache::fop::apps::MimeConstants
  import javax.xml.transform.stream.StreamSource
  import javax.xml.transform.TransformerFactory
  import javax.xml.transform.sax.SAXResult

  def non_print_slip
    to_resolve = find_opts.fetch("resolve[]")
    to_resolve << 'payment_summary::payments::authorizer'
    @accession = Accession.find(params[:id], {
      "resolve[]" => to_resolve,
    })

    report_fo = render_to_string(:partial => 'accessions/non_print_slip.fo.erb').strip

    fo_file = ASUtils.tempfile("non_print_slip_fo")
    fo_file.write(report_fo)
    fo_file.close

    output_pdf_file = java.io.File.createTempFile("non_print_slip", "pdf")
    output_stream = java.io.FileOutputStream.new(output_pdf_file)

    begin
      input_stream = java.io.FileInputStream.new(fo_file.path)

      fopfac = FopFactory.newInstance
      fopfac.setBaseURL( File.join(ASUtils.find_base_directory, 'stylesheets') )
      fop = fopfac.newFop(MimeConstants::MIME_PDF, output_stream)
      transformer = TransformerFactory.newInstance.newTransformer()
      res = SAXResult.new(fop.getDefaultHandler)
      transformer.transform(StreamSource.new(input_stream), res)
    ensure
      output_stream.close
    end

    filename = "accession_#{params[:id]}_summary.pdf"

    respond_to do |format|
      format.all do
        fh = File.open(output_pdf_file.path, "r")
        self.headers["Content-type"] = "application/pdf"
        self.headers["Content-disposition"] = "attachment; filename=\"#{filename}\""
        self.response_body = Enumerator.new do |y|
          begin
            while chunk = fh.read(4096)
              y << chunk
            end
          ensure
            fh.close
            fo_file.unlink
          end
        end
      end
    end
  end
end


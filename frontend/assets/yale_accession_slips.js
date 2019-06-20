function NonPrintSlip() {
    this.name = 'yaleAccessionPrint_nonprint_slip';
    this.linkId = this.name + '_link';
    this.iframeId = this.name + '_iframe';

    this.setupLink();
}

NonPrintSlip.prototype.setupLink = function() {
    var self = this;

    var $li = $('<li>');
    var $a = $('<a>')
                .attr('href', APP_PATH + 'plugins/yale-accession-slips/non-print-slip/'+ ACCESSION_ID)
                .attr('target', '_blank')
                .html('Print accession record');

    $li.append($a);
    $('#other-dropdown > .dropdown-menu').append($li);
};

$(document).ready(function() {
    new NonPrintSlip();
});
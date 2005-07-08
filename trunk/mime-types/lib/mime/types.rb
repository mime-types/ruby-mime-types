# :title: MIME::Types
# :main: MIME::Types
#--
# MIME::Types for Ruby
# Version 1.13.1
#
# Copyright (c) 2002 - 2004 Austin Ziegler
#
# $Id$
#
# The ChangeLog contains all details on revisions.
#++
require 'mime/type'

module MIME #:nodoc:
    # = Introduction
    #
    # MIME types are used in MIME-compliant communications, as in e-mail or
    # HTTP traffic, to indicate the type of content which is transmitted.
    # MIME::Types provides the ability for detailed information about MIME
    # entities (provided as a set of MIME::Type objects) )to be determined and
    # used programmatically. There are many types defined by RFCs and vendors,
    # so the list is long but not complete; don't hesitate to ask to add
    # additional information. This library follows the IANA collection of MIME
    # types (see below for reference).
    #
    # = Description
    # MIME types are used in MIME entities, as in email or HTTP traffic. It is
    # useful at times to have information available about MIME types (or,
    # inversely, about files). A MIME::Type stores the known information about
    # one MIME type.
    #
    # == Synopsis
    #  require 'mime/types'
    #
    #  plaintext = MIME::Types['text/plain']
    #  print plaintext.media_type           # => 'text'
    #  print plaintext.sub_type             # => 'plain'
    #
    #  puts plaintext.extensions.join(" ")  # => 'asc txt c cc h hh cpp'
    #
    #  puts plaintext.encoding              # => 8bit
    #  puts plaintext.binary?               # => false
    #  puts plaintext.ascii?                # => true
    #  puts plaintext == 'text/plain'       # => true
    #  puts MIME::Type.simplified('x-appl/x-zip') # => 'appl/zip'
    #
    # This module is built to conform to the MIME types of RFC's 2045 and 2231.
    # It follows the official IANA registry at
    # http://www.iana.org/assignments/media-types/ and
    # ftp://ftp.iana.org/in-notes/iana/assignments/media-types/ and the
    # collection kept at http://www.ltsw.se/knbase/internet/mime.htp
    #
    # This is originally based on Perl MIME::Types.
    #
    # = Author
    #
    # Copyright:: Copyright (c) 2002 - 2004 by Austin Ziegler
    #             <mime-types@halostatue.ca>
    # Version::   1.13.1
    # Based On::  Perl
    #             MIME::Types[http://search.cpan.org/author/MARKOV/MIME-Types-1.13/MIME/Types.pm],
    #             Copyright (c) 2001-2004 by Mark Overmeer
    #             <mimetypes@overmeer.net>.
    # Licence::   Ruby's, Perl Artistic, or GPL version 2 (or later)
    # See Also::  http://www.iana.org/assignments/media-types/
    #             http://www.ltsw.se/knbase/internet/mime.htp
    #
  module Types
      # The released version of Ruby MIME::Types
    MIME_TYPES_VERSION      = '1.15'
      # The version of the data.
    DATA_VERSION = '1.15'

    TYPE_VARIANTS   = Hash.new { |h, k| h[k] = [] } #:nodoc:
    EXTENSION_INDEX = Hash.new { |h, k| h[k] = [] } #:nodoc:

    class <<self
      def add_type_variant(mime_type) #:nodoc:
        TYPE_VARIANTS[mime_type.simplified] << mime_type
      end

      def index_extensions(mime_type) #:nodoc:
        mime_type.extensions.each do |ext|
          EXTENSION_INDEX[ext] << mime_type
        end
      end

        # Returns a list of MIME::Type objects, which may be empty. The optional
        # flag parameters are :complete (finds only complete MIME::Types) and
        # :platform (finds only MIME::Types for the current platform). It is
        # possible for multiple matches to be returned for either type (in the
        # example below, 'text/plain' returns two values -- one for the general
        # case, and one for VMS systems.
        #
        #   puts "\nMIME::Types['text/plain']"
        #   MIME::Types['text/plain'].each { |t| puts t.to_a.join(", ") }
        #
        #   puts "\nMIME::Types[/^image/, :complete => true]"
        #   MIME::Types[/^image/, :complete => true].each do |t|
        #     puts t.to_a.join(", ")
        #   end
      def [](type_id, flags = {})
        if type_id.kind_of?(Regexp)
          matches = []
          TYPE_VARIANTS.each_key { |k| matches << TYPE_VARIANTS[k] if k =~ type_id }
          matches.flatten!
        elsif type_id.kind_of?(MIME::Type)
          matches = [type_id]
        else
          matches = TYPE_VARIANTS[MIME::Type.simplified(type_id)]
        end

        matches.delete_if { |e| not e.complete? } if flags[:complete]
        matches.delete_if { |e| not e.platform? } if flags[:platform]
        matches
      end

        # Return the list of MIME::Types which belongs to the file based on
        # its filename extension. If +platform+ is +true+, then only file
        # types that are specific to the current platform will be returned.
        #
        #   puts "MIME::Types.type_for('citydesk.xml') => "#{MIME::Types.type_for('citydesk.xml')}"
        #   puts "MIME::Types.type_for('citydesk.gif') => "#{MIME::Types.type_for('citydesk.gif')}"
      def type_for(filename, platform = false)
        ext = filename.chomp.downcase.gsub(/.*\./o, '')
        list = EXTENSION_INDEX[ext]
        list.delete_if { |e| not e.platform? } if platform
        list
      end

        # A synonym for MIME::Types.type_for
      def of(filename, platform = false)
        Types.type_for(filename, platform)
      end

        # Add one or more MIME::Type objects to the set of known types.
        # Each type should be experimental (e.g., 'application/x-ruby'). If the
        # type is already known, a warning will be displayed.
        #
        # <b>Please inform the maintainer of this module when registered
        # types are missing.</b>
      def add(*types)
        types.each do |mime_type|
          if TYPE_VARIANTS.include?(mime_type.simplified)
            if TYPE_VARIANTS[mime_type.simplified].include?(mime_type)
              warn "Type #{mime_type} already registered as a variant of #{mime_type.simplified}."
            end
          end
          MIME::Types.add_type_variant(mime_type)
          MIME::Types.index_extensions(mime_type)
        end
      end

        # Returns an array of hashes of simplified MIME types and encodings
        # for the specified filename extension. 
        #
        # Not currently unit tested -- the implementation purpose is as yet
        # unclear.
      def by_suffix(filename, platform = false)
        mime = Types.of(filename, platform)
        data = mime.inject([]) { |d, mt| d << { mt.content_type => mt.encoding } }
      end

        # Returns an array of hashes of MIME types by extension based on
        # lookup of the MIME type.
        #
        # Not currently unit tested -- the implementation purpose is as yet
        # unclear.
      def by_mediatype(mime_type)
        if mime_type["/"] or mime_type.kind_of?(Regexp)
          found = MIME::Types[mime_type]
        else
          found = MIME::Types[%r{mime_type}]
        end

        data = found.inject([]) do |d, mt|
          d << mt.extensions.map { |e| { e => { mt.content_type => mt.encoding } } }
        end
        data.flatten
      end
    end
  end
end

  # Build the type list
data_mime_type = <<MIME_TYPES
application/activemessage
application/andrew-inset		ez
application/appledouble					base64
application/applefile					base64
application/atomicmail
application/batch-SMTP
application/beep+xml
application/cals-1840
application/cnrp+xml
application/commonground
application/cpl+xml
application/cybercash
application/DCA-RFT
application/DEC-DX
application/dicom
application/dvcs
application/EDI-Consent
application/EDIFACT
application/EDI-X12
application/eshop
application/font-tdpfr			pfr
application/http
application/hyperstudio			stk
application/iges
application/index
application/index.cmd
application/index.obj
application/index.response
application/index.vnd
application/iotp
application/ipp
application/isup
application/mac-binhex40	hqx				8bit
application/macwriteii
application/marc
application/mathematica
application/mpeg4-generic
application/news-message-id
application/news-transmission
application/ocsp-request	orq
application/ocsp-response	ors
application/octet-stream	bin,dms,lha,lzh,exe,class,ani,pgp	base64
application/oda			oda
application/ogg			ogg
application/parityfec
application/pdf			pdf				base64
application/pgp-encrypted					7bit
application/pgp-keys						7bit
application/pgp-signature	sig				base64
application/pidf+xml
application/pkcs10		p10
application/pkcs7-mime		p7m,p7c
application/pkcs7-signature	p7s
application/pkix-cert		cer
application/pkixcmp		pki
application/pkix-crl		crl
application/pkix-pkipath	pkipath
application/postscript		ai,eps,ps			8bit
application/postscript		ps-z				base64
application/prs.alvestrand.titrax-sheet
application/prs.cww		cw,cww
application/prs.nprend		rnd,rct
application/prs.plucker
application/qsig
application/reginfo+xml
application/remote-printing
application/riscos
application/rtf			rtf				8bit
application/sdp
application/set-payment
application/set-payment-initiation
application/set-registration
application/set-registration-initiation
application/sgml
application/sgml-open-catalog	soc
application/sieve		siv
application/slate
application/smil		smi,smil
application/timestamp-query
application/timestamp-reply
application/toolbook		tbk
application/tve-trigger
application/vemmi
application/vnd.3gpp.pic-bw-large	plb
application/vnd.3gpp.pic-bw-small	psb
application/vnd.3gpp.pic-bw-var		pvb
application/vnd.3gpp.sms		sms
application/vnd.3M.Post-it-Notes
application/vnd.accpac.simply.aso
application/vnd.accpac.simply.imp
application/vnd.acucobol
application/vnd.acucorp		atc,acutc		7bit
application/vnd.adobe.xfdf	xfdf
application/vnd.aether.imp
application/vnd.amiga.amu	ami
application/vnd.anser-web-certificate-issue-initiation
application/vnd.anser-web-funds-transfer-initiation
application/vnd.audiograph
application/vnd.blueice.multipass	mpm
application/vnd.bmi
application/vnd.businessobjects
application/vnd.canon-cpdl
application/vnd.canon-lips
application/vnd.cinderella	cdy
application/vnd.claymore
application/vnd.commerce-battelle
application/vnd.commonspace
application/vnd.contact.cmsg
application/vnd.cosmocaller	cmc
application/vnd.criticaltools.wbs+xml	wbs
application/vnd.ctc-posml
application/vnd.cups-postscript
application/vnd.cups-raster
application/vnd.cups-raw
application/vnd.curl		curl
application/vnd.cybank
application/vnd.data-vision.rdz	rdz
application/vnd.dna
application/vnd.dpgraph
application/vnd.dreamfactory	dfac
application/vnd.dxr
application/vnd.ecdis-update
application/vnd.ecowin.chart
application/vnd.ecowin.filerequest
application/vnd.ecowin.fileupdate
application/vnd.ecowin.series
application/vnd.ecowin.seriesrequest
application/vnd.ecowin.seriesupdate
application/vnd.enliven
application/vnd.epson.esf
application/vnd.epson.msf
application/vnd.epson.quickanime
application/vnd.epson.salt
application/vnd.epson.ssf
application/vnd.ericsson.quickcall
application/vnd.eudora.data
application/vnd.fdf
application/vnd.ffsns
application/vnd.FloGraphIt
application/vnd.framemaker
application/vnd.fsc.weblauch	fsc			7bit
application/vnd.fujitsu.oasys
application/vnd.fujitsu.oasys2
application/vnd.fujitsu.oasys3
application/vnd.fujitsu.oasysgp
application/vnd.fujitsu.oasysprs
application/vnd.fujixerox.ddd
application/vnd.fujixerox.docuworks
application/vnd.fujixerox.docuworks.binder
application/vnd.fut-misnet
application/vnd.genomatix.tuxedo	txd
application/vnd.grafeq
application/vnd.groove-account
application/vnd.groove-help
application/vnd.groove-identity-message
application/vnd.groove-injector
application/vnd.groove-tool-message
application/vnd.groove-tool-template
application/vnd.groove-vcard
application/vnd.hbci		hbci,hbc,kom,upa,pkd,bpd
application/vnd.hhe.lesson-player	les
application/vnd.hp-HPGL		plt,hpgl	
application/vnd.hp-hpid
application/vnd.hp-hps
application/vnd.hp-PCL
application/vnd.hp-PCLXL
application/vnd.httphone
application/vnd.hzn-3d-crossword
application/vnd.ibm.afplinedata
application/vnd.ibm.electronic-media	emm
application/vnd.ibm.MiniPay
application/vnd.ibm.modcap
application/vnd.ibm.rights-management	irm
application/vnd.ibm.secure-container	sc
application/vnd.informix-visionary
application/vnd.intercon.formnet
application/vnd.intertrust.digibox
application/vnd.intertrust.nncp
application/vnd.intu.qbo
application/vnd.intu.qfx
application/vnd.ipunplugged.rcprofile	rcprofile
application/vnd.irepository.package+xml	irp
application/vnd.is-xpr
application/vnd.japannet-directory-service
application/vnd.japannet-jpnstore-wakeup
application/vnd.japannet-payment-wakeup
application/vnd.japannet-registration
application/vnd.japannet-registration-wakeup
application/vnd.japannet-setstore-wakeup
application/vnd.japannet-verification
application/vnd.japannet-verification-wakeup
application/vnd.jisp	jisp
application/vnd.kde.karbon	karbon
application/vnd.kde.kchart	chrt
application/vnd.kde.kformula	kfo
application/vnd.kde.kivio	flw
application/vnd.kde.kontour	kon
application/vnd.kde.kpresenter	kpr,kpt
application/vnd.kde.kspread	ksp
application/vnd.kde.kword	kwd,kwt
application/vnd.kenameapp	htke
application/vnd.kidspiration	kia
application/vnd.Kinar		kne,knp,sdf
application/vnd.koan
application/vnd.liberty-request+xml
application/vnd.llamagraphics.life-balance.desktop	lbd
application/vnd.llamagraphics.life-balance.exchange+xml	lbe
application/vnd.lotus-1-2-3	wks,123
application/vnd.lotus-approach
application/vnd.lotus-freelance
application/vnd.lotus-notes
application/vnd.lotus-organizer
application/vnd.lotus-screencam
application/vnd.lotus-wordpro
application/vnd.mcd		mcd
application/vnd.mediastation.cdkey
application/vnd.meridian-slingshot
application/vnd.micrografx.flo	flo
application/vnd.micrografx.igx	igx
application/vnd.mif		mif
application/vnd.minisoft-hp3000-save
application/vnd.mitsubishi.misty-guard.trustweb
application/vnd.Mobius.DAF
application/vnd.Mobius.DIS
application/vnd.Mobius.MBK
application/vnd.Mobius.MQY
application/vnd.Mobius.MSL
application/vnd.Mobius.PLC
application/vnd.Mobius.TXF
application/vnd.mophun.application	mpn
application/vnd.mophun.certificate	mpc
application/vnd.motorola.flexsuite
application/vnd.motorola.flexsuite.adsi
application/vnd.motorola.flexsuite.fis
application/vnd.motorola.flexsuite.gotap
application/vnd.motorola.flexsuite.kmr
application/vnd.motorola.flexsuite.ttc
application/vnd.motorola.flexsuite.wem
application/vnd.mozilla.xul+xml	xul
application/vnd.ms-artgalry	cil
application/vnd.ms-asf		asf
application/vnd.mseq		mseq
application/vnd.ms-excel	xls,xlt			base64
application/vnd.msign
application/vnd.ms-lrm		lrm
application/vnd.ms-powerpoint	ppt,pps,pot		base64
application/vnd.ms-project	mpp			base64
application/vnd.ms-tnef					base64
application/vnd.ms-works				base64
application/vnd.ms-wpl		wpl			base64
application/vnd.musician
application/vnd.music-niff
application/vnd.nervana		ent,entity,req,request,bkm,kcm
application/vnd.netfpx
application/vnd.noblenet-directory
application/vnd.noblenet-sealer
application/vnd.noblenet-web
application/vnd.nokia.radio-preset	rpst
application/vnd.nokia.radio-presets	rpss
application/vnd.novadigm.EDM
application/vnd.novadigm.EDX
application/vnd.novadigm.EXT
application/vnd.obn
application/vnd.osa.netdeploy
application/vnd.palm		prc,pdb,pqa,oprc
application/vnd.paos.xml
application/vnd.pg.format
application/vnd.pg.osasli
application/vnd.picsel		efif
application/vnd.powerbuilder6
application/vnd.powerbuilder6-s
application/vnd.powerbuilder7
application/vnd.powerbuilder75
application/vnd.powerbuilder75-s
application/vnd.powerbuilder7-s
application/vnd.previewsystems.box
application/vnd.publishare-delta-tree
application/vnd.pvi.ptid1	pti,ptid
application/vnd.pwg-multiplexed
application/vnd.pwg-xmhtml-print+xml
application/vnd.Quark.QuarkXPress	qxd,qxt,qwd,qwt,qxl,qxb		8bit
application/vnd.rapid
application/vnd.renlearn.rlprint
application/vnd.s3sms
application/vnd.sealed.doc	sdoc,sdo,s1w
application/vnd.sealed.eml	seml,sem
application/vnd.sealedmedia.softseal.html	stml,stm,s1h
application/vnd.sealedmedia.softseal.pdf	spdf,spd,s1a
application/vnd.sealed.mht	smht,smh
application/vnd.sealed.net
application/vnd.sealed.ppt	sppt,spp,s1p
application/vnd.sealed.xls	sxls,sxl,s1e
application/vnd.seemail		see
application/vnd.shana.informed.formdata
application/vnd.shana.informed.formtemplate
application/vnd.shana.informed.interchange
application/vnd.shana.informed.package
application/vnd.smaf			mmf
application/vnd.sss-cod
application/vnd.sss-dtf
application/vnd.sss-ntf
application/vnd.street-stream
application/vnd.sus-calendar	sus,susp
application/vnd.svd
application/vnd.swiftview-ics
application/vnd.syncml.ds.notification
application/vnd.triscape.mxs
application/vnd.trueapp
application/vnd.truedoc
application/vnd.ufdl
application/vnd.uiq.theme
application/vnd.uplanet.alert
application/vnd.uplanet.alert-wbxml
application/vnd.uplanet.bearer-choice
application/vnd.uplanet.bearer-choice-wbxml
application/vnd.uplanet.cacheop
application/vnd.uplanet.cacheop-wbxml
application/vnd.uplanet.channel
application/vnd.uplanet.channel-wbxml
application/vnd.uplanet.list
application/vnd.uplanet.listcmd
application/vnd.uplanet.listcmd-wbxml
application/vnd.uplanet.list-wbxml
application/vnd.uplanet.signal
application/vnd.vcx
application/vnd.vectorworks
application/vnd.vidsoft.vidconference	vsc		8bit
application/vnd.visionary		vis
application/vnd.visio			vsd,vst,vsw,vss
application/vnd.vividence.scriptfile
application/vnd.vsf
application/vnd.wap.sic			sic
application/vnd.wap.slc			slc
application/vnd.wap.wbxml		wbxml
application/vnd.wap.wmlc		wmlc
application/vnd.wap.wmlscriptc		wmlsc
application/vnd.webturbo		wtb
application/vnd.wordperfect		wpd
application/vnd.wqd			wqd
application/vnd.wrq-hp3000-labelled
application/vnd.wt.stf
application/vnd.wv.csp+wbxml		wv
application/vnd.wv.csp+xml					8bit
application/vnd.wv.ssp+xml					8bit
application/vnd.xara
application/vnd.xfdl
application/vnd.yamaha.hv-dic		hvd
application/vnd.yamaha.hv-script	hvs
application/vnd.yamaha.hv-voice		hvp
application/vnd.yamaha.smaf-audio	saf
application/vnd.yamaha.smaf-phrase	spf
application/vnd.yellowriver-custom-menu
application/watcherinfo+xml		wif
application/whoispp-query
application/whoispp-response
application/wita
application/wordperfect5.1	wp5,wp
application/x-123		wk
application/x-access
application/x-bcpio		bcpio
application/x-bleeper		bleep				base64
application/x-bzip2		bz2
application/x-cdlink		vcd
application/x-chess-pgn		pgn
application/x-clariscad
application/x-compress		z,Z				base64
application/x-cpio		cpio				base64
application/x-csh		csh				8bit
application/x-cu-seeme		csm,cu
application/x-debian-package	deb
application/x-director		dcr,dir,dxr
application/x-drafting
application/x-dvi		dvi				base64
application/x-dxf
application/x-excel
application/x-fractals
application/x-futuresplash	spl
application/x-ghostview		
application/x-gtar		gtar,tgz,tbz2,tbz		base64
application/x-gunzip
application/x-gzip		gz				base64
application/x-hdf		hdf
application/x-hep		hep
application/x-html+ruby		rhtml				8bit
application/xhtml+xml		xhtml				8bit
application/x-httpd-php		phtml,pht,php			8bit
application/x-ica		ica
application/x-ideas
application/x-imagemap		imagemap,imap			8bit
application/x-java-archive	jar
application/x-java-jnlp-file	jnlp
application/x-javascript	js				8bit
application/x-java-serialized-object	ser
application/x-java-vm		class
application/x-koan		skp,skd,skt,skm
application/x-latex		latex				8bit
application/x-lotus-123
application/x-mac-compactpro	cpt
application/x-maker		frm,maker,frame,fm,fb,book,fbdoc
application/x-mathcad
application/x-mif		mif
application/xml
application/xml-dtd
application/xml-external-parsed-entity
application/x-msaccess			mda,mdb,mde,mdf		base64
application/x-msdos-program	cmd,bat				8bit
application/x-msdos-program	com,exe				base64
application/x-msdownload	   				base64
application/x-msword		doc,dot,wrd			base64
application/x-netcdf		nc,cdf
application/x-ns-proxy-autoconfig	pac
application/x-pagemaker		pm5,pt5,pm
application/x-perl		pl,pm				8bit
application/x-pgp
application/x-python		py				8bit
application/x-quicktimeplayer	qtl
application/x-rar-compressed	rar				base64
application/x-remote_printing
application/x-ruby		rb,rbw				8bit
application/x-set
application/x-shar		shar				8bit
application/x-shockwave-flash	swf
application/x-sh		sh				8bit
application/x-SLA
application/x-solids
application/x-spss		sav,sbs,sps,spo,spp
application/x-stuffit		sit				base64
application/x-sv4cpio		sv4cpio				base64
application/x-sv4crc		sv4crc				base64
application/x-tar		tar				base64
application/x-tcl		tcl				8bit
application/x-texinfo		texinfo,texi			8bit
application/x-tex		tex				8bit
application/x-troff-man		man				8bit
application/x-troff-me		me
application/x-troff-ms		ms
application/x-troff		t,tr,roff			8bit
application/x-ustar		ustar				base64
application/x-vda
application/x-VMSBACKUP		bck			base64
application/x-wais-source	src
application/x-Wingz		wz
application/x-word							base64
application/x-wordperfect6.1	wp6
application/x-x400-bp
application/x-x509-ca-cert	crt				base64
application/zip			zip				base64
applivation/vnd.fints
audio/32kadpcm
audio/AMR			amr				base64
audio/AMR-WB			awb				base64
audio/basic			au,snd				base64
audio/CN
audio/DAT12
audio/dsr-es201108
audio/DVI4
audio/EVRC0
audio/EVRC			evc
audio/EVRC-QCP
audio/G722
audio/G.722.1
audio/G723
audio/G726-16
audio/G726-24
audio/G726-32
audio/G726-40
audio/G728
audio/G729
audio/G729D
audio/G729E
audio/GSM
audio/GSM-EFR
audio/L16			l16
audio/L20
audio/L24
audio/L8
audio/LPC
audio/MP4A-LATM
audio/MPA
audio/mpa-robust
audio/mpeg4-generic
audio/mpeg			mpga,mp2,mp3			base64
audio/parityfec
audio/PCMA
audio/PCMU
audio/prs.sid			sid,psid
audio/QCELP			qcp
audio/RED
audio/SMV0
audio/SMV-QCP
audio/SMV			smv
audio/telephone-event
audio/tone
audio/VDVI
audio/vnd.3gpp.iufp
audio/vnd.audiokoz		koz
audio/vnd.cisco.nse
audio/vnd.cns.anp1
audio/vnd.cns.inf1
audio/vnd.digital-winds		eol			7bit
audio/vnd.everad.plj		plj
audio/vnd.lucent.voice		lvp
audio/vnd.nokia.mobile-xmf	mxmf
audio/vnd.nortel.vbk		vbk
audio/vnd.nuera.ecelp4800	ecelp4800
audio/vnd.nuera.ecelp7470	ecelp7470
audio/vnd.nuera.ecelp9600	ecelp9600
audio/vnd.octel.sbc
audio/vnd.qcelp	
audio/vnd.rhetorex.32kadpcm
audio/vnd.sealedmedia.softseal.mpeg	smp3,smp,s1m
audio/vnd.vmx.cvsd
audio/x-aiff			aif,aifc,aiff			base64
audio/x-midi			mid,midi,kar			base64
audio/x-pn-realaudio-plugin	rpm
audio/x-pn-realaudio		rm,ram				base64
audio/x-realaudio		ra				base64
audio/x-wav			wav				base64
chemical/x-pdb			pdb
chemical/x-xyz			xyz
drawing/dwf			dwf
image/cgm
image/g3fax
image/gif			gif				base64
image/ief			ief				base64
image/jp2			jp2,jpg2
image/jpeg			jpeg,jpg,jpe			base64
image/jpm			jpm,jpgm
image/jpx			jpf,jpx
image/naplps
image/png			png				base64
image/prs.btif
image/prs.pti
image/t38
image/targa			tga
image/tiff-fx
image/tiff			tiff,tif			base64
image/vnd.cns.inf2
image/vnd.dgn			dgn
image/vnd.djvu			djvu,djv
image/vnd.dwg			dwg
image/vnd.dxf
image/vnd.fastbidsheet
image/vnd.fpx
image/vnd.fst
image/vnd.fujixerox.edmics-mmr
image/vnd.fujixerox.edmics-rlc
image/vnd.glocalgraphics.pgb		pgb
image/vnd.microsoft.icon		ico
image/vnd.mix
image/vnd.ms-modi			mdi
image/vnd.net-fpx
image/vnd.sealedmedia.softseal.gif	sgif,sgi,s1g
image/vnd.sealedmedia.softseal.jpg	sjpg,sjp,s1j
image/vnd.sealed.png			spng,spn,s1n
image/vnd.svf
image/vnd.wap.wbmp			wbmp
image/vnd.xiff
image/x-bmp			bmp
image/x-cmu-raster			ras
image/x-portable-anymap			pnm				base64
image/x-portable-bitmap			pbm				base64
image/x-portable-graymap		pgm				base64
image/x-portable-pixmap			ppm				base64
image/x-rgb				rgb				base64
image/x-xbitmap				xbm				7bit
image/x-xpixmap				xpm				8bit
image/x-xwindowdump			xwd				base64
message/CPIM
message/delivery-status
message/disposition-notification
message/external-body							8bit
message/http
message/news								8bit
message/partial								8bit
message/rfc822								8bit
message/s-http
message/sip
message/sipfrag
model/iges				igs,iges
model/mesh				msh,mesh,silo
model/vnd.dwf
model/vnd.flatland.3dml
model/vnd.gdl
model/vnd.gs-gdl
model/vnd.gtw
model/vnd.mts
model/vnd.parasolid.transmit.binary	x_b,xmt_bin
model/vnd.parasolid.transmit.text	x_t,xmt_txt		quoted-printable
model/vnd.vtu
model/vrml				wrl,vrml
multipart/alternative							8bit
multipart/appledouble							8bit
multipart/byteranges
multipart/digest							8bit
multipart/encrypted
multipart/form-data
multipart/header-set
multipart/mixed								8bit
multipart/parallel							8bit
multipart/related
multipart/report
multipart/signed
multipart/voice-message
multipart/x-gzip
multipart/x-mixed-replace
multipart/x-tar
multipart/x-ustar
multipart/x-www-form-urlencoded
multipart/x-zip
text/calendar
text/comma-separated-values		csv				8bit
text/css				css				8bit
text/directory
text/enriched
text/html				html,htm,htmlx,shtml,htx	8bit
text/parityfec
text/plain			txt,asc,c,cc,h,hh,cpp,hpp,dat,hlp	8bit
text/prs.fallenstein.rst		rst
text/prs.lines.tag
text/rfc822-headers
text/richtext				rtx				8bit
text/rtf				rtf				8bit
text/sgml				sgml,sgm
text/t140
text/tab-separated-values		tsv
text/uri-list
text/vnd.abc
text/vnd.curl
text/vnd.DMClientScript
text/vnd.flatland.3dml
text/vnd.fly
text/vnd.fmi.flexstor
text/vnd.in3d.3dml
text/vnd.in3d.spot
text/vnd.IPTC.NewsML
text/vnd.IPTC.NITF
text/vnd.latex-z
text/vnd.motorola.reflex
text/vnd.ms-mediapackage
text/vnd.net2phone.commcenter.command	ccc
text/vnd.sun.j2me.app-descriptor	jad				8bit
text/vnd.wap.si				si
text/vnd.wap.sl				sl
text/vnd.wap.wmlscript			wmls
text/vnd.wap.wml			wml
text/xml-external-parsed-entity
text/xml				xml,dtd				8bit
text/x-setext				etx
text/x-sgml				sgml,sgm			8bit
text/x-vCalendar			vcs				8bit
text/x-vCard				vcf				8bit
video/BMPEG
video/BT656
video/CelB
video/dl				dl				base64
video/DV
video/gl				gl				base64
video/H261
video/H263
video/H263-1998
video/H263-2000
video/JPEG
video/mj2				mj2,mjp2
video/MP1S
video/MP2P
video/MP2T
video/MP4V-ES
video/mpeg4-generic
video/mpeg				mp2,mpe,mpeg,mpg		base64
video/MPV
video/nv
video/parityfec
video/pointer
video/quicktime				qt,mov				base64
video/SMPTE292M
video/vnd.fvt				fvt
video/vnd.motorola.video
video/vnd.motorola.videop
video/vnd.mpegurl			mxu,m4u				8bit
video/vnd.nokia.interleaved-multimedia	nim
video/vnd.objectvideo			mp4
video/vnd.sealedmedia.softseal.mov	smov,smo,s1q
video/vnd.sealed.mpeg1			s11
video/vnd.sealed.mpeg4			smpg,s14
video/vnd.sealed.swf			sswf,ssw
video/vnd.vivo				viv,vivo
video/x-fli				fli				base64
video/x-ms-asf				asf,asx
video/x-msvideo				avi				base64
video/x-sgi-movie			movie				base64
x-chemical/x-pdb			pdb
x-chemical/x-xyz			xyz
x-conference/x-cooltalk			ice
x-drawing/dwf				dwf
x-world/x-vrml				wrl,vrml

# Exceptions
vms:text/plain				doc				8bit
mac:application/x-macbase64		bin
MIME_TYPES

os_re = %r{^(\w+):}o

data_mime_type.each do |i|
  item = i.chomp.strip.gsub(%r{#.*}o, '')
  next if item.empty?

  match = os_re.match(item)
  if match
    os = match.captures[0]
    item.gsub!(os_re, '')
  else
    os = nil
  end

  type, extensions, encoding = item.split

  if encoding.nil? and extensions and (extensions =~ MIME::Type::ENCODING_RE)
    encoding = extensions
    extensions = nil
  end

  extensions &&= extensions.split(%r{,}o)

  mime_type = MIME::Type.new(type) do |t|
    t.extensions = extensions
    t.system = os
    t.encoding = encoding
  end

  MIME::Types.add_type_variant(mime_type)
  MIME::Types.index_extensions(mime_type)
end

  # Reduce memory consumption.
os_re = nil
data_mime_type = nil

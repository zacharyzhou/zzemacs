(setq perldoc-obarray (make-vector 1519 nil))
;; Functions
(mapc (lambda (func)
         (set (intern func perldoc-obarray) t))
'(
"-A" "-B" "-C" "-M" "-O" "-R" "-S" "-T" "-W" "-X" "-b" "-c" "-d" "-e" "-f"
"-g" "-k" "-l" "-o" "-p" "-r" "-s" "-t" "-u" "-w" "-x" "-z" "abs" "accept"
"alarm" "atan2" "bind" "binmode" "bless" "break" "caller" "chdir" "chmod"
"chomp" "chop" "chown" "chr" "chroot" "close" "closedir" "connect"
"continue" "cos" "crypt" "dbmclose" "dbmopen" "defined" "delete" "die" "do"
"dump" "each" "endgrent" "endhostent" "endnetent" "endprotoent" "endpwent"
"endservent" "eof" "eval" "exec" "exists" "exit" "exp" "fcntl" "fileno"
"flock" "fork" "format" "formline" "getc" "getgrent" "getgrgid" "getgrnam"
"gethostbyaddr" "gethostbyname" "gethostent" "getlogin" "getnetbyaddr"
"getnetbyname" "getnetent" "getpeername" "getpgrp" "getppid" "getpriority"
"getprotobyname" "getprotobynumber" "getprotoent" "getpwent" "getpwnam"
"getpwuid" "getservbyname" "getservbyport" "getservent" "getsockname"
"getsockopt" "glob" "gmtime" "goto" "grep" "hex" "import" "index" "int"
"ioctl" "join" "keys" "kill" "last" "lc" "lcfirst" "length" "link" "listen"
"local" "localtime" "lock" "log" "lstat" "m" "map" "mkdir" "msgctl"
"msgget" "msgrcv" "msgsnd" "my" "next" "no" "oct" "open" "opendir" "ord"
"our" "pack" "package" "pipe" "pop" "pos" "print" "printf" "prototype"
"push" "q" "qq" "qr" "quotemeta" "qw" "qx" "rand" "read" "readdir"
"readline" "readlink" "readpipe" "recv" "redo" "ref" "rename" "require"
"reset" "return" "reverse" "rewinddir" "rindex" "rmdir" "s" "say" "scalar"
"seek" "seekdir" "select" "semctl" "semget" "semop" "send" "setgrent"
"sethostent" "setnetent" "setpgrp" "setpriority" "setprotoent" "setpwent"
"setservent" "setsockopt" "shift" "shmctl" "shmget" "shmread" "shmwrite"
"shutdown" "sin" "sleep" "socket" "socketpair" "sort" "splice" "split"
"sprintf" "sqrt" "srand" "stat" "state" "study" "sub" "substr" "symlink"
"syscall" "sysopen" "sysread" "sysseek" "system" "syswrite" "tell"
"telldir" "tie" "tied" "time" "times" "tr" "truncate" "uc" "ucfirst"
"umask" "undef" "unlink" "unpack" "unshift" "untie" "use" "utime" "values"
"vec" "wait" "waitpid" "wantarray" "warn" "write" "y"))

;; Modules
(mapc (lambda (mod)
         (intern mod perldoc-obarray))
'(
"AnyDBM_File" "App::Prove" "App::Prove::State" "App::Prove::State::Result"
"App::Prove::State::Result::Test" "Attribute::Handlers" "AutoLoader"
"AutoSplit" "B" "B::Concise" "B::Debug" "B::Deparse" "B::Lint"
"B::Lint::Debug" "B::Showlex" "B::Terse" "B::Xref" "Benchmark" "CGI"
"CGI::Apache" "CGI::Carp" "CGI::Cookie" "CGI::Fast" "CGI::Pretty"
"CGI::Push" "CGI::Switch" "CGI::Util" "CORE" "Carp" "Carp::Heavy"
"Class::ISA" "Class::Struct" "Config" "Config::Extensions" "Cwd" "DB"
"DBM_Filter" "DBM_Filter::compress" "DBM_Filter::encode"
"DBM_Filter::int32" "DBM_Filter::null" "DBM_Filter::utf8" "DB_File"
"Data::Dumper" "Devel::DProf" "Devel::InnerPackage" "Devel::PPPort"
"Devel::Peek" "Devel::SelfStubber" "Digest" "Digest::MD5" "Digest::base"
"Digest::file" "DirHandle" "Dumpvalue" "DynaLoader" "Emacs" "Emacs::EPL"
"Emacs::EPL::Debug" "Emacs::Forward" "Emacs::Lisp" "Encode" "Encode::Alias"
"Encode::Byte" "Encode::CJKConstants" "Encode::CN" "Encode::CN::HZ"
"Encode::Config" "Encode::EBCDIC" "Encode::Encoder" "Encode::Encoding"
"Encode::GSM0338" "Encode::Guess" "Encode::JP" "Encode::JP::H2Z"
"Encode::JP::JIS7" "Encode::KR" "Encode::KR::2022_KR"
"Encode::MIME::Header" "Encode::MIME::Header::ISO_2022_JP"
"Encode::MIME::Name" "Encode::PerlIO" "Encode::Supported" "Encode::Symbol"
"Encode::TW" "Encode::Unicode" "Encode::Unicode::UTF7" "English" "Env"
"Errno" "Error" "Error::Simple" "Exporter" "Exporter::Heavy"
"ExtUtils::Command" "ExtUtils::Command::MM" "ExtUtils::Constant"
"ExtUtils::Constant::Base" "ExtUtils::Constant::ProxySubs"
"ExtUtils::Constant::Utils" "ExtUtils::Constant::XS" "ExtUtils::Embed"
"ExtUtils::Install" "ExtUtils::Installed" "ExtUtils::Liblist"
"ExtUtils::Liblist::Kid" "ExtUtils::MM" "ExtUtils::MM_AIX"
"ExtUtils::MM_Any" "ExtUtils::MM_BeOS" "ExtUtils::MM_Cygwin"
"ExtUtils::MM_DOS" "ExtUtils::MM_Darwin" "ExtUtils::MM_MacOS"
"ExtUtils::MM_NW5" "ExtUtils::MM_OS2" "ExtUtils::MM_QNX"
"ExtUtils::MM_UWIN" "ExtUtils::MM_Unix" "ExtUtils::MM_VMS"
"ExtUtils::MM_VOS" "ExtUtils::MM_Win32" "ExtUtils::MM_Win95" "ExtUtils::MY"
"ExtUtils::MakeMaker" "ExtUtils::MakeMaker::Config"
"ExtUtils::MakeMaker::FAQ" "ExtUtils::MakeMaker::Tutorial"
"ExtUtils::Manifest" "ExtUtils::Miniperl" "ExtUtils::Mkbootstrap"
"ExtUtils::Mksymlists" "ExtUtils::Packlist" "ExtUtils::ParseXS"
"ExtUtils::testlib" "Fatal" "Fcntl" "File::Basename" "File::CheckTree"
"File::Compare" "File::Copy" "File::DosGlob" "File::Find" "File::Glob"
"File::Path" "File::Spec" "File::Spec::Cygwin" "File::Spec::Epoc"
"File::Spec::Functions" "File::Spec::Mac" "File::Spec::OS2"
"File::Spec::Unix" "File::Spec::VMS" "File::Spec::Win32" "File::Temp"
"File::stat" "FileCache" "FileHandle" "Filter::Simple" "Filter::Util::Call"
"FindBin" "Foomatic::DB" "Foomatic::Defaults" "Foomatic::PPD"
"Foomatic::UIElem" "GDBM_File" "Getopt::Long" "Getopt::Std" "Git"
"Hash::Util" "Hash::Util::FieldHash" "I18N::Collate" "I18N::LangTags"
"I18N::LangTags::Detect" "I18N::LangTags::List" "I18N::Langinfo" "IO"
"IO::Dir" "IO::File" "IO::Handle" "IO::Pipe" "IO::Poll" "IO::Seekable"
"IO::Select" "IO::Socket" "IO::Socket::INET" "IO::Socket::UNIX" "IPC::Msg"
"IPC::Open2" "IPC::Open3" "IPC::Semaphore" "IPC::SharedMem" "IPC::SysV"
"List::Util" "List::Util::PP" "List::Util::XS" "Locale::Constants"
"Locale::Country" "Locale::Currency" "Locale::Language" "Locale::Maketext"
"Locale::Maketext::Guts" "Locale::Maketext::GutsLoader"
"Locale::Maketext::TPJ13" "Locale::Script" "MIME::Base64"
"MIME::QuotedPrint" "Math::BigFloat" "Math::BigFloat::Trace" "Math::BigInt"
"Math::BigInt::Calc" "Math::BigInt::CalcEmu" "Math::BigInt::FastCalc"
"Math::BigInt::Trace" "Math::BigRat" "Math::Complex" "Math::Trig" "Memoize"
"Memoize::AnyDBM_File" "Memoize::Expire" "Memoize::ExpireFile"
"Memoize::ExpireTest" "Memoize::NDBM_File" "Memoize::SDBM_File"
"Memoize::Storable" "Module::Pluggable" "Module::Pluggable::Object"
"NDBM_File" "NEXT" "Net::Cmd" "Net::Config" "Net::Domain" "Net::FTP"
"Net::FTP::A" "Net::FTP::E" "Net::FTP::I" "Net::FTP::L"
"Net::FTP::dataconn" "Net::NNTP" "Net::Netrc" "Net::POP3" "Net::Ping"
"Net::SMTP" "Net::Time" "Net::hostent" "Net::libnetFAQ" "Net::netent"
"Net::protoent" "Net::servent" "O" "Opcode" "POSIX" "PerlIO"
"PerlIO::encoding" "PerlIO::scalar" "PerlIO::via"
"PerlIO::via::QuotedPrint" "Pod::Checker" "Pod::Escapes" "Pod::Find"
"Pod::Functions" "Pod::Html" "Pod::InputObjects" "Pod::LaTeX" "Pod::Man"
"Pod::ParseLink" "Pod::ParseUtils" "Pod::Parser" "Pod::Perldoc"
"Pod::Perldoc::BaseTo" "Pod::Perldoc::GetOptsOO" "Pod::Perldoc::ToChecker"
"Pod::Perldoc::ToMan" "Pod::Perldoc::ToNroff" "Pod::Perldoc::ToPod"
"Pod::Perldoc::ToRtf" "Pod::Perldoc::ToText" "Pod::Perldoc::ToTk"
"Pod::Perldoc::ToXml" "Pod::PlainText" "Pod::Plainer" "Pod::Select"
"Pod::Simple" "Pod::Simple::BlackBox" "Pod::Simple::Checker"
"Pod::Simple::Debug" "Pod::Simple::DumpAsText" "Pod::Simple::DumpAsXML"
"Pod::Simple::HTML" "Pod::Simple::HTMLBatch" "Pod::Simple::HTMLLegacy"
"Pod::Simple::LinkSection" "Pod::Simple::Methody" "Pod::Simple::Progress"
"Pod::Simple::PullParser" "Pod::Simple::PullParserEndToken"
"Pod::Simple::PullParserStartToken" "Pod::Simple::PullParserTextToken"
"Pod::Simple::PullParserToken" "Pod::Simple::RTF" "Pod::Simple::Search"
"Pod::Simple::SimpleTree" "Pod::Simple::Subclassing" "Pod::Simple::Text"
"Pod::Simple::TextContent" "Pod::Simple::TiedOutFH"
"Pod::Simple::Transcode" "Pod::Simple::TranscodeDumb"
"Pod::Simple::TranscodeSmart" "Pod::Simple::XHTML"
"Pod::Simple::XMLOutStream" "Pod::Text" "Pod::Text::Color"
"Pod::Text::Overstrike" "Pod::Text::Termcap" "Pod::Usage" "SDBM_File"
"Safe" "Scalar::Util" "Scalar::Util::PP" "Search::Dict" "SelectSaver"
"SelfLoader" "Shell" "Socket" "Storable" "Switch" "Symbol" "Sys::Hostname"
"Sys::Syslog" "TAP::Base" "TAP::Formatter::Base" "TAP::Formatter::Color"
"TAP::Formatter::Console" "TAP::Formatter::Console::ParallelSession"
"TAP::Formatter::Console::Session" "TAP::Formatter::File"
"TAP::Formatter::File::Session" "TAP::Formatter::Session" "TAP::Harness"
"TAP::Object" "TAP::Parser" "TAP::Parser::Aggregator"
"TAP::Parser::Grammar" "TAP::Parser::Iterator"
"TAP::Parser::Iterator::Array" "TAP::Parser::Iterator::Process"
"TAP::Parser::Iterator::Stream" "TAP::Parser::IteratorFactory"
"TAP::Parser::Multiplexer" "TAP::Parser::Result"
"TAP::Parser::Result::Bailout" "TAP::Parser::Result::Comment"
"TAP::Parser::Result::Plan" "TAP::Parser::Result::Pragma"
"TAP::Parser::Result::Test" "TAP::Parser::Result::Unknown"
"TAP::Parser::Result::Version" "TAP::Parser::Result::YAML"
"TAP::Parser::ResultFactory" "TAP::Parser::Scheduler"
"TAP::Parser::Scheduler::Job" "TAP::Parser::Scheduler::Spinner"
"TAP::Parser::Source" "TAP::Parser::Source::Perl" "TAP::Parser::Utils"
"TAP::Parser::YAMLish::Reader" "TAP::Parser::YAMLish::Writer"
"Term::ANSIColor" "Term::Cap" "Term::Complete" "Term::ReadLine" "Test"
"Test::Builder" "Test::Builder::Module" "Test::Builder::Tester"
"Test::Builder::Tester::Color" "Test::Harness" "Test::More" "Test::Simple"
"Test::Tutorial" "Text::Abbrev" "Text::Balanced" "Text::ParseWords"
"Text::Soundex" "Text::Tabs" "Text::Wrap" "Thread" "Thread::Queue"
"Thread::Semaphore" "Tie::Array" "Tie::File" "Tie::Handle" "Tie::Hash"
"Tie::Hash::NamedCapture" "Tie::Memoize" "Tie::RefHash" "Tie::Scalar"
"Tie::StdHandle" "Tie::SubstrHash" "Time::Local" "Time::gmtime"
"Time::localtime" "Time::tm" "UNIVERSAL" "Unicode::Collate"
"Unicode::Normalize" "Unicode::UCD" "User::grent" "User::pwent" "XSLoader"
"a2p" "attributes" "attrs" "autodie" "autodie::exception"
"autodie::exception::system" "autodie::hints" "autouse" "base" "bigint"
"bignum" "bigrat" "blib" "bytes" "charnames" "constant" "diagnostics"
"encoding" "encoding::warnings" "feature" "fields" "filetest" "if"
"integer" "less" "lib" "locale" "mro" "open.pod" "ops" "overload"
"overload::numbers" "overloading" "perl" "perl5004delta" "perl5005delta"
"perl5100delta" "perl5101delta" "perl561delta" "perl56delta" "perl570delta"
"perl571delta" "perl572delta" "perl573delta" "perl581delta" "perl582delta"
"perl583delta" "perl584delta" "perl585delta" "perl586delta" "perl587delta"
"perl588delta" "perl589delta" "perl58delta" "perl590delta" "perl591delta"
"perl592delta" "perl593delta" "perl594delta" "perl595delta" "perlaix"
"perlamiga" "perlapi" "perlapio" "perlapollo" "perlartistic" "perlbeos"
"perlbook" "perlboot" "perlbot" "perlbs2000" "perlcall" "perlce"
"perlcheat" "perlclib" "perlcn" "perlcommunity" "perlcompile" "perlcygwin"
"perldata" "perldbmfilter" "perldebguts" "perldebtut" "perldebug"
"perldelta" "perldgux" "perldiag" "perldoc" "perldos" "perldsc"
"perlebcdic" "perlembed" "perlepoc" "perlfaq" "perlfaq1" "perlfaq2"
"perlfaq3" "perlfaq4" "perlfaq5" "perlfaq6" "perlfaq7" "perlfaq8"
"perlfaq9" "perlfilter" "perlfork" "perlform" "perlfreebsd" "perlfunc"
"perlglossary" "perlgpl" "perlguts" "perlhack" "perlhaiku" "perlhist"
"perlhpux" "perlhurd" "perlintern" "perlintro" "perliol" "perlipc"
"perlirix" "perljp" "perlko" "perllexwarn" "perllinux" "perllocal"
"perllocale" "perllol" "perlmachten" "perlmacos" "perlmacosx" "perlmint"
"perlmod" "perlmodinstall" "perlmodlib" "perlmodstyle" "perlmpeix"
"perlmroapi" "perlnetware" "perlnewmod" "perlnumber" "perlobj" "perlop"
"perlopenbsd" "perlopentut" "perlos2" "perlos390" "perlos400" "perlothrtut"
"perlpacktut" "perlperf" "perlplan9" "perlpod" "perlpodspec" "perlport"
"perlpragma" "perlqnx" "perlre" "perlreapi" "perlrebackslash"
"perlrecharclass" "perlref" "perlreftut" "perlreguts" "perlrepository"
"perlrequick" "perlreref" "perlretut" "perlriscos" "perlrun" "perlsec"
"perlsolaris" "perlstyle" "perlsub" "perlsymbian" "perlsyn" "perlthrtut"
"perltie" "perltoc" "perltodo" "perltooc" "perltoot" "perltrap" "perltru64"
"perltw" "perlunicode" "perlunifaq" "perluniintro" "perlunitut" "perlutil"
"perluts" "perlvar" "perlvmesa" "perlvms" "perlvos" "perlwin32" "perlxs"
"perlxstut" "re" "sigtrap" "sort.pod" "strict" "subs" "threads"
"threads::shared" "utf8" "vars" "vendor_perl::Foomatic::DB"
"vendor_perl::Foomatic::Defaults" "vendor_perl::Foomatic::PPD"
"vendor_perl::Foomatic::UIElem" "vendor_perl::Git" "version"
"version::Internals" "vmsish" "warnings" "warnings::register"))

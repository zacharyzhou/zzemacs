# -*- coding: utf-8 -*-
"""$Id: sighandler.py,v 1.36 2009/03/07 04:20:25 rockyb Exp $
Handles signal handlers within Pydb.
"""
#TODO:
#  - Doublecheck handle_pass and other routines.
#  - can remove signal handler altogether when
#         ignore=True, print=False, pass=True
#     
#
import signal, types

def YN(bool):
    """Return 'Yes' for True and 'No' for False, and ?? for anything
    else."""
    if type(bool) != types.BooleanType:
        return "??"
    if bool:
        return "Yes"
    return "No"

def lookup_signame(num):
    """Find the corresponding signal name for 'num'. Return None
    if 'num' is invalid."""
    signames = signal.__dict__
    num = abs(num)
    for signame in signames.keys():
        if signames[signame] == num: return signame
        pass
    # Something went wrong. Should have returned above
    return

def lookup_signum(name):
    """Find the corresponding signal number for 'name'. Return None
    if 'name' is invalid."""
    uname = name.upper()
    if (uname.startswith('SIG') and hasattr(signal, uname)):
        return getattr(signal, uname)
    else:
        uname = "SIG"+uname
        if hasattr(signal, uname):
            return getattr(signal, uname)
        return None
    return # Not reached

def canonic_signame(name_num):
    """Return a signal name for a signal name or signal
    number.  Return None is name_num is an int but not a valid signal
    number and False if name_num is a not number. If name_num is a
    signal name or signal number, the canonic if name is returned."""
    signum = lookup_signum(name_num)
    if signum is None:
        # Maybe signame is a number?
        try:
            num = int(name_num)
            signame = lookup_signame(num)
            if signame is None:
                return None
        except:
            return False
        return signame
    
    signame = name_num.upper()
    if not signame.startswith('SIG'): return 'SIG'+signame
    return signame

fatal_signals = ['SIGKILL', 'SIGSTOP']

# I copied these from GDB source code.
signal_description = {
  "SIGHUP"    : "Hangup",
  "SIGINT"    : "Interrupt",
  "SIGQUIT"   : "Quit",
  "SIGILL"    : "Illegal instruction",
  "SIGTRAP"   : "Trace/breakpoint trap",
  "SIGABRT"   : "Aborted",
  "SIGEMT"    : "Emulation trap",
  "SIGFPE"    : "Arithmetic exception",
  "SIGKILL"   : "Killed",
  "SIGBUS"    : "Bus error",
  "SIGSEGV"   : "Segmentation fault",
  "SIGSYS"    : "Bad system call",
  "SIGPIPE"   : "Broken pipe",
  "SIGALRM"   : "Alarm clock",
  "SIGTERM"   : "Terminated",
  "SIGURG"    : "Urgent I/O condition",
  "SIGSTOP"   : "Stopped (signal)",
  "SIGTSTP"   : "Stopped (user)",
  "SIGCONT"   : "Continued",
  "SIGCHLD"   : "Child status changed",
  "SIGTTIN"   : "Stopped (tty input)",
  "SIGTTOU"   : "Stopped (tty output)",
  "SIGIO"     : "I/O possible",
  "SIGXCPU"   : "CPU time limit exceeded",
  "SIGXFSZ"   : "File size limit exceeded",
  "SIGVTALRM" : "Virtual timer expired",
  "SIGPROF"   : "Profiling timer expired",
  "SIGWINCH"  : "Window size changed",
  "SIGLOST"   : "Resource lost",
  "SIGUSR1"   : "User-defined signal 1",
  "SIGUSR2"   : "User-defined signal 2",
  "SIGPWR"    : "Power fail/restart",
  "SIGPOLL"   : "Pollable event occurred",
  "SIGWIND"   : "SIGWIND",
  "SIGPHONE"  : "SIGPHONE",
  "SIGWAITING": "Process's LWPs are blocked",
  "SIGLWP"    : "Signal LWP",
  "SIGDANGER" : "Swap space dangerously low",
  "SIGGRANT"  : "Monitor mode granted",
  "SIGRETRACT": "Need to relinquish monitor mode",
  "SIGMSG"    : "Monitor mode data available",
  "SIGSOUND"  : "Sound completed",
  "SIGSAK"    : "Secure attention"
  }


class SignalManager:
    """Manages Signal Handling information for the debugger

    - Do we print/not print when signal is caught
    - Do we pass/not pass the signal to the program
    - Do we stop/not stop when signal is caught

    Parameter pydb is an optional Pdb class. ignore is a list of
    signals to ignore. If you want no signals, use [] as None uses the
    default set. Parameter default_print specifies whether or not we
    print receiving a signals that is not ignored.

    All the methods which change these attributes return None on error, or
    True/False if we have set the action (pass/print/stop) for a signal
    handler.
    """
    def __init__(self, pydb=None, ignore_list=None, default_print=True):
        if pydb is None:
            import pydb
            self.pydb = pydb.Pdb()
        else:
            self.pydb = pydb
            pass
        self.sigs    = {}
        self.siglist = [] # List of signals. Dunno why signal doesn't provide.
    
        # Ignore signal handling initially for these known signals.
        if ignore_list is None:
            ignore_list = ['SIGALRM',    'SIGCHLD',  'SIGURG',
                           'SIGIO',      'SIGCLD',
                           'SIGVTALRM'   'SIGPROF',  'SIGWINCH',  'SIGPOLL',
                           'SIGWAITING', 'SIGLWP',   'SIGCANCEL', 'SIGTRAP',
                           'SIGTERM',    'SIGQUIT',  'SIGILL']
        self.ignore_list = ignore_list

        self.info_fmt='%-14s%-4s\t%-4s\t%-5s\t%-4s\t%s'
        self.header  = self.info_fmt % ('Signal', 'Stop', 'Print',
                                        'Stack', 'Pass',
                                        'Description')
        if default_print:
            default_print = self.pydb.msg

        for signame in signal.__dict__.keys():
            # Look for a signal name on this os.
            if signame.startswith('SIG') and '_' not in signame:
                self.siglist.append(signame)
                if signame not in fatal_signals + ignore_list:
                    self.sigs[signame] = self.SigHandler(signame, 
                                                         default_print,
                                                         self.pydb.set_next,
                                                         print_stack=False,
                                                         pass_along=False)
                    pass
                pass
            pass
        self.action('SIGINT stop print nostack nopass')
        return

    def check_and_adjust_sighandler(self, signame, sigs):
        """Check to see if a single signal handler that we are interested in
        has changed or has not been set initially. On return self.sigs[signame]
        should have our signal handler. True is returned if the same or adjusted,
        False or None if error or not found."""
        signum = lookup_signum(signame)
        try:
            old_handler = signal.getsignal(signum)
        except ValueError:
            # On some OS's (Redhat 8), SIGNUM's are listed (like
            # SIGRTMAX) that getsignal can't handle.
            if signame in self.sigs:
                sigs.pop(signame)
                pass
            return None
        if old_handler != self.sigs[signame].handle:
            if old_handler not in [signal.SIG_IGN, signal.SIG_DFL]:
                # save the program's signal handler
                sigs[signame].old_handler = old_handler
                pass
            # set/restore _our_ signal handler
            try:
                signal.signal(signum, self.sigs[signame].handle)
            except ValueError:
                # Probably not in main thread
                return False
            pass
        return True

    def check_and_adjust_sighandlers(self):
        """Check to see if any of the signal handlers we are interested in have
        changed or is not initially set. Change any that are not right. """
        for signame in self.sigs.keys():
            if not self.check_and_adjust_sighandler(signame, self.sigs):
                break
            pass
        return

    def is_name_or_number(self, name_num):
        signame = canonic_signame(name_num)
        if signame is None:
            self.pydb.errmsg(("%s is not a signal number I know about.") 
                             % name_num)
            return False
        elif False == signame:
            self.pydb.errmsg(("%s is not a signal name I know about.") 
                             % name_num)
            return False
        return signame

    def print_info_signal_entry(self, signame):
        """Print status for a single signal name (signame)"""
        if signame in signal_description:
            description=signal_description[signame]
        else:
            description=""
            pass
        if signame not in self.sigs.keys():
            # Fake up an entry as though signame were in sigs.
            self.pydb.msg(self.info_fmt
                          % (signame, 'No', 'No', 'No', 'Yes', description))
            return
            
        sig_obj = self.sigs[signame]
        self.pydb.msg(self.info_fmt % (signame,
                                       YN(sig_obj.stop_method  is not None),
                                       YN(sig_obj.print_method is not None),
                                       YN(sig_obj.pass_along),
                                       YN(sig_obj.print_stack),
                                       description
                                       ))
        return

    def info_signal(self, args):
        """Print information about a signal"""
        if len(args) == 0: return None
        signame = args[0]
        if signame in ['handle', 'signal']:
            # This has come from pydb's info command
            if len(args) == 1:
                # Show all signal handlers
                self.pydb.msg(self.header)
                self.pydb.msg("")
                for signame in self.siglist:
                    self.print_info_signal_entry(signame)
                return True
            else:
                signame = args[1]
                pass
            pass

        signame = self.is_name_or_number(signame)
        self.pydb.msg(self.header)
        self.print_info_signal_entry(signame)
        return True

    def action(self, arg):
        """Delegate the actions specified in 'arg' to another
        method.
        """
        if not arg:
            self.info_signal(['handle'])
            return True
        args = arg.split()
        signame = args[0]
        signame = self.is_name_or_number(args[0])
        if not signame: return

        if len(args) == 1:
            self.info_signal([signame])
            return True
        # We can display information about 'fatal' signals, but not
        # change their actions.
        if signame in fatal_signals:
            return None

        if signame not in self.sigs.keys():
            if signame in self.ignore_list:
                self.sigs[signame] = self.SigHandler(signame,
                                                     self.msg,
                                                     self.stop_next,
                                                     print_stack=False,
                                                     pass_along=False)
            else:
                self.pydb.errmsg('sighandler action: internal error')
                return None
            pass


        # multiple commands might be specified, i.e. 'nopass nostop'
        for attr in args[1:]:
            if attr.startswith('no'):
                on = False
                attr = attr[2:]
            else:
                on = True
            if 'stop'.startswith(attr):
                self.handle_stop(signame, on)
            elif 'print'.startswith(attr) and len(attr) >= 2:
                self.handle_print(signame, on)
            elif 'pass'.startswith(attr):
                self.handle_pass(signame, on)
            elif 'stack'.startswith(attr):
                self.handle_print_stack(signame, on)
            else:
                self.pydb.errmsg('Invalid arguments')
                pass
            pass
        return self.check_and_adjust_sighandler(signame, self.sigs)

    def handle_print_stack(self, signame, print_stack):
        """Set whether we stop or not when this signal is caught.
        If 'set_stop' is True your program will stop when this signal
        happens."""
        self.sigs[signame].print_stack = print_stack
        return print_stack

    def handle_stop(self, signame, set_stop):
        """Set whether we stop or not when this signal is caught.
        If 'set_stop' is True your program will stop when this signal
        happens."""
        if set_stop:
            self.sigs[signame].stop_method = self.pydb.set_next
            # stop keyword implies print AND nopass
            self.sigs[signame].print_method = self.pydb.msg
            self.sigs[signame].pass_along   = False
        else:
            self.sigs[signame].stop_method  = None
            pass
        return set_stop

    def handle_pass(self, signame, set_pass):
        """Set whether we pass this signal to the program (or not)
        when this signal is caught. If set_pass is True, Pydb should allow
        your program to see this signal.
        """
        self.sigs[signame].pass_along = set_pass
        if set_pass:
            # Pass implies nostop
            self.sigs[signame].stop_method = None
            pass
        return set_pass

    def handle_ignore(self, signame, set_ignore):
        """'pass' and 'noignore' are synonyms. 'nopass and 'ignore' are
        synonyms."""
        self.handle_pass(signame, not set_ignore)
        return set_ignore

    def handle_print(self, signame, set_print):
        """Set whether we print or not when this signal is caught."""
        if set_print:
            self.sigs[signame].print_method = self.pydb.msg
        else:
            self.sigs[signame].print_method = None
            pass
        return set_print

    ## SigHandler is a class private to SignalManager
    class SigHandler:
        """Store information about what we do when we handle a signal,

        - Do we print/not print when signal is caught
        - Do we pass/not pass the signal to the program
        - Do we stop/not stop when signal is caught

        Parameters:
           signame : name of signal (e.g. SIGUSR1 or USR1)
           print_method routine to use for "print"
           stop routine to call to invoke debugger when stopping
           pass_along: True is signal is to be passed to user's handler
        """
        def __init__(self, signame, print_method, stop_method,
                     print_stack=False, pass_along=True):

            self.signum = lookup_signum(signame)
            if not self.signum: return

            try:
                self.old_handler  = signal.getsignal(self.signum)
            except ValueError:
                # On some OS's (Redhat 8), SIGNUM's are listed (like
                # SIGRTMAX) that getsignal can't handle.
                if signame in self.sigs:
                    self.sigs.pop(signame)
                    pass
            self.pass_along   = pass_along
            self.print_method = print_method
            self.signame      = signame
            self.print_stack  = print_stack
            self.stop_method  = stop_method
            return

        def handle(self, signum, frame):
            """This method is called when a signal is received."""
            if self.print_method:
                self.print_method('\nProgram received signal %s'
                                  % self.signame)
            if self.print_stack:
                import traceback
                strings = traceback.format_stack(frame)
                for s in strings:
                    if s[-1] == '\n': s = s[0:-1]
                    self.print_method(s)
            if self.pass_along:
                # pass the signal to the program 
                if self.old_handler:
                    self.old_handler(signum, frame)
            if self.stop_method is not None:
                ## FIXME not sure if this is really right
                if frame.f_trace is None:
                    import pydb
                    pydb.debugger()
                else:
                    self.stop_method(frame)
                    pass
                pass
            return
        pass
    pass

# When invoked as main program, do some basic tests of a couple of functions
if __name__=='__main__':
    for b in (True, False,):
        print 'YN of %s is %s' % (repr(b), YN(b))
        pass
    for signum in range(signal.NSIG):
        signame = lookup_signame(signum)
        if signame is not None:
            assert(signum == lookup_signum(signame))
            # Try without the SIG prefix
            assert(signum == lookup_signum(signame[3:]))
            pass
        pass

    for i in (15, -15, 300):
        print 'lookup_signame(%d): %s' % (i, lookup_signame(i))
        pass
    
    for i in ('term', 'TERM', 'NotThere'):
        print 'lookup_signum(%s): %s' % (i, repr(lookup_signum(i)))
        pass
    
    for i in ('15', '-15', 'term', 'sigterm', 'TERM', '300', 'bogus'):
        print 'canonic_signame(%s): %s' % (i, canonic_signame(i))
        pass
    h = SignalManager()
    h.info_signal(["TRAP"])
    # Set to known value
    h.action('SIGUSR1')
    h.action('usr1 print pass stop')
    h.info_signal(['USR1'])
    # noprint implies no stop
    h.action('SIGUSR1 noprint')
    h.info_signal(['USR1'])
    h.action('foo nostop')
    # stop keyword implies print
    h.action('SIGUSR1 stop')
    h.info_signal(['SIGUSR1'])
    h.action('SIGUSR1 noprint')
    h.info_signal(['SIGUSR1'])
    h.action('SIGUSR1 nopass stack')
    h.info_signal(['SIGUSR1'])
    pass

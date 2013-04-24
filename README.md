[kcachegrind]: http://kcachegrind.sourceforge.net/html/Home.html
[fprof]: http://www.erlang.org/doc/man/fprof.html#analysis
[callgrind]: http://valgrind.org/docs/manual/cl-format.html

### Description

This escript converts erlang's fprof output to valgrind's callgrind output.

To generate the fprof output use `fprof:analyse({dest, "outfile.fprof"}).`. Do not use totals.

Converting to callgrind is simple, just type: `./erlgrind_script outfile.fprof outfile.cgrind`.

You must have escript in your PATH.

Then you can open outfile.cgrind with a tool like [kcachegrind][].

### Formats

For a description of fprof's format, check [fprof].

For a description of callgrind's format, check [callgrind].

### Usage

    Usage: erlgring [Options] <input file .trace/.analysis> [<output file>]
    Options:
        -p	use process pid as ELF object
    	-h	show this message

If you use a file with a `.trace` extension, erlgrind will treat it as a file generated with `fprof:trace`, automatically analyse it with `fprof:analyse` and proceed with the conversion.
The output file name is optional.

### Example

The fprof output:

<pre>
%% Analysis results:
{  analysis_options,
 [{callers, true},
  {sort, acc},
  {totals, false},
  {details, true}]}.

%                                               CNT       ACC       OWN        
[{ totals,                                       90,    0.330,    0.330}].  %%%


%                                               CNT       ACC       OWN        
[{ "&lt;0.33.0&gt;",                                   90,undefined,    0.330}].   %%

{[{{sort,quicksort,1},                            0,    0.269,    0.007},      
  {undefined,                                     0,    0.025,    0.018},      
  {{fprof,call,1},                                1,    0.018,    0.014}],     
 { {fprof,just_call,2},                           1,    0.312,    0.039},     %
 [{{sort,quicksort_div,4},                        1,    0.262,    0.004},      
  {{erlang,demonitor,1},                          1,    0.007,    0.007},      
  {{erlang,monitor,2},                            1,    0.004,    0.004},      
  {suspend,                                       1,    0.000,    0.000}]}.    

{[{undefined,                                     0,    0.269,    0.000},      
  {{erl_eval,do_apply,5},                         0,    0.036,    0.003}],     
 { {sort,quicksort,1},                            0,    0.305,    0.003},     %
 [{{fprof,just_call,2},                           0,    0.269,    0.007},      
  {{fprof,trace,1},                               1,    0.033,    0.004}]}.    

{[{{fprof,just_call,2},                           1,    0.262,    0.004},      
  {{sort,quicksort_div,4},                       64,    0.000,    0.185}],     
 { {sort,quicksort_div,4},                       65,    0.262,    0.189},     %
 [{{sort,merge,3},                                9,    0.073,    0.050},      
  {{sort,quicksort_div,4},                       64,    0.000,    0.185}]}.    

{[{{sort,quicksort_div,4},                        9,    0.073,    0.050}],     
 { {sort,merge,3},                                9,    0.073,    0.050},     %
 [{{erlang,'++',2},                               9,    0.023,    0.023}]}.    
 </pre>

Will generate the callgrind output: <br>

<pre>
events: Time
summary: 330
ob=&lt;0.33.0&gt;
fl=fprof
fn={fprof,just_call,2}
1 39
cfl=sort
cfn={sort,quicksort_div,4}
calls=1 1
1 262
cfl=erlang
cfn={erlang,demonitor,1}
calls=1 1
1 7
cfl=erlang
cfn={erlang,monitor,2}
calls=1 1
1 4
cfl=pseudo
cfn=suspend
calls=1 1
1 0
fl=sort
fn={sort,quicksort,1}
1 3
cfl=fprof
cfn={fprof,just_call,2}
calls=0 1
1 269
cfl=fprof
cfn={fprof,trace,1}
calls=1 1
1 33
fl=sort
fn={sort,quicksort_div,4}
1 189
cfl=sort
cfn={sort,merge,3}
calls=9 1
1 73
cfl=sort
cfn={sort,quicksort_div,4}
calls=64 1
1 0
fl=sort
fn={sort,merge,3}
1 50
cfl=erlang
cfn={erlang,'++',2}
calls=9 1
1 23
fl=erl_eval
fn={erl_eval,do_apply,5}
1 0
cfl=sort
cfn={sort,quicksort,1}
calls=0 1
1 36
fl=fprof
fn={fprof,trace,1}
1 4
cfl=fprof
cfn={fprof,call,1}
calls=1 1
1 29
fl=fprof
fn={fprof,call,1}
1 7
cfl=fprof
cfn={fprof,just_call,2}
calls=1 1
1 18
cfl=erlang
cfn={erlang,whereis,1}
calls=1 1
1 4
fl=erlang
fn={erlang,'++',2}
1 23
</pre>

Where:

- costs are in milliseconds
- ob is set as the Pid of the process that called the function
- file is set as the erlang module
- line numbers are hardcoded as 1

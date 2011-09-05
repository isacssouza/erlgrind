[kcachegrind]: http://kcachegrind.sourceforge.net/html/Home.html

Convert fprof profiling output to callgrind output.

To generate the fprof output use fprof:analyse([dest, "outfile.fprof"]). Do not use totals.

Converting to callgrind is simple, just type:
<code>./erlgrind_script outfile.fprof outfile.cgrind<code>

Then you can open outfile.cgrind with a tool like [kcachegrind][].

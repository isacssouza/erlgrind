Convert fprof profiling output to callgrind output.

To generate the fprof output use fprof:analyse([dest, "outfile.fprof"]). Do not use totals.

Converting to callgrind is simple, just type:
    ./erlgrind_script outfile.fprof outfile.cgrind

Then you can open outfile.cgrind with a tool like kcachegrind.

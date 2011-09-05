-module(erlgrind).

-export([convert/2]).


convert(InFileName, OutFileName) ->
    {ok, OutFile} = file:open(OutFileName, [write]),
    {ok, Terms} = file:consult(FileName),
    io:format(OutFile, "events: Instructions~n"),
    process_terms(OutFile, Terms).

process_terms(OutFile, []) ->
    file:close(OutFile);
process_terms(OutFile, [{analysis_options, _Opt} | Rest]) ->
    process_terms(OutFile, Rest);
process_terms(OutFile, [List | Rest]) when is_list(List) ->
    process_terms(OutFile, Rest);
process_terms(OutFile, [Entry | Rest]) ->
    process_entry(OutFile, Entry),
    process_terms(OutFile, Rest).

process_entry(OutFile, {Calling, Actual, Called}) ->
    process_actual(OutFile, Actual).

process_actual(_, {suspend, Cnt, Acc, Own}) ->
    ok;
process_actual(_, {garbage_collect, Cnt, Acc, Own}) ->
    ok;
process_actual(_, {undefined, Cnt, Acc, Own}) ->
    ok;
process_actual(OutFile, {{Mod, Func, Arity}, Cnt, Acc, Own}) ->
    io:format(OutFile, "fl=~w.erl~n", [Mod]),
    io:format(OutFile, "fn=~w_~w~n", [Func, Arity]),
    io:format(OutFile, "1 ~w~n", [Own]).

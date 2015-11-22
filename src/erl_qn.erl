-module(erl_qn).
%% Application callbacks
-export([start/2, stop/1]).
-export([putpolicy/3]).
-include("config.hrl").
%% ===================================================================
%% Application callbacks
%% ===================================================================


start(_StartType, _StartArgs) ->
    erl_qn_sup:start_link().

stop(_State) ->
    ok.

putpolicy(Bucket, Key, PutPolicy) ->
    {M, S, _} = os:timestamp(),
    Deadline = [{<<"deadline">>, ?UP_EXPIRES + 1000000 * M + S}],

    Scope1 = Bucket ++ ":" ++ Key ,
    Scope2 = Scope1 -- ":",
    Scope = [{<<"scope">>, list_to_binary(Scope2)}],

    PP1 = lists:append(PutPolicy, Deadline),
    PP2 = lists:append(PP1, Scope),
    PP3 = jsx:encode(PP2),

    binary:bin_to_list(PP3).

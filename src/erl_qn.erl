-module(erl_qn).
%% Application callbacks
-export([start/2, stop/1]).
-include("config.hrl").
%% ===================================================================
%% Application
%% ===================================================================


start(_StartType, _StartArgs) ->
    erl_qn_sup:start_link().

stop(_State) ->
    ok.
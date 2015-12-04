-module(erl_qn).
%% Application callbacks
-export([start/0]).

-define(APP, erl_qn).
%% ===================================================================
%% Application
%% ===================================================================


start() ->
    application:load(?APP),
    {ok, Apps} = application:get_key(?APP, applications),
    [application:start(App) || App <- Apps],
    application:start(?APP).
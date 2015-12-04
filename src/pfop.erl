%%%-------------------------------------------------------------------
%%% @author templex
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. Dec 2015 10:23 PM
%%%-------------------------------------------------------------------
-module(pfop).
-author("templex").

-include("config.hrl").
-import(http, [h_post/4]).
-import(auth, [requests_auth/3]).

%% API
-export([pfop/3, pfop/4, pfop/5, pfop/6]).


pfop(Bucket, Key, Fops) ->
    pfop(Bucket, Key, Fops, []).
pfop(Bucket, Key, Fops, NotifyURL) ->
    pfop(Bucket, Key, Fops, NotifyURL, []).
pfop(Bucket, Key, Fops, NotifyURL, Force) ->
    pfop(Bucket, Key, Fops, NotifyURL, Force, []).
pfop(Bucket, Key, Fops, NotifyURL, Force, Pipeline) ->
    Request_body = pfop_request_body(Bucket, Key, Fops, NotifyURL, Force, Pipeline),
    URL = ?API_HOST ++ "/pfop/",
    AUTH = requests_auth(URL, Request_body, ?DEF_CONTENT_TYPE),
    Headers = [{"Authorization", AUTH}],
    h_post(URL, Request_body, Headers, ?DEF_CONTENT_TYPE).


%%%%%↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑%%%%%
%%%%%↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ YOU NEED CARE ABOUT ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑%%%%%
%%%%%                                                                                                    %%%%%
%%%%%                                                                                                    %%%%%
%%%%%↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ SHIT HERE ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓%%%%%
%%%%%↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓%%%%%


pfop_request_body(Bucket, Key, Fops, NotifyURL, Force, Pipeline) ->
    if
        Pipeline == [] -> Pipeline1 = [];
        true -> Pipeline1 = "&pipeline=" ++ http_uri:encode(Pipeline)
    end,
    if
        Force == [] -> Force1 = [] ;
        true -> Force1 = "&force=" ++ Force
    end,
    if
        NotifyURL == [] -> NotifyURL1 = [];
        true -> NotifyURL1 = "&notifyURL=" ++ http_uri:encode(NotifyURL)
    end,
    "bucket=" ++ http_uri:encode(Bucket) ++ "&key=" ++ http_uri:encode(Key) ++ "&fops=" ++ http_uri:encode(Fops) ++ NotifyURL1 ++ Force1 ++ Pipeline1.
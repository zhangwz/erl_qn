%%%-------------------------------------------------------------------
%%% @author templex
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Nov 2015 9:47 AM
%%%-------------------------------------------------------------------
-module(auth).
-author("templex").

-include("config.hrl").

%% API

-export([upload_token/1, upload_token/2, upload_token/3]).
-export([private_download_url/1, private_download_url/2]).
%%-export([access_token/1]).
%%-export([verify_callback/3, verify_callback/4]).

upload_token(Bucket) ->
  upload_token(Bucket, ?DEF_KEY, ?DEF_PUTPOLICY).

upload_token(Bucket, Key) ->
  upload_token(Bucket, Key, ?DEF_PUTPOLICY).

upload_token(Bucket, Key, PutPolicy) ->

  Right_PutPolicy = maps:without(?PUTPOLICY, maps:from_list(PutPolicy)),
  URLbase64_PutPolicy = urlbase64(putpolicy(Bucket, Key, PutPolicy)),

  if
    Right_PutPolicy =:= #{} ->
      ?AK1 ++ ":" ++ sign(URLbase64_PutPolicy) ++ ":" ++ URLbase64_PutPolicy;
    Right_PutPolicy =/= #{} ->
      io:format("Please give me the FUCKING correct putpolicy ")
  end.

private_download_url(URL) ->
  private_download_url(URL, ?DOWN_EXPIRES).

private_download_url(URL, Down_Expires) ->
  DownloadURL = URL ++ "?e=" ++ integer_to_list(expires_time(Down_Expires)),
  DownloadURL ++ "&token=" ++ ?AK1 ++ ":" ++ sign(DownloadURL).

%%token_of_request(URL, Body, Content_type) ->


%%verify_callback(Origin_authorization, URL, Body) ->
 %% verify_callback(Origin_authorization, URL, Body, ?DEF_CONTENT_TYPE).

%%verify_callback(Origin_authorization, URL, Body, Content_type) ->


%%access_token()

expires_time(Expires) ->
  {M, S, _} = os:timestamp(),
  Expires + 1000000 * M  + S.

putpolicy(Bucket, Key, PutPolicy) ->
  Deadline = [{<<"deadline">>, expires_time(?UP_EXPIRES)}],

  Scope = [{<<"scope">>,
    list_to_binary(string:strip(Bucket ++ ":" ++ Key, right, $:))}],

  binary:bin_to_list(jsx:encode
  (lists:append
  (lists:append(PutPolicy, Deadline),
    Scope))).

urlbase64(Data) ->
  binary:bin_to_list(base64url:encode_mime(Data)).

sign(Data) ->
  binary:bin_to_list(base64url:encode_mime(crypto:hmac(sha, ?SK2, Data))).

token_of_request
token_of_request(URL, Body, Content_type) ->









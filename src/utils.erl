%%%-------------------------------------------------------------------
%%% @author templex
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Nov 2015 8:21 PM
%%%-------------------------------------------------------------------
-module(utils).
-author("templex").

-include_lib("kernel/include/file.hrl").
-include("config.hrl").

%% API
-compile(export_all).
%%-export([urlsafe_base64_decode/1]).
%%-export([entry/1, entry/2]).
%%-export([etag_small_stream/1, etag_small_file/1]).
%%-export([etag_big_file/1]).
%%  -export([etag_big_file_sha1_list/2]).

urlsafe_base64_encode(Data) ->
  binary:bin_to_list(base64url:encode_mime(Data)).

urlsafe_base64_decode(Data) ->
  binary:bin_to_list(base64url:decode(Data)).

entry(Bucket) ->
  entry(Bucket, []).

entry(Bucket, Key) ->
  Scope = string:strip(Bucket ++ ":" ++ Key, right, $:),
  urlsafe_base64_encode(Scope).

etag_file(Filename) ->
  {ok, FInfo} = file:read_file_info(Filename),
  Fsize = FInfo#file_info.size,

  if
    Fsize > ?BLOCK_SIZE ->
      if
        Fsize > 524288000 -> erlang:display("too big for this stupid thing");
        true -> etag_big_file(Filename, Fsize)
      end;
    true -> etag_small_file(Filename)
  end.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

etag_small_stream(Input_stream) ->
  urlsafe_base64_encode(erlang:iolist_to_binary([<<22>>, crypto:hash(sha, Input_stream)])).

etag_small_file(File_path) ->
  {ok, File_data} = file:read_file(File_path),
  etag_small_stream(File_data).

etag_big_file(Filename, Fsize) ->

  Etag_sha1_list = lists:sort(etag_big_file_sha1_list(Filename, Fsize)),
  urlsafe_base64_encode(erlang:iolist_to_binary([<<150>>, crypto:hash(sha, combine_sha1_list(Etag_sha1_list))])).

upmap(F, L) ->
  Parent = self(),
  Ref = make_ref(),
  [receive {Ref, Result} ->
    SHA1_maps = maps:new(),
    maps:merge(SHA1_maps, Result)
    end
    || _ <- [spawn(fun() -> Parent ! {Ref, F(X)} end) || X <- L]].

etag_big_file_get_thread(Fsize, Blocksize) ->
  Num_blocks = Fsize / Blocksize,
  Num_blocks2 = Fsize div Blocksize,
  if Num_blocks == Num_blocks2 ->
     Num_blocks2 - 1;
    Num_blocks =/= Num_blocks2 ->
       Num_blocks2
  end.

etag_big_file_sha1_list(Filename, Fsize)->
    Num_thread = etag_big_file_get_thread(Fsize, ?BLOCK_SIZE),
    upmap(fun (Off)->
      SHA1_maps_init = maps:new(),
      {ok, Fd} = file:open(Filename, [raw, binary]),
      {ok, Fd_bs} = file:pread(Fd, Off * ?BLOCK_SIZE, ?BLOCK_SIZE),
      SHA1 = crypto:hash(sha, Fd_bs),
      file:close(Fd),
      SHA1_off = maps:put(Off, SHA1, SHA1_maps_init),
      maps:merge(SHA1_maps_init, SHA1_off)
    end, lists:seq(0, Num_thread)).

combine_sha1_list([]) ->
  [];

combine_sha1_list([H|T]) ->
  [erlang:iolist_to_binary([<<>>,maps:values(H)]) | combine_sha1_list(T)].


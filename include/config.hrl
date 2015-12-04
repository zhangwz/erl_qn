%%%-------------------------------------------------------------------
%%% @author templex
%%% @copyright (C) 2015, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Nov 2015 8:41 AM
%%%-------------------------------------------------------------------
-author("templex").


%%Http
-define(API_HOST, "http://api.qiniu.com").
-define(RS_HOST, "http://rs.qiniu.com").
-define(RSF_HOST, "http://rsf.qbox.me").
-define(IO_HOST, "http://iovip.qbox.me").
-define(UP_HOST, "http://up.qiniu.com").
-define(DEF_CONNECT_TIMEOUT, 30).
-define(DEF_RETRY_TIME, 3).


%% account
%% NO.1 ak%sk
%% access_key
-define(AK1, "").
%% secret key
-define(SK1, "").
%% NO.2 ak%sk
%% access_key
-define(AK2, "MY_ACCESS_KEY").
%% secret key
-define(SK2, "MY_SECRET_KEY").


%% token parameters
-define(UP_EXPIRES, 3600).
-define(DOWN_EXPIRES, 3600).
-define(PUTPOLICY, [<<"callbackUrl">>, <<"callbackBody">>, <<"callbackHost">>, <<"callbackBodyType">>, <<"callbackFetchKEY">>,
                    <<"returnUrl">>, <<"returnBody">>,
                    <<"endUser">>, <<"saveKey">>, <<"insertOnly">>,
                    <<"detectMime">>, <<"mimeLimit">>, <<"fsizeLimit">>, <<"fsizeMin">>,
                    <<"persistenOps">>, <<"persistentNotifyUrl">>, <<"persistentPipeline">>]).

-define(EXAMPLE_PUTPOLICY, [{<<"callbackUrl">>, <<"http://1.1.1.1">>},{<<"insertOnly">>,1}]).
-define(DEF_PUTPOLICY, []).
-define(DEF_KEY, []).
-define(DEF_CONTENT_TYPE, "application/x-www-form-urlencoded").


%% connection
-define(CONNECTION_TIMEOUT, 30).
-define(CONNECTION_RETRIES, 3).
-define(CONNECTION_POOL, 10).


%% others
%% 4MB
-define(BLOCK_SIZE, 4194304).



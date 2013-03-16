%% Author:  smxx
%% Created: 2013-01-15
%% Description: 敏感词处理
-module(lib_words_ver).

%%
%% Include files
%%
-include("common.hrl").
-include("record.hrl").


-export([words_ver/1, words_filter/1, words_ver_name/1]).

%%
%% API Functions
%%
%% -----------------------------------------------------------------
%% 敏感词处理
%% -----------------------------------------------------------------
words_filter(Words_for_filter) ->
	Words_List = data_words:get_words_verlist(),
	binary:bin_to_list(lists:foldl(fun(Kword, Words_for_filter0)->
										   re:replace(Words_for_filter0,Kword,"*",[global,caseless,{return, binary}])
								   end,
								   Words_for_filter,Words_List)).

words_ver(Words_for_ver) ->
	Words_List = data_words:get_words_verlist(),
	BeMatch = lists:any(fun(Words) ->
				 case re:run(Words_for_ver, Words, [caseless]) of
							   nomatch -> false;
							   _-> true
						   end				 
			  end, Words_List),
	
	BeMatch =:= false.
		
words_ver_name(Words_for_ver) ->
	Words_List = data_words:get_words_verlist(),
	BeMatch = lists:any(fun(Words) ->
								case re:run(Words_for_ver, Words, [caseless]) of
									nomatch -> false;
									_-> true
								end				 
						end, Words_List),
	BeMatch =:= false.

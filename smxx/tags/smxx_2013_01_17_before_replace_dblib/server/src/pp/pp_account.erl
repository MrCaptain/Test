%%%--------------------------------------
%%% @Module  : pp_account
%%% @Author  : csj
%%% @Created : 2010.10.05
%%% @Description:用户账户管理
%%%--------------------------------------
-module(pp_account).
-export([handle/3]).
-include("common.hrl").
-include("record.hrl").
-include("debug.hrl").
-compile(export_all).

%% API Functions
handle(Cmd, Player, Data) ->
    ?TRACE("pp_account: Cmd:~p, Player:~p, Data:~p~n", [Cmd, Player, Data]),
    handle_cmd(Cmd, Player, Data).

%%登陆验证
handle_cmd(10000, [], Data) ->
    %暂不对用户进行验证
    %case is_bad_pass(Data) of
    %    true ->  Ret = true;
    %    _ -> 
    %        case config:get_strict_md5(server) of
    %            1 -> Ret = false;
    %            _ -> Ret = true
    %        end
    %end,
    Ret = true,
    case Ret of
        true ->
            [Accid, Accname, _Tstamp,  _Ts] = Data,
            case lib_account:get_role_list(Accid, Accname) of
                [] ->
                    L = [];
                [L] ->
                    []
            end,
            R = true;
        _ -> 
            L = [],
            R = false
    end,
    {R,L};

%% 创建角色
handle_cmd(10003, Socket, [Accid, Accname, Career, Sex, Name]) when is_integer(Accid) ->    
    %Name = lib_account:get_def_name(Accid),
    L = lib_account:get_role_list(Accid, Accname),
    case length(L) >= 1 of 
        true ->
            {ok, BinData} = pt_10:write(10003, [6,0]),  %% 用户已经创建角色
            lib_send:send_one(Socket, BinData);    
        false ->
            case validate_name(existed,[Name]) of  %% 角色名合法性检测
                   {false, Msg} ->
                        {ok, BinData} = pt_10:write(10003, [Msg, 0]),
                        lib_send:send_one(Socket, BinData);
                true ->
                    case lib_account:create_role(Accid, Accname, Name, Career, Sex) of
                         RoleId when is_integer(RoleId) ->
                            %%创建角色成功
                            %spawn(fun()->db_log_agent:insert_log_player(RoleId, Accid, Accname, Name, Sex, Career)end),
                            {ok, BinData} = pt_10:write(10003, [1, RoleId]),
                            lib_send:send_one(Socket, BinData);
                        _Other ->
                            %%角色创建失败
                            {ok, BinData} = pt_10:write(10003, [0, 0]),
                            lib_send:send_one(Socket, BinData)
                    end
            end
    end,
    ok;

%%心跳包
handle_cmd(10006, Socket, _R) ->
    {ok, BinData} = pt_10:write(10006, []),
    lib_send:send_one(Socket, BinData);

%%子socket返回状态
handle_cmd(10008,Socket,[Code,N]) ->
    {ok,BinData} = pt_10:write(10008,[Code,N]),
    lib_send:send_one(Socket,BinData);

%% 按照acid创建一个角色，或自动分配一个角色
handle_cmd(10010, _Socket, [Accid])->
    get_player_id(Accid);

handle_cmd(10020, _Socket, [Accid]) ->
    lib_account:getin_createpage(Accid);

handle_cmd(_Cmd, _Socket, _Data) ->
    {error, "handle_account no match"}.
 
%%根据acid取id。
get_player_id(Accid)->
    PlayerInfo = 
        case Accid =:= 0 of
            true -> [];
            false -> ?DB_MODULE:select_row(player, "id, nick", [{account_id, Accid}],[],[1])
        end,
    case PlayerInfo of
        [Id, Nickname]->
            {true, Accid, Id,  Nickname};
        []->
            %Ret = misc:get_http_content(config:get_guest_account_url(server)),
            %if Ret =:= "" andalso  Accid > 1000000 ->
            Ret = "",
            if Accid > 1000000 ->
                       {true, 0, 0,  <<>>};
               Accid < 1000000 ->
                    Career = util:rand(1,3),
                    Sex = util:rand(0,1),
                    Name = tool:to_binary(lists:concat(["GUEST-",Accid])),
                    Result = 
                    case lib_account:create_role(Accid, Name, Name, Career, Sex) of
                        {true, RoleId} ->
                            {true, Accid, RoleId, Name};
                        false ->
                            {true, 0, 0,  <<>>}
                    end,
                    Result;
               true ->
                  try
                        [New_Accid, Name] = string:tokens(Ret, "/"),
                        NewAccid = tool:to_integer(New_Accid),
                        Career = util:rand(1,5),
                        Sex = util:rand(1,2),
                        Result = 
                        case lib_account:create_role(NewAccid, Name, Name, Career, Sex) of
                            {true, RoleId} ->
                                {true, NewAccid, RoleId, Name};
                            false ->
                                {true, 0, 0,  <<>>}
                        end,
                        Result
                  catch
                        _:_ -> {true, 0, 0,  <<>>}
                  end
               end
    end.

%%通行证验证
is_bad_pass([_Accid, Accname, Tstamp,Cm, Ts]) ->    
    Md5 = Accname ++ integer_to_list(Tstamp) ++ ?TICKET ++ integer_to_list(Cm),
    Hex = util:md5(Md5),
    case Hex == Ts of
        true ->
            R = true;
        _ ->
            R = false
    end,
    R.

test_word() ->
    validate_name(sen_words, "绫乃酱").

%% 角色名合法性检测
validate_name([ Name]) ->
    validate_name(len, [ Name]).

%% 角色名合法性检测:长度
validate_name(len, [ Name]) ->
    case asn1rt:utf8_binary_to_list(list_to_binary(Name)) of
        {ok, CharList} ->
            Len = string_width(CharList),   
            case Len < 13 andalso Len > 1 of
                true ->
                    case name_ver(CharList) of
                        true ->
                            validate_name(existed, [Name]);
                        _ ->
                            {false, 4}
                    end;
                false ->
                    %%角色名称长度为1~6个汉字
                    {false, 5}
            end;
        {error, _Reason} ->
            %%非法字符
            {false, 4}
    end; 

%%判断角色名是否已经存在
%%Name:角色名
validate_name(existed, [ Name]) ->
    case lib_player:is_exists_name(Name) of
        true ->
            %角色名称已经被使用
            {false, 3};    
        false ->
            validate_name(sen_words, Name)
    end;

%%是否包含敏感词
%%Name:角色名
validate_name(sen_words, Name) ->
    case lib_words_ver:words_ver_name(Name) of
        true ->
            true;  
        false ->
            %包含敏感词
            {false, 8} 
    end;

validate_name(_, _Name) ->
    {false, 2}.

%% 字符宽度，1汉字=2单位长度，1数字字母=1单位长度
string_width(String) ->
    string_width(String, 0).
string_width([], Len) ->
    Len;
string_width([H | T], Len) ->
    case H > 255 of
        true ->
            string_width(T, Len + 2);
        false ->
            string_width(T, Len + 1)
    end.

name_ver(Names_for) ->
    Sumxx = lists:foldl(fun(Name_Char, Sum)->
        if
            Name_Char =:= 8226 orelse 
            Name_Char < 48 orelse 
            (Name_Char > 57 andalso 
             Name_Char < 65) orelse
             (Name_Char > 90 andalso
             Name_Char < 95) orelse
            (Name_Char > 122 andalso 
             Name_Char < 130) ->
                   Sum + 1;
       true -> Sum + 0
       end
    end, 0, Names_for),
    if 
        Sumxx =:= 0 ->
            true;
        true ->
            false
    end.

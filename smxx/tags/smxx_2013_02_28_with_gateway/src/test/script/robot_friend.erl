%% Author: Administrator
%% Created: 2012-11-10
%% Description: TODO: Add description to robot_friend
-module(robot_friend).

-compile(export_all).
-include("common.hrl").
-include("record.hrl").
	

handle(PlayerId, Socket) -> 
	Cmds = [58000, 58001, 58002, 58003, 58004, 58005, 58006, 58007, 
			58008, 58009, 58010, 58020, 58031, 58052, 58053], %% 58021
	
	Cmd = lists:nth(random:uniform(length(Cmds)), Cmds),

	handle_action(Cmd, PlayerId, Socket),
	ok.

handle_action(58000, _PlayerId, Socket) ->
    Data = <<>>,	
 	gen_tcp:send(Socket,robot:pack(58000, Data)),
	ok;

handle_action(58001, PlayerId, Socket) ->
    Data = <<PlayerId:32>>,	
 	gen_tcp:send(Socket,robot:pack(58001, Data)),
	ok;

handle_action(58002, PlayerId, Socket) ->
    Data = <<PlayerId:32>>,	
 	gen_tcp:send(Socket,robot:pack(58002, Data)),
	ok;

handle_action(58003, PlayerId, Socket) ->
	Type = util:rand(0, 1),
    Data = <<PlayerId:32, Type:8, 0:32>>,	
 	gen_tcp:send(Socket,robot:pack(58003, Data)),
	ok;

handle_action(58004, PlayerId, Socket) ->
    Data = <<PlayerId:32>>,	
 	gen_tcp:send(Socket,robot:pack(58004, Data)),
	ok;

handle_action(58005, _PlayerId, Socket) ->
    Data = <<>>,	
 	gen_tcp:send(Socket,robot:pack(58005, Data)),
	ok;

handle_action(58006, PlayerId, Socket) ->
    Data = <<PlayerId:32>>,	
 	gen_tcp:send(Socket,robot:pack(58006, Data)),
	ok;

handle_action(58020, _PlayerId, Socket) ->
    Data = <<>>,	
 	gen_tcp:send(Socket,robot:pack(58020, Data)),
	ok;

handle_action(58021, PlayerId, Socket) ->
    Data = <<PlayerId:32>>,	
 	gen_tcp:send(Socket,robot:pack(58021, Data)),
	ok;

handle_action(58031, PlayerId, Socket) ->
    Data = <<PlayerId:32>>,	
 	gen_tcp:send(Socket,robot:pack(58031, Data)),
	ok;

handle_action(58052, _PlayerId, Socket) ->
    Data = <<>>,	
 	gen_tcp:send(Socket,robot:pack(58052, Data)),
	ok;

handle_action(58053, _PlayerId, Socket) ->
    Data = <<>>,	
 	gen_tcp:send(Socket,robot:pack(58053, Data)),
	ok;



handle_action(Cmd, _PlayerId, Socket) ->
%% 	Msg1 = tool:to_binary(Msg),
%%     Len1 = byte_size(Msg1),
%%     Data = <<Len1:16, Msg1/binary>>,	
%% 	gen_tcp:send(Socket,robot:pack(Cmd, Data)),	
	ok.
	
	
	
	
	
	
	
	
	
	

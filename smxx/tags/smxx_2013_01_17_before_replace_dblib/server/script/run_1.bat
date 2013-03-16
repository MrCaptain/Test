cd ../config
werl +P 1024000 -smp disable -pa ../ebin -name game_server1@127.0.0.1 -setcookie game -boot start_sasl -config run_1  -s main server_start

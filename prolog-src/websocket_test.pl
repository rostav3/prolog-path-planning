% prolog websocket server test 
:- use_module(library(http/websocket)).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).

:- http_handler(root(ws), http_upgrade_to_websocket(echo, []), [spawn([])]).


default_port(8083).

start_server :-
    default_port(Port),
    http_server(http_dispatch, [port(Port)]).

stop_server :-
    default_port(Port),
    http_stop_server(Port, []).



next_cord(CUR_CORD, NEXT_CORD) :-
    NEXT_CORD is CUR_CORD+4. 

echo(WebSocket) :-
    ws_receive(WebSocket, Message, [format(json)]),
    (   Message.opcode==close
    ->  true
    ;   next_cord(Message.data, NEXT_CORD),
        write(Message.data),
        write(" -> "),
        writeln(NEXT_CORD),
        ws_send(WebSocket, text(NEXT_CORD)),
        echo(WebSocket)
    ).

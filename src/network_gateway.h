/*
================================================================================================================================

 network_gateway.h

 Simulator and Prolog networking

================================================================================================================================
*/


#ifndef PATH_PLANNING_NETWORK_GATEWAY_H
#define PATH_PLANNING_NETWORK_GATEWAY_H

#include <uWS/Hub.h>
#include <vector>
#include <string>
#include <thread>
#include <chrono>
#include <cmath>
#include <iostream>
#include "json.hpp"

/*--------------------------------------------------------------
 Handles simulator and prolog networking via websockets
--------------------------------------------------------------*/
class NetworkGateway {
 public:
  NetworkGateway();
  void start();
 private:
  static constexpr auto PROLOG_SERVER_ADDRESS = "ws://127.0.0.1:8083/ws";
  static constexpr int SIMULATOR_CLIENT_PORT = 4567;
  uWS::Hub websocket_hub;
  void init_simulator_networking();
  void init_prolog_networking();
};

#endif //PATH_PLANNING_NETWORK_GATEWAY_H

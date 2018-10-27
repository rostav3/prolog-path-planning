////
//// Created by Roman Smirnov on 27/10/2018.
////
////
//// Created by Roman Smirnov on 26/10/2018.
////
//
//#include <vector>
//#include <string>
//#include <thread>
//#include <chrono>
//#include <cmath>
//#include "json.hpp"
//#include "utils.cpp"
//
//#include "socket_hub.h"
//using std::vector;
//using std::cout;
//using std::cerr;
//using std::string;
//using std::endl;
//
//
//using json = nlohmann::json;
//
//static constexpr auto PROLOG_SERVER_ADDRESS = "ws://127.0.0.1:8083/ws";
//static constexpr int SIMULATOR_CLIENT_PORT = 4567;
//
//NetworkGateway::NetworkGateway() {
//
//}
//
//void NetworkGateway::init() {
//
//  websocket_hub.onMessage([](
//	  uWS::WebSocket<uWS::SERVER> ws, char *data, size_t length, uWS::OpCode opCode) {
//	// "42" at the start of the message means there's a websocket message event.
//	// The 4 signifies a websocket message
//	// The 2 signifies a websocket event
//	//auto sdata = string(data).substr(0, length);
//	//cout << sdata << endl;
//
//	if (length && length > 2 && data[0]=='4' && data[1]=='2') {
//
//	  auto s = utils::hasData(data);
//
//	  if (s!="") {
//		auto j = json::parse(s);
//
//		auto event = j[0].get<string>();
//
//		if (event=="qtelemetry") {
//		  // j[1] is the data JSON object
//
//		  // Main car's localization Data
//		  double car_x = j[1]["x"];
//		  double car_y = j[1]["y"];
//		  double car_s = j[1]["s"];
//		  double car_d = j[1]["d"];
//		  double car_yaw = j[1]["yaw"];
//		  double car_speed = j[1]["speed"];
//
//		  // Previous path data given to the Planner
//		  auto previous_path_x = j[1]["previous_path_x"];
//		  auto previous_path_y = j[1]["previous_path_y"];
//		  // Previous path's end s and d values
//		  double end_path_s = j[1]["end_path_s"];
//		  double end_path_d = j[1]["end_path_d"];
//
//		  // Sensor Fusion Data, a list of all other cars on the same side of the road.
//		  //					auto sensor_fusion = j[1]["sensor_fusion"];
//		  //					for (auto sf: sensor_fusion) {
//		  //						for(const auto &sf_val: sf){
//		  //							cout<<sf_val<<" ";
//		  //						}
//		  //						cout<<endl;
//		  //					}
//
//
//		  json msgJson;
//
//		  vector<double> next_x_vals;
//		  vector<double> next_y_vals;
//
//		  // TODO: define a path made up of (x,y) points that the car will visit sequentially every .02 seconds
//
//		  //		  double dist_inc = 0.9;
//		  //		  for (int i = 0; i < 50; ++i) {
//		  //			double next_s = car_s + (i + 1)*dist_inc;
//		  //			double next_d = 6;
//		  //			vector<double> xy = utils::getXY(next_s, next_d, map_waypoints_s, map_waypoints_x, map_waypoints_y);
//		  //			next_x_vals.push_back(xy[0]);
//		  //			next_y_vals.push_back(xy[1]);
//		  //		  }
//		  //		  msgJson["next_x"] = next_x_vals;
//		  //		  msgJson["next_y"] = next_y_vals;
//
//		  auto msg = "42[\"control\"," + msgJson.dump() + "]";
//
//		  //		  this_thread::sleep_for(chrono::milliseconds(1000));
//		  string lmsg = "4";
//		  websocket_hub.getDefaultGroup<uWS::CLIENT>().broadcast(lmsg.data(), lmsg.length(), uWS::OpCode::TEXT);
//		  ws.send(msg.data(), msg.length(), uWS::OpCode::TEXT);
//		}
//	  } else {
//		// Manual driving
//		string msg = "42[\"manual\",{}]";
//		ws.send(msg.data(), msg.length(), uWS::OpCode::TEXT);
//
//	  }
//	}
//  });
//
//  websocket_hub.onConnection([](uWS::WebSocket<uWS::SERVER> ws, uWS::HttpRequest req) {
//	cout << "CONNECTED TO SIMULATOR CLIENT" << endl;
//  });
//
//  websocket_hub.onDisconnection([](uWS::WebSocket<uWS::SERVER> ws, int code,
//								   char *message, size_t length) {
//	ws.close();
//	cout << "DISCONNECTED FROM SIMULATOR CLIENT" << endl;
//  });
//
//  if (websocket_hub.listen(SIMULATOR_CLIENT_PORT)) {
//	cout << "Listening to simulator on port " << SIMULATOR_CLIENT_PORT << endl;
//  } else {
//	cerr << "Failed to listen to simulator on port " << SIMULATOR_CLIENT_PORT << endl;
//	exit(EXIT_FAILURE);
//  }
//
//  /* LOGIC CALLBACKS */
//
//  websocket_hub.onError([](void *user) {
//	cerr << "ERROR ON CONNECTION ATTEMPT TO LOGIC SERVER" << endl;
//	exit(EXIT_FAILURE);
//  });
//
//  websocket_hub.onConnection([](uWS::WebSocket<uWS::CLIENT> ws, uWS::HttpRequest req) {
//	cout << "CONNECTED TO LOGIC SERVER " << endl;
//  });
//
//  websocket_hub.onMessage([](uWS::WebSocket<uWS::CLIENT> ws, char *data, size_t length, uWS::OpCode opCode) {
//	cout << "MESSAGE RECEIVED FROM LOGIC SERVER" << endl;
//	cout << (char) *data << endl;
//  });
//
//  websocket_hub.onDisconnection([](uWS::WebSocket<uWS::CLIENT> ws, int code, char *message, size_t length) {
//	cerr << "DISCONNECTED FROM LOGIC SERVER " << endl;
//	exit(EXIT_FAILURE);
//  });
//
//  websocket_hub.connect(PROLOG_SERVER_ADDRESS, (void *) 8);
//  websocket_hub.run();
//
//}
//
//
//

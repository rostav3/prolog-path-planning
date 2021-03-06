/*
================================================================================================================================

 plan_controller.cpp

 Implementation of class PlanController declared in plan_controller.h

================================================================================================================================
*/

#include "plan_controller.h"

using std::string;
using std::vector;
using std::cout;
using std::cerr;
using std::endl;

using json = nlohmann::json;


void PlanController::set_gateways(NetworkGateway *network_gateway, MapGateway *map_gateway) {
  PlanController::network_gateway = network_gateway;
  PlanController::map_gateway = map_gateway;
}


void PlanController::handle_simulator_message(char *data, size_t length) {
  if (map_gateway==nullptr || network_gateway==nullptr) {
	return;
  }

  if (length <= 2 || data[0]!='4' || data[1]!='2') {
	return;
  }

  auto msg_str = has_data(data);

  if (msg_str.empty()) {
	// Manual driving
	string msg = "42[\"manual\",{}]";
	network_gateway->send_message_to_simulator(msg);
	return;
  }

  auto j = json::parse(msg_str);
  auto event = j[0].get<string>();

  if (event!="telemetry") {
	return;
  }

  // Main car'msg_str localization Data
  double car_x = j[1]["x"];
  double car_y = j[1]["y"];
  double car_s = j[1]["s"];
  double car_d = j[1]["d"];
  double car_yaw = j[1]["yaw"];
  double car_speed = j[1]["speed"];

  // Previous path data given to the Planner
  auto previous_path_x = j[1]["previous_path_x"];
  auto previous_path_y = j[1]["previous_path_y"];
  // Previous path'msg_str end msg_str and d values
  double end_path_s = j[1]["end_path_s"];
  double end_path_d = j[1]["end_path_d"];

  // Sensor Fusion Data, a list of all other cars on the same side of the road.
  // 					auto sensor_fusion = j[1]["sensor_fusion"];
  // 					for (auto sf: sensor_fusion) {
  // 						for(const auto &sf_val: sf){
  // 							cout<<sf_val<<" ";
  // 						}
  // 						cout<<endl;
  // 					}

  json msgJson;
  vector<double> next_x_vals;
  vector<double> next_y_vals;

  // define a path made up of (x,y) points that the car will visit sequentially every .02 seconds
  for (int i = 0; i < 50; ++i) {
	double next_s = car_s + (i + 1)*DISTANCE_INCREMENT;
	double next_d = 6;

	vector<double> xy = map_gateway->frenet_to_xy(next_s, next_d);

	next_x_vals.push_back(xy[0]);
	next_y_vals.push_back(xy[1]);
  }

  msgJson["next_x"] = next_x_vals;
  msgJson["next_y"] = next_y_vals;

  auto msg = "42[\"control\"," + msgJson.dump() + "]";
  network_gateway->send_message_to_simulator(msg);
}


void PlanController::handle_prolog_message(char *data, size_t length) {
}


string PlanController::has_data(string msg_str) {
  auto found_null = msg_str.find("null");
  auto b1 = msg_str.find_first_of('[');
  auto b2 = msg_str.find_first_of('}');
  if (found_null!=string::npos) {
	return "";
  } else if (b1!=std::string::npos && b2!=std::string::npos) {
	return msg_str.substr(b1, b2 - b1 + 2);
  }
  return "";
}

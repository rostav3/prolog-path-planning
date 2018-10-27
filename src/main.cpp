//#include <fstream>
//#include <cmath>
//#include <chrono>
//#include <iostream>
//#include <thread>
//#include "Eigen-3.3/Eigen/Core"
//#include "Eigen-3.3/Eigen/QR"
//#include "spline.h"
//#include "network.h"
//#include "../third-party/precompiled.h"

#include "network_gateway.h"
#include <vector>
#include <string>
#include <fstream>
#include <sstream>

using std::vector;
using std::string;
using std::ifstream;
using std::istringstream;

int main() {
  // Load up map values for waypoint's x,y,s and d normalized normal vectors
  vector<double> map_waypoints_x;
  vector<double> map_waypoints_y;
  vector<double> map_waypoints_s;
  vector<double> map_waypoints_dx;
  vector<double> map_waypoints_dy;

  // Waypoint map to read from
  string map_file_ = "../data/highway_map.csv";
  // The max s value before wrapping around the track back to 0
  double max_s = 6945.554;

  ifstream in_map_(map_file_.c_str(), ifstream::in);

  string line;
  while (getline(in_map_, line)) {
	istringstream iss(line);
	double x;
	double y;
	float s;
	float d_x;
	float d_y;
	iss >> x;
	iss >> y;
	iss >> s;
	iss >> d_x;
	iss >> d_y;
	map_waypoints_x.push_back(x);
	map_waypoints_y.push_back(y);
	map_waypoints_s.push_back(s);
	map_waypoints_dx.push_back(d_x);
	map_waypoints_dy.push_back(d_y);
  }

  NetworkGateway network_gateway;
  network_gateway.start();
}



#include "gdexample.h"
#include "logging.h"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void GDExample::_bind_methods() {
}

GDExample::GDExample() {
	// Initialize any variables here.
	time_passed = 0.0;
}

GDExample::~GDExample() {
	// Add your cleanup here.

    log_error("Closing kinect");
    releaseKinect(this->kinect);
}

void GDExample::_process(double delta) {
    // Try to init the kinect once
    if (this->first) {
        log_error("Looking for a kinect");
        this->kinect = initializeKinect();
        this->first = false;
        if (this->kinect == nullptr) {
            log_error("No kinect found :(");
        }
    }

	time_passed += delta * 8.0;

	Vector2 new_position = Vector2(10.0 + (10.0 * sin(time_passed * 2.0)), 10.0 + (10.0 * cos(time_passed * 1.5)));

	set_position(new_position);
}

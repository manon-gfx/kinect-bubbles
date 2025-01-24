#include "kinect_node.h"
#include "logging.h"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void KinectNode::_bind_methods() {
}

KinectNode::KinectNode() {
	// Initialize any variables here.
}

KinectNode::~KinectNode() {
	// Add your cleanup here.

    log_error("Closing kinect");
    releaseKinect(this->kinect);
}

void KinectNode::_process(double delta) {
    // Try to init the kinect once
    if (this->first) {
        log_error("Looking for a kinect");
        this->kinect = initializeKinect();
        this->first = false;
        if (this->kinect == nullptr) {
            log_error("No kinect found :(");
        } else {
            log_error("Found a kinect :D %p", this->kinect);
        }
    }
}
